//
// Copyright 2017-2023 Valve Corporation.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#include "vector.h"
using namespace ipl;

#include "phonon.h"

#define STEAMAUDIO_SKIP_API_FUNCTIONS
#include "phonon_interfaces.h"
#include "api_context.h"

namespace api {

// --------------------------------------------------------------------------------------------------------------------
// CContext
// --------------------------------------------------------------------------------------------------------------------

IPLVector3 CContext::calculateRelativeDirection(IPLVector3 sourcePosition,
                                                IPLVector3 listenerPosition,
                                                IPLVector3 listenerAhead,
                                                IPLVector3 listenerUp)
{
    /* @@KURT
    * 1. SteamAudio uses right-handed coordinate system
    *  - (x = right, y = up, z = -front)
    */

    auto _sourcePosition = Vector3f(sourcePosition.x, sourcePosition.y, sourcePosition.z);
    auto _listenerPosition = Vector3f(listenerPosition.x, listenerPosition.y, listenerPosition.z);
    auto _listenerAhead = Vector3f(listenerAhead.x, listenerAhead.y, listenerAhead.z);
    auto _listenerUp = Vector3f(listenerUp.x, listenerUp.y, listenerUp.z);

    /*
    * @@KURT
    *  in order to get right vector
    * 
    * eg1)
	*   ahead = (0.47, 0.34, -0.81)
        up    = (-0.17, 0.94, 0.30)

        cross(a, u) = ( a.y·u.z − a.z·u.y ,  a.z·u.x − a.x·u.z ,  a.x·u.y − a.y·u.x )
          x = (0.34)(0.30) − (-0.81)(0.94) = 0.87
          y = (-0.81)(-0.17) − (0.47)(0.30) = 0.00
          z = (0.47)(0.94) − (0.34)(-0.17) = 0.50
          → cross = (0.87, 0.00, 0.50)

        |cross| = |a||u|·sin(각도) = sin(90°) = 1.00
        right = cross / |cross| = (0.87, 0.00, 0.50)   (길이 1.00)

        right · ahead = 0.00    right · up = 0.00   ← 둘 다 0이면 두 벡터에 수직

    * eg2)
	* v = source − listener = (3, 0, -4)

      |v| = √(x² + y² + z²) = √(9 + 0 + 16) = 5.00
       d = v / |v| = (3/5.00, 0/5.00, -4/5.00) = (0.60, 0.00, -0.80)

      |d| = √(0.36 + 0.00 + 0.64) = 1.00

      2배 멀리 두면: 2v = (6, 0, -8),  |2v| = 10.00
      d = 2v / |2v| = (0.60, 0.00, -0.80)   ← 같은 방향, 같은 d

      -----
      왜 필요한가: 3차원 공간에서 방향을 나타내려면 서로 수직인 축이 3개 필요합니다. 
      그런데 입력은 ahead(앞)와 up(위) 두 개뿐이에요. 세 번째 축 right는 "앞에도 수직이고 위에도 수직인 방향"으로 정할 수 있고, 
      그걸 계산해 주는 연산이 외적(cross product)
    */
    auto _listenerRight = Vector3f::unitVector(Vector3f::cross(_listenerAhead, _listenerUp));

    auto listenerToSource = _sourcePosition - _listenerPosition;
    auto _relativeDirection = Vector3f::kYAxis;

    if (listenerToSource.length() > 1e-5f)
    {
        listenerToSource = Vector3f::unitVector(listenerToSource);

        /* @@KURT
        * 길이가 1인축과 dot을 하게 되면 그 축 방향의 좌표가 나오기 때문에 활용
        *  eg)
        * (3,4) dot (1,0) = 3 * 1 + 4 * 0 = 3    - x축과 내적
        * (3,4) dot (0,1) = 3 * 0 + 4 * 1 = 4    - y축고 내적
        */
        _relativeDirection.x() = (Vector3f::dot(listenerToSource, _listenerRight));
        _relativeDirection.y() = (Vector3f::dot(listenerToSource, _listenerUp));

        /*@@KURT - local +z 가 뒤쪽이라 부호반전 -z*/
        _relativeDirection.z() = (-Vector3f::dot(listenerToSource, _listenerAhead));
    }

    IPLVector3 relativeDirection = {_relativeDirection.x(), _relativeDirection.y(), _relativeDirection.z()};
    return relativeDirection;
}

}
