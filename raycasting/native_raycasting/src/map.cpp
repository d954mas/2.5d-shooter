#pragma once
#include <dmsdk/sdk.h>
#include <tuple>
#include "micropather.h"
#include <limits>
#include <vector>
#include "map.h"

Map MAP;

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

void Map::findPath(int x, int y, int x2, int y2,  std::vector<ZoneData>& zones){
	zones.clear();
	void* startState = (void*)(CoordsToId(x,y));
	void* endState = (void*)(CoordsToId(x2,y2));
	std::vector< void* > path;
	float totalCost = 0;
	int result = pather->Solve( startState, endState, &path, &totalCost );
	for(void* id: path){
		zones.push_back( cells[*((int *)id)]);
	}
	pather->Reset();
}

void MapFindPath(int x, int y, int x2, int y2, std::vector<ZoneData>& zones){
	MAP.findPath(x, y, x2, y2, zones);
}

//TODO rewrite. current impl is wrong
void MapParse(lua_State* L){
	lua_getfield(L, 1, "WIDTH");
	lua_getfield(L, 1, "HEIGHT");
	int width = lua_tonumber(L, -2);
	int height = lua_tonumber(L, -1);
	lua_pop(L, 2);
	MAP.width = width;
	MAP.height = height;
	free(MAP.cells);
	MAP.cells = (ZoneData*)malloc(sizeof(ZoneData)*width*height);
	memset(MAP.cells, 0, sizeof(ZoneData)*width*height);
	lua_pushstring(L, "CELLS");
	lua_gettable(L, -2);
	lua_pushnil(L);
	for(int y = 0;lua_next(L, -2) != 0;y++){
		lua_pushnil(L);
		for(int x = 0;lua_next(L, -2) != 0;x++){
			int id = MAP.CoordsToId(x,y);
			ZoneData data = MAP.cells[id];
			data.x = x;
			data.y = y;
			data.id = id;
			lua_getfield(L, -1, "blocked");
			data.blocked = lua_toboolean(L, -1);
			lua_pop(L, 2);
		}
		lua_pop(L, 1);
	}
}