#include <dmsdk/sdk.h>
#include "reactphysics3d.h"

#define META_NAME "physics3::RectBody"

struct RectBody{
    rp3d::Vector3 position;
    rp3d::Vector3 size;
    rp3d::Quaternion rotation;
    rp3d::CollisionBody* body;
    rp3d::BoxShape* boxShape;
    unsigned char group,mask;
    bool mStatic;
    rp3d::ProxyShape* proxyShape;
    int userDataRef=LUA_REFNIL;
};

RectBody* RectBodyCheck(lua_State *L, int index){
	 return *(RectBody **)luaL_checkudata(L, index, META_NAME);
}

void RectBodyPush(lua_State *L, RectBody *rectBody){
	RectBody **lrectBody= (RectBody **)lua_newuserdata(L, sizeof(RectBody*));
	*lrectBody = rectBody;
	luaL_getmetatable(L, META_NAME);
	lua_setmetatable(L, -2);
}

static int RectBodyIsStatic(lua_State *L){
     RectBody *im = RectBodyCheck(L, 1);
     lua_pushboolean(L,im->mStatic);
     return 1;
}

static int RectBodyGetPosition(lua_State *L){
     RectBody *im = RectBodyCheck(L, 1);
     lua_pushnumber(L,im->position.x);
     lua_pushnumber(L,im->position.y);
     lua_pushnumber(L,im->position.z);
     return 3;
}

static void RectBodyUpdateTransform(RectBody* rect){
    rp3d::Transform newTransform(rect->position, rect->rotation);
    rect->body->setTransform(newTransform);
}

static int RectBodySetPosition(lua_State *L){
     RectBody *im = RectBodyCheck(L, 1);
     if(im->mStatic){
        lua_pushstring(L, "can't move static body");
        lua_error(L);
        return 0;
     }
     float x = luaL_checknumber(L,2), y = luaL_checknumber(L,3), z = luaL_checknumber(L,4);
     im->position.x = x; im->position.y = y; im->position.z = z;
     RectBodyUpdateTransform(im);
     return 0;
}



static int RectBodyGetSize(lua_State *L){
     RectBody *im = RectBodyCheck(L, 1);
     lua_pushnumber(L,im->size.x);
     lua_pushnumber(L,im->size.y);
     lua_pushnumber(L,im->size.z);
     return 3;
}


static int RectBodyToString(lua_State *L){
    RectBody *im = RectBodyCheck(L, 1);
    std::string str = "[Rect. Pos:" +  std::to_string(im->position.x) + " " +  std::to_string(im->position.y) + " " +  std::to_string(im->position.z)
    + " Size:" +  std::to_string(im->size.x) + " " +  std::to_string(im->size.y ) + " " +  std::to_string(im->size.z) + "]";
    lua_pushstring(L,str.c_str());
	return 1;
}

static int RectBodySetUserData(lua_State *L){
    RectBody *im = RectBodyCheck(L, 1);
    lua_istable(L,2);
    luaL_unref(L, LUA_REGISTRYINDEX, im->userDataRef);
    int id = luaL_ref(L,LUA_REGISTRYINDEX);
    im->userDataRef = id;
    return 0;
}

static int RectBodyGetUserData(lua_State *L){
    RectBody *im = RectBodyCheck(L, 1);
    lua_rawgeti(L,LUA_REGISTRYINDEX,im->userDataRef);
    return 1;
}


void RectBodyBind(lua_State * L){
    luaL_Reg functions[] = {
        {"is_static",RectBodyIsStatic},
        {"get_position",RectBodyGetPosition},
        {"set_position",RectBodySetPosition},
        {"get_size",RectBodyGetSize},
        {"get_user_data",RectBodyGetUserData},
        {"set_user_data",RectBodySetUserData},

        {"__tostring",RectBodyToString},
        { 0, 0 }
    };
    luaL_newmetatable(L, META_NAME);
	luaL_register (L, NULL,functions);
    lua_pushvalue(L, -1);
    lua_setfield(L, -1, "__index");
    lua_pop(L, 1);
}
