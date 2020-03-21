#include <dmsdk/sdk.h>
#include "reactphysics3d.h"

#define META_NAME "physics3::RectBody"

struct RectBody{
    rp3d::Vector3 position;
    rp3d::Vector3 halfSize;
    rp3d::CollisionBody* body;
    rp3d::BoxShape* boxShape;
    rp3d::Quaternion rotation;
    float angle;
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

static int RectBodyToString(lua_State *L){
    RectBody *im = RectBodyCheck(L, 1);
    std::string str = "[Rect. Pos:" +  std::to_string(im->position.x) + " " +  std::to_string(im->position.y) + " " +  std::to_string(im->position.z)
    + " Size:" +  std::to_string(im->halfSize.x * 2) + " " +  std::to_string(im->halfSize.y * 2) + " " +  std::to_string(im->halfSize.z * 2) + "]";
    lua_pushstring(L,str.c_str());
	return 1;
}

void RectBodyBind(lua_State * L){
    luaL_Reg functions[] = {
        {"__tostring",RectBodyToString},
        { 0, 0 }
    };
    luaL_newmetatable(L, META_NAME);
	luaL_register (L, NULL,functions);
    lua_pushvalue(L, -1);
    lua_setfield(L, -1, "__index");
    lua_pop(L, 1);
}
