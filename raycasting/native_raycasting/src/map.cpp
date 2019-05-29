#pragma once
#include <dmsdk/sdk.h>
#include <tuple>
#include "micropather.h"
#include <limits>
#include <vector>
#include "map.h"


Map::Map(){
	pather = new MicroPather( this, 1024 );
}
Map::~Map() {delete pather;}

//Return the least possible cost between 2 states.
float Map::LeastCostEstimate( void* stateStart, void* stateEnd ){
	ZoneData start = cells[*((int *)stateStart)];
	ZoneData end = cells[*((int *)stateEnd)];
	return  pow(end.x - start.x,2) + pow(end.y - start.y,2);
}
void Map::AdjacentCost( void* state, MP_VECTOR< micropather::StateCost > *neighbors  ){
	ZoneData zoneData = cells[*((int *)state)];
	for(int y=-1;y<=1;y++){
		for(int x=-1;x<=1;x++){
			if(x!=0 && y!=0){
				bool pass = Passable(zoneData.x + x,zoneData.y+y);
				if (pass) {
					//TODO add bigger dist for diagonals
					StateCost nodeCost = {(void*)CoordsToId(zoneData.x+x,zoneData.y+y), 1};
					neighbors ->push_back(nodeCost);
				}
			}
		}
	}
}

/**This function is only used in DEBUG mode - it dumps output to stdout. Since void* 
aren't really human readable, normally you print out some concise info (like "(1,2)") 
without an ending newline.*/
void Map::PrintStateInfo(void* state){printf("print info");}

void Map::findPath(int x, int y, int x2, int y2, std::vector<Point>* points){
	points->clear();
	void* startState = (void*)(y * width + x );
	void* endState = (void*)( y2 * width + x2 );
	std::vector< void* > path;
	float totalCost = 0;
	int result = pather->Solve( startState, endState, &path, &totalCost );
	for(void* id: path){
		ZoneData zoneData = cells[*((int *)id)];
		Point point;
		point.x = zoneData.x;
		point.y = zoneData.y;
		points->push_back(point);
	}
	pather->Reset();
}

namespace std {
	template <>
	struct hash<ZoneData>{
		std::size_t operator()(const ZoneData& z) const{
			return std::hash<int>()(z.id);
		}
	};
}

void parseMap(lua_State* L, Map* map){
	lua_getfield(L, 1, "WIDTH");
	lua_getfield(L, 1, "HEIGHT");
	int width = lua_tonumber(L, -2);
	int height = lua_tonumber(L, -1);
	lua_pop(L, 2);
	map->width = width;
	map->height = height;
	free(map->cells);
	map->cells = (ZoneData*)malloc(sizeof(ZoneData)*width*height);
	memset(map->cells, 0, sizeof(ZoneData)*width*height);
	lua_pushstring(L, "CELLS");
	lua_gettable(L, -2);
	lua_pushnil(L);
	for(int y = 0;lua_next(L, -2) != 0;y++){
		lua_pushnil(L);
		for(int x = 0;lua_next(L, -2) != 0;x++){
			map->cells[y * width + x].x = x;
			map->cells[y * width + x].y = y;
			lua_getfield(L, -1, "blocked");
			map->cells[y * width + x].blocked = lua_toboolean(L, -1);
			lua_pop(L, 2);
		}
		lua_pop(L, 1);
	}
}