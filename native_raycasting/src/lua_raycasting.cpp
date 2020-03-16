// myextension.cpp
// Extension lib defines
#define EXTENSION_NAME NativeRaycasting
#define LIB_NAME "NativeRaycasting"
#define MODULE_NAME "native_raycasting"
// include the Defold SDK
#include <dmsdk/sdk.h>
#include "native_raycasting.h"
#include "lua_helper.h"
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
    int id = LuaCheckNumber(L,1,"bad id");
     if(id>=0 && id <= MAP.idMax){
        CellDataPush(L,&MAP.cells[id]);
        return 1;
    }else{
        dmLogError("bad id:%d",id);
        return 0;
    }
}

static int CellsGetByCoordsLua(lua_State* L){
    int x = LuaCheckNumber(L, 1,"bad x");
    int y = LuaCheckNumber(L, 2,"bad y");
    int id = MAP.CoordsToId(x,y);
   if(id>=0 && id <= MAP.idMax){
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
	int x1 = LuaCheckNumber(L, 1,"bad x1");
	int y1 = LuaCheckNumber(L, 2,"bad y1");
	int x2 = LuaCheckNumber(L, 3,"bad x2");
	int y2 = LuaCheckNumber(L, 4,"bad y2");
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
    int x = LuaCheckNumber(L, 1,"bad x");
	int y = LuaCheckNumber(L, 2,"bad y");
	bool blocking = lua_toboolean(L,1);
	MapChangeCellBlocked(x,y,blocking);
	return 0;
}

static int MapChangeCellTransparentLua(lua_State* L){
    int x = LuaCheckNumber(L, 1,"bad x");
   	int y = LuaCheckNumber(L, 2,"bad y");
	bool transparent = lua_toboolean(L,1);
	MapChangeCellTransparent(x,y,transparent);
	return 0;
}
//endregion


//region Camera
static int CameraUpdateLua(lua_State* L){
	double posX = LuaCheckNumberD(L, 1,"bad pos x");
	double posY = LuaCheckNumberD(L, 2,"bad pos y");
	double angle = LuaCheckNumberD(L, 3,"bad angle");
	CameraUpdate(posX, posY, angle);
	return 0;
}

static int CameraSetFovLua(lua_State* L){
	double fov = LuaCheckNumberD(L, 1,"bad fov");
	CameraSetFov(fov);
	return 0;
}

static int CameraSetRaysLua(lua_State* L){
	int rays = LuaCheckNumber(L, 1,"bad rays");
	CameraSetRays(rays);
	return 0;
}

static int CameraSetMaxDistanceLua(lua_State* L){
	double dist = LuaCheckNumber(L, 1,"bad dist");
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