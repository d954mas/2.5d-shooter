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

static int CreateRectLua(lua_State* L){
	float x = luaL_checknumber(L,1);
	float y = luaL_checknumber(L,2);
	float z = luaL_checknumber(L,3);
	float hw = luaL_checknumber(L,4);
	float hh = luaL_checknumber(L,5);
	float hl = luaL_checknumber(L,6);
	float mStatic = lua_toboolean(L,7);
	unsigned short group = luaL_checknumber(L,8);
	unsigned short mask = luaL_checknumber(L,9);
	RectBody* rect = Physics3CreateRectBody(x,y,z,hw,hh,hl,mStatic,group,mask);
	RectBodyPush(L,rect);
	return 1;
}

static int DestroyRectLua(lua_State* L){
    RectBody *rect = RectBodyCheck(L, 1);
    luaL_unref(L, LUA_REGISTRYINDEX, rect->userDataRef);
    rect->userDataRef = LUA_REFNIL;
    Physics3DestroyRectBody(rect);
    return 0;
}

#define LUA_VECTOR3(L, name, x,y,z) \
  lua_newtable(L); \
  lua_pushnumber(L, x); \
  lua_setfield(L,-2, "x"); \
  lua_pushnumber(L, y); \
  lua_setfield(L,-2, "y"); \
  lua_pushnumber(L, z); \
  lua_setfield(L,-2, "z");\
  lua_setfield(L,-2, name);


static int GetCollisionInfoLua(lua_State* L){
    std::list<CollisionInfo*> list =Physics3GetCollisionInfo();
    lua_newtable(L);
    int i = 0;
    for(CollisionInfo* info : list) {
        lua_newtable(L);
        RectBodyPush(L,info->body1);
        lua_setfield(L,-2,"body1");
        RectBodyPush(L,info->body2);
        lua_setfield(L,-2,"body2");

        lua_newtable(L);
        int m = 0;
        for(CollisionInfoManifold manifold: info->manifolds){
            lua_newtable(L);

            lua_newtable(L);
            int p = 0;
            for(CollisionInfoManifoldPoint point: manifold.points){
                lua_newtable(L);

                LUA_VECTOR3(L,"normal",point.normal.x,point.normal.y,point.normal.z);

                lua_pushnumber(L,point.depth);
                lua_setfield(L,-2,"depth");

                LUA_VECTOR3(L,"point1",point.point1.x,point.point1.y,point.point1.z);
                LUA_VECTOR3(L,"point2",point.point2.x,point.point2.y,point.point2.z);

                lua_rawseti(L, -2, p+1);
                p++;
            }
            lua_setfield(L,-2,"points");

            lua_rawseti(L, -2, m+1);
            m++;
        }
        lua_setfield(L,-2,"manifolds");
        
        lua_rawseti(L, -2, i+1);
        i++;
    }
    return 1;
}

static int Raycast(lua_State* L){
	float x = luaL_checknumber(L,1);
	float y = luaL_checknumber(L,2);
	float z = luaL_checknumber(L,3);
	float x2 = luaL_checknumber(L,4);
	float y2 = luaL_checknumber(L,5);
	float z2 = luaL_checknumber(L,6);
	unsigned short mask =0xFFFF;
    if(lua_isnumber(L,7)){
        mask = luaL_checknumber(L,7);
    }
    rp3d::Vector3 start(x,y,z);
    rp3d::Vector3 end(x2,y2,z2);
    std::list<Physics3dRaycastInfo> result =  Physics3Raycast(start,end,mask);

    lua_newtable(L);
    int i = 0;
    for(Physics3dRaycastInfo info : result) {
        lua_newtable(L);
        RectBodyPush(L,((RectBody*)info.body->getUserData()));
        lua_setfield(L,-2,"body");
        LUA_VECTOR3(L,"position",info.position.x,info.position.y,info.position.z);
        lua_rawseti(L, -2, i+1);
        i++;
    }
    return 1;

}

// Functions exposed to Lua
static const luaL_reg Module_methods[] ={
	{"clear", ClearLua},
	{"init", InitLua},
	{"update", UpdateLua},
	{"create_rect", CreateRectLua},
	{"destroy_rect", DestroyRectLua},
	{"raycast", Raycast},
	{"get_collision_info", GetCollisionInfoLua},
	{0, 0}
};

static void LuaInit(lua_State* L){
	int top = lua_gettop(L);
	// Register lua names
	luaL_register(L, MODULE_NAME, Module_methods);
	bindGroupsEnum(L);
	lua_setfield(L,-2,"GROUPS");

	lua_pop(L, 1);
	assert(top == lua_gettop(L));
}

static dmExtension::Result AppInitializeMyExtension(dmExtension::AppParams* params){return dmExtension::RESULT_OK;}
static dmExtension::Result InitializeMyExtension(dmExtension::Params* params){
	// Init Lua
	RectBodyBind(params->m_L);
	LuaInit(params->m_L);
	printf("Registered %s Extension\n", MODULE_NAME);
	return dmExtension::RESULT_OK;
}

static dmExtension::Result AppFinalizeMyExtension(dmExtension::AppParams* params){return dmExtension::RESULT_OK;}

static dmExtension::Result FinalizeMyExtension(dmExtension::Params* params){return dmExtension::RESULT_OK;}

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, AppInitializeMyExtension, AppFinalizeMyExtension, InitializeMyExtension, 0, 0, FinalizeMyExtension)