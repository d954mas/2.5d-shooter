#pragma once
#include <dmsdk/sdk.h>

static inline int LuaCheckNumber(lua_State* L, int index, const char *error){
    if(!lua_isnumber(L,index)){
        lua_pushstring(L, error);
        lua_error(L);
    }
    return lua_tonumber(L,index);
}

static inline double LuaCheckNumberD(lua_State* L, int index, const char *error){
    if(!lua_isnumber(L,index)){
        lua_pushstring(L, error);
        lua_error(L);
    }
    return lua_tonumber(L,index);
}