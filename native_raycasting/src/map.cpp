#pragma once
#include <dmsdk/sdk.h>
#include <tuple>
#include "micropather.h"
#include "lua_helper.h"
#include <limits>
#include <vector>
#include <set>
#include <unordered_set>
#include <vector>
#include "map.h"
#include "cell_data.h"
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

//(int)((size_t)id) fixed loses precision error
//Return the least possible cost between 2 states.
float Map::LeastCostEstimate( void* stateStart, void* stateEnd ){
	CellData start = cells[(int)((size_t)stateStart)];
	CellData end = cells[(int)((size_t)stateEnd)];
	return  pow(end.x - start.x,2) + pow(end.y - start.y,2);
}

static const int dx[8] = { 1, 1, 0, -1, -1, -1, 0, 1 };
static const int dy[8] = { 0, 1, 1, 1, 0, -1, -1, -1 };
static const float cost[8] = { 1.0f, 1.41f, 1.0f, 1.41f, 1.0f, 1.41f, 1.0f, 1.41f };
//TODO запретить ходить по диагонали рядом со стенами иначе застревают
void Map::AdjacentCost( void* state, MP_VECTOR< micropather::StateCost > *neighbors  ){
	CellData cellData = cells[(int)((size_t)state)];
    for( int i=0; i<8; ++i ) {
        int nx = cellData.x  + dx[i];
        int ny = cellData.y + dy[i];
		bool pass = Passable(cellData.x,cellData.y,nx,ny);
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
	if (startState == endState){
		cells_result.push_back( &cells[(int)((size_t)startState)]);
	}else{
        int result = pather->Solve( startState, endState, &path, &totalCost );
        for(void* id: path){
			cells_result.push_back( &cells[(int)((size_t)id)]);
        }
	}
//	pather->Reset();
}

void Map::changeCellBlocked(int x, int y, bool blocked){
    CellData startCell = cells[CoordsToId(x,y)];
    if(startCell.blocked!=blocked){
        pather->Reset();//reset path cache
        startCell.blocked = blocked;
        cells[CoordsToId(x,y)] = startCell;
        dmLogInfo("change cell blocked. x:%d y:%d blocked:%s",x,y,blocked?"true":"false");

    }
}

void Map::changeCellTransparent(int x, int y, bool transparent){
    CellData startCell = cells[CoordsToId(x,y)];
    if(startCell.transparent!=transparent){
        pather->Reset();//reset path cache
        startCell.transparent = transparent;
        cells[CoordsToId(x,y)] = startCell;
        dmLogInfo("change cell transparent. x:%d y:%d transparent:%s",x,y,transparent?"true":"false");
    }
}

void MapChangeCellBlocked(int x, int y, bool blocked){
	MAP.changeCellBlocked(x, y,blocked);
}

void MapChangeCellTransparent(int x, int y, bool transparent){
	MAP.changeCellTransparent(x, y,transparent);
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
	int width = LuaCheckNumber(L, -2,"bad width");
	int height = LuaCheckNumber(L, -1,"bad height");
	lua_pop(L, 3);
	dmLogInfo("map size:%d/%d",width, height);
	MAP.width = width;
	MAP.height = height;
	MAP.idMax = width * height - 1;
	free(MAP.cells);
	MAP.cells = (CellData*)malloc(sizeof(CellData)*width*height);
	memset(MAP.cells, 0, sizeof(CellData)*width*height);
	lua_pushstring(L, "walls");
	lua_gettable(L, -2);
    for(int id=0;id<MAP.width*MAP.height;id++){
        lua_pushnumber(L, id);
        lua_gettable(L, -2);
	    CellData &data = MAP.cells[id];
	    CellDataPush(L, &data);
	    lua_setfield(L,-2, "native_cell");


	    MAP.IdToCoords(id, &data.x, &data.y);
        data.id = id;
        lua_getfield(L, -1, "blocked");
        data.blocked = lua_toboolean(L, -1);
        lua_pop(L, 1);
        lua_getfield(L, -1, "transparent");
        data.transparent = lua_toboolean(L, -1);
        lua_pop(L, 2);

	}
	lua_pop(L, 1);
}