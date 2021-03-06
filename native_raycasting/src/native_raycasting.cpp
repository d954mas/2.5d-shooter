#define PI       3.14159265358979323846
#define TWO_PI       3.14159265358979323846 * 2
#define HALF_PI      PI / 2.0
#define ROUNDNUM(x) (int)(x + 0.5)
#include <dmsdk/sdk.h>
#include <stdlib.h>
#include <math.h>
#include <algorithm>
#include <set>
#include <unordered_set>
#include <vector>
#include "raycasting.h"
#include "map.h"
#include "camera.h"

extern Camera MAIN_CAMERA;
extern Map MAP;

std::vector<CellData*> VISIBLE_ZONES;

std::unordered_set <CellData> ZONE_SET;
std::vector<CellData*> NEED_LOAD_ZONES;
std::vector<CellData*> NEED_UPDATE_ZONES;
std::vector<CellData*> NEED_UNLOAD_ZONES;

void CastRays(Camera& camera,std::unordered_set<CellData>& set, bool blocking){
	set.clear();
    for(int i=0; i<camera.rays; i++){
        double rayAngle = camera.angles[i];
        castRay(&camera, rayAngle-camera.fov/2, &MAP, camera.maxDistance, set, blocking);
      //  castRay(&camera, rayAngle, &MAP, camera.maxDistance, set, blocking);
    }
}


void CellsUpdateVisible(bool blocking){
	NEED_LOAD_ZONES.clear();
	NEED_UPDATE_ZONES.clear();
	NEED_UNLOAD_ZONES.clear();
	CastRays(MAIN_CAMERA,ZONE_SET,blocking);
	//reset prev raycasting
	for(CellData *data : VISIBLE_ZONES)data->rayCasted = false;

	//mark visible cells
	for( const CellData &set_data : ZONE_SET) {
	    CellData &data = MAP.cells[set_data.id];
		data.rayCasted = true;
        if(!data.visibility){
			data.visibility = true;
			data.right = data.raycastingRight;
            data.top = data.raycastingTop;
			VISIBLE_ZONES.push_back(&data);
			NEED_LOAD_ZONES.push_back(&data);
		}else if(data.right != data.raycastingRight || data.top != data.raycastingTop){
			data.right = data.raycastingRight;
			data.top = data.raycastingTop;
			NEED_UPDATE_ZONES.push_back(&data);
		}
	}
	//use this iterator to make erase worked
	for(std::vector<CellData*>::iterator  it = VISIBLE_ZONES.begin(); it != VISIBLE_ZONES.end();){
		if(!(*it)->rayCasted){
			(*it)->visibility = false;
			NEED_UNLOAD_ZONES.push_back((*it));
			it = VISIBLE_ZONES.erase(it);
		}else{
			it++;
		}
	}
}