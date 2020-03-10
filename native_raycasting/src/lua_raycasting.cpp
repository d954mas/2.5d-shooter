// myextension.cpp
// Extension lib defines
#define EXTENSION_NAME NativeRaycasting
#define LIB_NAME "NativeRaycasting"
#define MODULE_NAME "native_raycasting"
// include the Defold SDK
#include <dmsdk/sdk.h>
#include "native_raycasting.h"
#include <set>
#include <unordered_set>
#include <vector>

extern std::vector<CellData*> VISIBLE_ZONES;
extern std::unordered_set <CellData> ZONE_SET;
extern std::vector<CellData*> NEED_LOAD_ZONES;
extern std::vector<CellData*> NEED_UPDATE_ZONES;
extern std::vector<CellData*> NEED_UNLOAD_ZONES;
extern Map MAP;

//region cells
static void CellsPutVectorToLua(lua_State* L, std::vector<CellData*> &vec){
    lua_newtable(L);
    int i =0;
    for(CellData *cell : vec) {
        CellDataPush(L,cell);
        lua_rawseti(L, -2, i+1);
        i++;
    }
}

static int CellsGetVisibleLua(lua_State* L){
    CellsPutVectorToLua(L,VISIBLE_ZONES);
	return 1;
}

static int CellsGetNeedLoadLua(lua_State* L){
    CellsPutVectorToLua(L,NEED_LOAD_ZONES);
	return 1;
}

static int CellsGetNeedUnloadLua(lua_State* L){
    CellsPutVectorToLua(L,NEED_UNLOAD_ZONES);
	return 1;
}

static int CellsGetNeedUpdateLua(lua_State* L){
    CellsPutVectorToLua(L,NEED_UPDATE_ZONES);
	return 1;
}

static int CellsGetByIdLua(lua_State* L){
    int id = lua_tonumber(L, 1) - 1;
    if(id>=0 && id <= MAP.CoordsToId(MAP.width-1,MAP.height-1)){
        CellDataPush(L,&MAP.cells[id]);
        return 1;
    }else{
        dmLogError("bad id:%d",id);
        return 0;
    }
}

static int CellsGetByCoordsLua(lua_State* L){
    int x = lua_tonumber(L, 1) - 1;
    int y = lua_tonumber(L, 2) - 1;
    int id = MAP.CoordsToId(x,y);
    if(id>=0 && id <= MAP.CoordsToId(MAP.width-1,MAP.height-1)){
        CellDataPush(L,&MAP.cells[id]);
        return 1;
    }else{
        dmLogError("bad id:%d",id);
        return 0;
    }

}

static int CellsUpdateVisibleLua(lua_State* L){
    bool blocking = lua_toboolean(L,1);
	CellsUpdateVisible(blocking);
	return 0;
}
//endregion
//region Map
static int MapFindPathLua(lua_State* L){
	int x1 = ceil(lua_tonumber(L, 1)) - 1;
	int y1 = ceil(lua_tonumber(L, 2)) - 1;
	int x2 = ceil(lua_tonumber(L, 3)) - 1;
	int y2 = ceil(lua_tonumber(L, 4)) - 1;
	if (x1<0 || y1<0 || x2 <0 || y2 < 0){
	    dmLogError("pathfinding bad coords");
	    return 0;
	}
	std::vector<CellData*> path;
	MapFindPath(x1, y1, x2, y2, path);
	if (path.size()> 0){
	    lua_newtable(L);
        int i =0;
        for(CellData *cell : path) {
            CellDataPush(L,cell);
            lua_rawseti(L, -2, i+1);
            i++;
        }
        return 1;
    }
	return 0;
}

static int MapSetLua(lua_State* L){
	MapParse(L);
	return 0;
}

static int MapChangeCellBlockedLua(lua_State* L){
    int x = ceil(lua_tonumber(L, 1)) - 1;
	int y = ceil(lua_tonumber(L, 2)) - 1;
	bool blocking = lua_toboolean(L,1);
	MapChangeCellBlocked(x,y,blocking);
	return 0;
}

static int MapChangeCellTransparentLua(lua_State* L){
    int x = ceil(lua_tonumber(L, 1)) - 1;
	int y = ceil(lua_tonumber(L, 2)) - 1;
	bool transparent = lua_toboolean(L,1);
	MapChangeCellTransparent(x,y,transparent);
	return 0;
}
//endregion


//region Camera
static int CameraUpdateLua(lua_State* L){
	double posX = lua_tonumber(L, 1);
	double posY = lua_tonumber(L, 2);
	double angle = lua_tonumber(L, 3);
	CameraUpdate(posX, posY, angle);
	return 0;
}

static int CameraSetFovLua(lua_State* L){
	double fov = lua_tonumber(L, 1);
	CameraSetFov(fov);
	return 0;
}

static int CameraSetRaysLua(lua_State* L){
	int rays = (int)lua_tonumber(L, 1);
	CameraSetRays(rays);
	return 0;
}

static int CameraSetMaxDistanceLua(lua_State* L){
	double dist = lua_tonumber(L, 1);
	CameraSetMaxDistance(dist);
	return 0;
}
//endregion


// Functions exposed to Lua
static const luaL_reg Module_methods[] =
{	
	{"camera_update", CameraUpdateLua},
	{"camera_set_fov", CameraSetFovLua},
	{"camera_set_rays", CameraSetRaysLua},
	{"camera_set_max_distance", CameraSetMaxDistanceLua},
	
	{"map_set", MapSetLua},
	{"map_find_path", MapFindPathLua},
	{"map_cell_set_blocked", MapChangeCellBlockedLua},
	{"map_cell_set_transparent", MapChangeCellTransparentLua},

	{"cells_update_visible", CellsUpdateVisibleLua},
	{"cells_get_visible",CellsGetVisibleLua},
	{"cells_get_need_load",CellsGetNeedLoadLua},
	{"cells_get_need_unload",CellsGetNeedUnloadLua},
	{"cells_get_need_update",CellsGetNeedUpdateLua},
	{"cells_get_by_id",CellsGetByIdLua},
	{"cells_get_by_coords",CellsGetByCoordsLua},

	{0, 0}
};

static void LuaInit(lua_State* L)
{
	int top = lua_gettop(L);
	// Register lua names
	CellDataBind(L);
	luaL_register(L, MODULE_NAME, Module_methods);
	lua_pop(L, 1);
	assert(top == lua_gettop(L));
}

static dmExtension::Result AppInitializeMyExtension(dmExtension::AppParams* params)
{
	return dmExtension::RESULT_OK;
}

static dmExtension::Result InitializeMyExtension(dmExtension::Params* params)
{
	// Init Lua
	LuaInit(params->m_L);
	printf("Registered %s Extension\n", MODULE_NAME);
	return dmExtension::RESULT_OK;
}

static dmExtension::Result AppFinalizeMyExtension(dmExtension::AppParams* params)
{
	return dmExtension::RESULT_OK;
}

static dmExtension::Result FinalizeMyExtension(dmExtension::Params* params)
{
	return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, AppInitializeMyExtension, AppFinalizeMyExtension, InitializeMyExtension, 0, 0, FinalizeMyExtension)