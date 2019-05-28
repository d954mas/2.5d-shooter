// myextension.cpp
// Extension lib defines
#define EXTENSION_NAME NativeRaycasting
#define LIB_NAME "NativeRaycasting"
#define MODULE_NAME "native_raycasting"
// include the Defold SDK
#include <dmsdk/sdk.h>
#include "native_raycasting.h"

static int getVisibleSpritesLua(lua_State* L){
	getVisibleSprites(L);
	return 1;
}

static int findPathLua(lua_State* L){
	int x1 = lua_tonumber(L, 1) - 1;
	int y1 = lua_tonumber(L, 2) - 1;
	int x2 = lua_tonumber(L, 3) - 1;
	int y2 = lua_tonumber(L, 4) - 1;
	std::vector<Point> path;
	findPath(x1, y1, x2, y2, &path);
	lua_newtable(L);
	int i = 0;
	for(Point p : path) {
		lua_newtable(L);
		lua_pushnumber(L, p.x+1);
		lua_setfield(L, -2, "x");
		lua_pushnumber(L, p.y+1);
		lua_setfield(L, -2, "y");	
		lua_rawseti(L, -2, i+1);
		i++;
	}
	return 1;
}
static int raycastVisibilityFovLua(lua_State* L){
	raycastVisibilityFov(L);
	return 1;
}

static int raycast(lua_State* L){
	getVisibleSprites(L);
	return 1;
}

static int updateVisibleSpritesLua(lua_State* L){
	updateVisibleSprites(L);
	return 3;
}

static int updateCameraLua(lua_State* L){
	double posX = lua_tonumber(L, 1);
	double posY = lua_tonumber(L, 2);
	double angle = lua_tonumber(L, 3);
	updateCamera(posX, posY, angle);
	return 0;
}

static int setCameraFovLua(lua_State* L){
	double fov = lua_tonumber(L, 1);
	setCameraFov(fov);
	return 0;
}

static int setCameraRaysLua(lua_State* L){
	int rays = (int)lua_tonumber(L, 1);
	setCameraRays(rays);
	return 0;
}

static int setCameraMaxDistLua(lua_State* L){
	double dist = lua_tonumber(L, 1);
	setCameraMaxDist(dist);
	return 0;
}

static int setMapLua(lua_State* L){
	setMap(L);
	return 0;
}

// Functions exposed to Lua
static const luaL_reg Module_methods[] =
{	
	{"update_camera", updateCameraLua},
	{"set_camera_fov", setCameraFovLua},
	{"set_camera_rays", setCameraRaysLua},
	{"set_camera_max_dist", setCameraMaxDistLua},
	{"set_map", setMapLua},
	{"update_sprites", updateVisibleSpritesLua},
	{"get_visible_sprites", getVisibleSpritesLua},
	{"raycast_visibility_fov", raycastVisibilityFovLua},
	{"find_path", findPathLua},
	{0, 0}
};

static void LuaInit(lua_State* L)
{
	int top = lua_gettop(L);
	// Register lua names
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