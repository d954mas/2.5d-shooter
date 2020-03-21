// myextension.cpp
// Extension lib defines
#define EXTENSION_NAME physics3d
#define LIB_NAME "physics3d"
#define MODULE_NAME "physics3d"
// include the Defold SDK
#include "physics3.h"
#include <dmsdk/sdk.h>



static int ClearLua(lua_State* L){
	Physics3Clear();
	return 0;
}

static int InitLua(lua_State* L){
	Physics3Init();
	return 0;
}

static int UpdateLua(lua_State* L){
	Physics3Update();
	return 0;
}

// Functions exposed to Lua
static const luaL_reg Module_methods[] ={
	{"clear", ClearLua},
	{"init", InitLua},
	{"update", UpdateLua},
	{0, 0}
};

static void LuaInit(lua_State* L){
	int top = lua_gettop(L);
	// Register lua names
	luaL_register(L, MODULE_NAME, Module_methods);
	lua_pop(L, 1);
	assert(top == lua_gettop(L));
}

static dmExtension::Result AppInitializeMyExtension(dmExtension::AppParams* params){return dmExtension::RESULT_OK;}
static dmExtension::Result InitializeMyExtension(dmExtension::Params* params){
	// Init Lua
	LuaInit(params->m_L);
	printf("Registered %s Extension\n", MODULE_NAME);
	return dmExtension::RESULT_OK;
}

static dmExtension::Result AppFinalizeMyExtension(dmExtension::AppParams* params){return dmExtension::RESULT_OK;}

static dmExtension::Result FinalizeMyExtension(dmExtension::Params* params){return dmExtension::RESULT_OK;}

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, AppInitializeMyExtension, AppFinalizeMyExtension, InitializeMyExtension, 0, 0, FinalizeMyExtension)