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
#include "world_structures.h"
#include "raycasting.h"

static Camera CAMERA;
static Map MAP;
static std::vector<double> ANGLES;
static std::unordered_set <Zone> ZONE_SET;
static std::vector<Zone> VISIBLE_ZONES;
static std::vector<Zone> NEED_LOAD_ZONES;
static std::vector<Zone> NEED_UPDATE_ZONES;
static std::vector<Zone> NEED_UNLOAD_ZONES;
static double viewDist = 0;
static double maxDistance = 30;




static void viewDistanceUpdated(){
	viewDist = CAMERA.rays/(2 * tan(CAMERA.fov/2.0));
	ANGLES.resize(CAMERA.rays>>1);
	ANGLES.clear();
	for(int x=1;x<=CAMERA.rays>>1;x++){
		ANGLES.push_back(atan(x/viewDist));
	}
}

void setCameraFov(double fov){
	CAMERA.fov = fov;
	viewDistanceUpdated();
}

void setCameraRays(int rays){
	CAMERA.rays = rays;
	viewDistanceUpdated();
}

void setCameraMaxDist(double distance){
	maxDistance = distance;
}

void updateCamera(double x, double y, double angle){
	updateCamera(&CAMERA, x, y, angle);
}

void setCameraAngle(double angle){
	CAMERA.angle = angle;
}

void setMap(lua_State* L){
	parseMap(L, &MAP);
	VISIBLE_ZONES.clear();
}



void getVisibleSprites(lua_State* L){
	lua_newtable(L);
	int i =0;
	for(Zone z : VISIBLE_ZONES) {
		lua_newtable(L);
		lua_pushnumber(L, z.x+1);
		lua_setfield(L, -2, "x");
		lua_pushnumber(L, z.y+1);
		lua_setfield(L, -2, "y");
		lua_rawseti(L, -2, i+1);
		i++;
	}
}


void raycastVisibilityFov(lua_State* L){
	double fov = lua_tonumber(L, 1);
	int rays = (int)lua_tonumber(L, 2);
	double maxDist = lua_tonumber(L, 3);
	std::unordered_set<Zone> zones;
	double viewDist = rays/(2 * tan(fov/2.0));
	for(int i=0; i<CAMERA.rays>>1; i++){
		double rayAngle = atan(i/viewDist);
		castRay(&CAMERA, -rayAngle, &MAP, maxDist, zones, false);
		castRay(&CAMERA, rayAngle, &MAP, maxDist, zones, false);
	}
	lua_newtable(L);
	int i =0;
	for(Zone z : zones) {
		lua_newtable(L);
		lua_pushnumber(L, z.x+1);
		lua_setfield(L, -2, "x");
		lua_pushnumber(L, z.y+1);
		lua_setfield(L, -2, "y");	
		lua_rawseti(L, -2, i+1);
		i++;
	}
}


void updateVisibleSprites(lua_State* L){
	ZONE_SET.clear();
	NEED_LOAD_ZONES.clear();
	NEED_UPDATE_ZONES.clear();
	NEED_UNLOAD_ZONES.clear();
	//	for(int i=0; i<1; i++){
	for(int i=0; i<CAMERA.rays>>1; i++){
		double rayAngle = ANGLES[i];
		castRay(&CAMERA, -rayAngle, &MAP, maxDistance, ZONE_SET, false);
		castRay(&CAMERA, rayAngle, &MAP, maxDistance, ZONE_SET, false);
	}
	//reset prev raycasting
	for(Zone z : VISIBLE_ZONES){
		ZoneData *data = &MAP.cells[z.y * MAP.width + z.x];
		data->rayCasted = false;
	}
	//mark visible zones
	for(Zone z : ZONE_SET) {
		ZoneData *data = &MAP.cells[z.y * MAP.width + z.x];
		data->rayCasted = true;
		if(!data->visibility){
			data->visibility = true;
			data->right = z.right;
			data->top = z.top;
			VISIBLE_ZONES.push_back(z);
			NEED_LOAD_ZONES.push_back(z);
		}else if(data->right != z.right || data->top != z.top){
			data->right = z.right;
			data->top = z.top;
			NEED_UPDATE_ZONES.push_back(z);
		}
	}

	for(std::vector<Zone>::iterator  it = VISIBLE_ZONES.begin(); it != VISIBLE_ZONES.end();){
		ZoneData *data = &MAP.cells[it->y * MAP.width + it->x];
		if(!data->rayCasted){
			data->visibility = false;
			NEED_UNLOAD_ZONES.push_back(*it);
			it = VISIBLE_ZONES.erase(it);
		}else{
			it++;
		}
	}
	
	lua_newtable(L);
	int i =0;
	for(Zone z : NEED_LOAD_ZONES) {
		lua_newtable(L);
		lua_pushnumber(L, z.x+1);
		lua_setfield(L, -2, "x");
		lua_pushnumber(L, z.y+1);
		lua_setfield(L, -2, "y");	
		lua_pushboolean(L, z.top);
		lua_setfield(L, -2, "top");
		lua_pushboolean(L, z.right);
		lua_setfield(L, -2, "right");
		lua_rawseti(L, -2, i+1);
		i++;
	}

	lua_newtable(L);
	i =0;
	for(Zone z : NEED_UPDATE_ZONES) {
		lua_newtable(L);
		lua_pushnumber(L, z.x+1);
		lua_setfield(L, -2, "x");
		lua_pushnumber(L, z.y+1);
		lua_setfield(L, -2, "y");	
		lua_pushboolean(L, z.top);
		lua_setfield(L, -2, "top");
		lua_pushboolean(L, z.right);
		lua_setfield(L, -2, "right");
		lua_rawseti(L, -2, i+1);
		i++;
	}
	
	lua_newtable(L);
	i = 0;
	for(Zone z : NEED_UNLOAD_ZONES) {
		lua_newtable(L);
		lua_pushnumber(L, z.x+1);
		lua_setfield(L, -2, "x");
		lua_pushnumber(L, z.y+1);
		lua_setfield(L, -2, "y");	
		lua_rawseti(L, -2, i+1);
		i++;
	}
}

void findPath(int x, int y, int x2, int y2, std::vector<Point>* points){
	MAP.findPath(x, y, x2, y2, points);
}