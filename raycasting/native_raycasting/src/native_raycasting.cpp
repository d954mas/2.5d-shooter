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

static std::unordered_set <ZoneData> ZONE_SET;
static std::vector<ZoneData> VISIBLE_ZONES;
static std::vector<ZoneData> NEED_LOAD_ZONES;
static std::vector<ZoneData> NEED_UPDATE_ZONES;
static std::vector<ZoneData> NEED_UNLOAD_ZONES;

void getVisibleSprites(lua_State* L){
	lua_newtable(L);
	int i =0;
	for(ZoneData z : VISIBLE_ZONES) {
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
	for(int i=0; i<MAIN_CAMERA.rays>>1; i++){
		double rayAngle = MAIN_CAMERA.angles[i];
		castRay(&MAIN_CAMERA, -rayAngle, &MAP, MAIN_CAMERA.maxDistance, ZONE_SET, false);
		castRay(&MAIN_CAMERA, rayAngle, &MAP, MAIN_CAMERA.maxDistance, ZONE_SET, false);
	}
	//reset prev raycasting
	for(ZoneData data : VISIBLE_ZONES){
		data.rayCasted = false;
	}
	//mark visible zones
	for(ZoneData data : ZONE_SET) {
		data.rayCasted = true;
		if(data.visibility!=data.prevVisibility){
			data.visibility = data.prevVisibility;
			VISIBLE_ZONES.push_back(data);
			NEED_LOAD_ZONES.push_back(data);
		}else if(data.right != data.prevRight || data.top != data.prevTop){
			data.right = data.prevRight;
			data.top = data.prevTop;
			NEED_UPDATE_ZONES.push_back(data);
		}
	}
	//use this iterator to make erase worked
	for(std::vector<ZoneData>::iterator  it = VISIBLE_ZONES.begin(); it != VISIBLE_ZONES.end();){
		if(!it->rayCasted){
			it->visibility = false;
			NEED_UNLOAD_ZONES.push_back(*it);
			it = VISIBLE_ZONES.erase(it);
		}else{
			it++;
		}
	}
	//todo return userData instead of creating new zones
	lua_newtable(L);
	int i =0;
	for(ZoneData z : NEED_LOAD_ZONES) {
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
	for(ZoneData z : NEED_UPDATE_ZONES) {
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
	for(ZoneData z : NEED_UNLOAD_ZONES) {
		lua_newtable(L);
		lua_pushnumber(L, z.x+1);
		lua_setfield(L, -2, "x");
		lua_pushnumber(L, z.y+1);
		lua_setfield(L, -2, "y");	
		lua_rawseti(L, -2, i+1);
		i++;
	}
}

void findPath(int x, int y, int x2, int y2, std::vector<ZoneData>& zones){
	MAP.findPath(x, y, x2, y2, zones);
}