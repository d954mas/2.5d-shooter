#pragma once
#include <dmsdk/sdk.h>
#include <tuple>
#include "micropather.h"
#include <limits>
#include <vector>
#include <set>
#include <unordered_set>
#include <vector>
#include "map.h"

#define DLIB_LOG_DOMAIN "MAP"

extern std::vector<CellData*> VISIBLE_ZONES;
extern std::unordered_set <CellData> ZONE_SET;
extern std::vector<CellData*> NEED_LOAD_ZONES;
extern std::vector<CellData*> NEED_UPDATE_ZONES;
extern std::vector<CellData*> NEED_UNLOAD_ZONES;

Map MAP;

Map::Map(){
	pather = new MicroPather( this, 1024 );
}
Map::~Map() {delete pather;}

//Return the least possible cost between 2 states.
float Map::LeastCostEstimate( void* stateStart, void* stateEnd ){
	CellData start = cells[(int)stateStart];
	CellData end = cells[(int)stateEnd];
	return  pow(end.x - start.x,2) + pow(end.y - start.y,2);
}

static const int dx[8] = { 1, 1, 0, -1, -1, -1, 0, 1 };
static const int dy[8] = { 0, 1, 1, 1, 0, -1, -1, -1 };
static const float cost[8] = { 1.0f, 21.41f, 1.0f, 21.41f, 1.0f, 21.41f, 1.0f, 21.41f };
//TODO запретить ходить по диагонали рядом со стенами иначе застревают
void Map::AdjacentCost( void* state, MP_VECTOR< micropather::StateCost > *neighbors  ){
	CellData cellData = cells[(int)state];
    for( int i=0; i<8; ++i ) {
        int nx = cellData.x  + dx[i];
        int ny = cellData.y + dy[i];
        bool pass = Passable(nx,ny);
        if(pass){
            StateCost nodeCost = {(void*)CoordsToId(nx,ny), cost[i] };
            neighbors->push_back( nodeCost );
        }
    }
}

/**This function is only used in DEBUG mode - it dumps output to stdout. Since void* 
aren't really human readable, normally you print out some concise info (like "(1,2)") 
without an ending newline.*/
void Map::PrintStateInfo(void* state){printf("print info");}

void Map::findPath(int x, int y, int x2, int y2,  std::vector<CellData*>& cells_result){
	cells_result.clear();
	void* startState = (void*)(CoordsToId(x,y));
	void* endState = (void*)(CoordsToId(x2,y2));
	std::vector< void* > path;
	float totalCost = 0;
	int result = pather->Solve( startState, endState, &path, &totalCost );
    for(void* id: path){
	    cells_result.push_back( &cells[(int)id]);
	}
//	pather->Reset();
}

void MapFindPath(int x, int y, int x2, int y2, std::vector<CellData*>& cells){
	MAP.findPath(x, y, x2, y2, cells);
}

void MapParse(lua_State* L){

    //reset current state
    VISIBLE_ZONES.clear();
    ZONE_SET.clear();
    NEED_LOAD_ZONES.clear();
    NEED_UPDATE_ZONES.clear();
    NEED_UNLOAD_ZONES.clear();

    std::unordered_set <CellData> ZONE_SET;
    std::vector<CellData*> NEED_LOAD_ZONES;
    std::vector<CellData*> NEED_UPDATE_ZONES;
    std::vector<CellData*> NEED_UNLOAD_ZONES;

    DM_LUA_STACK_CHECK(L, 0);
    lua_pushstring(L, "size");
	lua_gettable(L, -2);
	lua_getfield(L, -1, "x");
	lua_getfield(L, -2, "y");
	int width = lua_tointeger(L, -2);
	int height = lua_tointeger(L, -1);
	lua_pop(L, 3);
	dmLogInfo("map size:%d/%d",width, height);
	MAP.width = width;
	MAP.height = height;
	free(MAP.cells);
	MAP.cells = (CellData*)malloc(sizeof(CellData)*width*height);
	memset(MAP.cells, 0, sizeof(CellData)*width*height);
	lua_pushstring(L, "cells");
	lua_gettable(L, -2);
	lua_pushnil(L);
	for(int y = 0;lua_next(L, -2) != 0;y++){
		lua_pushnil(L);
		for(int x = 0;lua_next(L, -2) != 0;x++){
			int id = MAP.CoordsToId(x,y);
			CellData &data = MAP.cells[id];
			data.x = x;
			data.y = y;
			data.id = id;
			lua_getfield(L, -1, "blocked");
			data.blocked = lua_toboolean(L, -1);
			lua_pop(L, 2);
		}
		lua_pop(L, 1);
	}
	lua_pop(L, 1);
}