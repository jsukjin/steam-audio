# [CLAUDE.md](http://CLAUDE.md)

This file provides guidance to Claude Code ([claude.ai/code](http://claude.ai/code)) when working with code in this repository.

---

## Build System

The project uses **CMake** with a Python helper script. All build commands are run from `core/` (this directory).

### 1. Fetch dependencies

```bash
cd build
python get_dependencies.py
cd ..
```

### 2. Generate build files

```bash
# Windows x64 (Visual Studio 2019)
mkdir -p _out/windows-vs2019-x64 && cd _out/windows-vs2019-x64
python ../../build/build.py -p windows -t vs2019 -a x64 -o generate

# Minimal build (no Embree/IPP/GPU, fastest to set up)
python ../../build/build.py -p windows -t vs2019 -a x64 -o generate --minimal

# Linux x64
mkdir -p _out/linux-x64-release && cd _out/linux-x64-release
python ../../build/build.py -p linux -a x64 -c release -o generate
```

### 3. Build

```bash
python ../../build/build.py -p windows -t vs2019 -a x64 -o build
# or directly with CMake:
cmake --build . --config Release --parallel 8
```

### 4. Run tests

```bash
# Via CTest
ctest -C Release

# Run the test binary directly (supports Catch2 filters)
./bin/windows-vs2019-x64/Release/phonon_test.exe

# Run a single test by name (Catch2 tag or pattern)
./phonon_test "[BVH]"
./phonon_test "Scene*"

# Skip slow ReflectionSimulator tests (this is what CTest does by default)
./phonon_test ~[ReflectionSimulator]
```

### Key CMake Options

OptionDefaultDescription`STEAMAUDIO_ENABLE_EMBREE`ONIntel Embree ray tracing`STEAMAUDIO_ENABLE_IPP`ONIntel IPP for FFT/vectormath`STEAMAUDIO_ENABLE_RADEONRAYS`ON (Win x64)AMD GPU ray tracing`STEAMAUDIO_ENABLE_TRUEAUDIONEXT`ON (Win x64)AMD GPU convolution`STEAMAUDIO_BUILD_TESTS`ONUnit tests`STEAMAUDIO_BUILD_BENCHMARKS`ONBenchmarks`STEAMAUDIO_BUILD_ITESTS`ON (Win x64)Interactive tests (needs GLFW/PortAudio)`STEAMAUDIO_ENABLE_AVX`ONAVX intrinsics (`-DIPL_ENABLE_FLOAT8`)`STEAMAUDIO_ENABLE_OCTAVE_BANDS`OFFExperimental, disables GPU backends

The FFT backend is chosen automatically: IPP → FFTS → PFFFT (fallback).

---

## Architecture

### Namespace & API boundary

- Internal implementation lives in namespace `ipl` (`src/core/`)
- The public C API (`phonon.h`) is wrapped by the `api` namespace (`api_*.cpp` files)
- `api_*.cpp` files translate between `IPL*` C structs and `ipl::*` C++ objects via `Handle<T>` smart pointers
- `api_validation_layer.cpp` is the validation-only wrapper that checks arguments before forwarding

### Audio processing pipeline

```
Source audio (mono)
  │
  ├─► DirectSimulator          ─► DirectEffect
  │   (distance attenuation,       (apply attenuation,
  │    air absorption, occlusion,   air absorption filter,
  │    transmission, ITD)           directivity, per-channel)
  │
  ├─► ReflectionSimulator      ─► EnergyField
  │   (Monte Carlo ray tracing)     (time×freq×Ambisonics)
  │       │
  │       └─► Reconstructor    ─► ImpulseResponse
  │           (EnergyField →        ─► OverlapSaveConvolutionEffect  (convolution)
  │            Ambisonics IR)        ─► ReverbEffect (Schroeder)     (parametric)
  │                                  ─► HybridReverbEffect           (mixed)
  │                                  ─► TANConvolutionEffect         (GPU)
  │
  └─► PathSimulator (A*)       ─► PathEffect
      (probe-to-probe pathing)      (EQ + delay per path segment)

All paths ──► Spatial rendering
              ├─ BinauralEffect      (HRTF convolution, CIPIC 124 points)
              ├─ PanningEffect       (stereo / surround pairwise)
              ├─ AmbisonicsEncodeEffect → AmbisonicsBinauralEffect
              └─ VirtualSurroundEffect
```

### Key subsystems

**Simulation** (`simulation_manager.h/cpp`)\
`SimulationManager` owns all simulators and a `ThreadPool`. It drives a `JobGraph` to fan out ray-tracing work across threads. Shared listener state (`SharedSimulationData`) is double-buffered so the game thread can write while the audio thread reads.

**Ray tracing backends** (selected at compile time via `-DIPL_USES_*`)

- `EmbreeScene` / `EmbreeReflectionSimulator` — CPU, uses ISPC kernels (`embree_reflection_simulator.ispc`) compiled to SSE2/SSE4/AVX/AVX2 objects that are linked into `phonon`
- `RadeonRaysReflectionSimulator` — GPU via OpenCL (`.cl` kernel in source)
- Default `ReflectionSimulator` — pure C++ BVH (`bvh.h`)

**Scene hierarchy** (`scene.h`, `*_scene.h`)\
`IScene` → `EmbreeScene` / `CustomScene`. Geometry is added as `IStaticMesh` or `IInstancedMesh`. Materials carry per-band (low/mid/high) absorption, transmission, and scattering coefficients.

**Serialization** (FlatBuffers)\
Persistent data (scene, probe batches, baked IRs, path visibility) is serialized via `.fbs` schemas in `src/core/`. Schemas are compiled at build time via `compile_fbs()` in `src/core/CMakeLists.txt`.

**HRTF** (`hrtf_database.h`)\
Default CIPIC data is baked into `cipic_124.inl` (124 measurement points). SOFA-format HRTFs are loaded via `sofa_hrtf_map.cpp` (requires libmysofa). Interpolation modes: `NearestNeighbor` or `Bilinear`.

**SIMD layers**\
`Context::sSIMDLevel` is detected at startup. Float-4 ops have SSE (`sse_float4.h`) and NEON (`neon_float4.h`) variants. Float-8 AVX ops are behind `#ifdef IPL_ENABLE_FLOAT8`. Effects like `ReverbEffect` have separate `float8_reverb_effect.cpp` overrides.

**Frequency bands**\
By default 3 bands (low/mid/high). Experimental octave-band mode is gated by `-DIPL_ENABLE_OCTAVE_BANDS` and disables GPU backends.

### Source layout

```
src/core/        — library implementation (all internal, namespace ipl)
src/test/        — Catch2 unit tests → phonon_test binary
src/benchmark/   — standalone benchmarks
src/itest/       — interactive tests (Windows x64 only, needs GLFW + PortAudio)
src/samples/     — minimal usage examples
build/           — CMake Find modules, toolchain files, build.py, get_dependencies.py
deps/            — pre-built dependency binaries (populated by get_dependencies.py)
deps-build/      — dependency source + build scripts
data/            — runtime data files (e.g. HRTF)
```

### Adding a new audio effect

1. Create `my_effect.h` / `my_effect.cpp` in `src/core/`
2. Add a public C interface in a new `api_my_effect.cpp` following the `api_*.cpp` pattern
3. Add both files to `src/core/CMakeLists.txt` under the `phonon` target sources
4. Add a corresponding `IPL*` struct to `phonon.h` if it needs public exposure
5. Add a test in `src/test/MyEffect.test.cpp` and register it in `src/test/CMakeLists.txt`
