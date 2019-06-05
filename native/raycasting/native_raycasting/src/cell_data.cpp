#pragma once
#include <dmsdk/sdk.h>
#include "cell_data.h"


#define META_NAME "Raycasting::CellDataClass"

CellData* CellDataCheck(lua_State *L, int index){
	 return *(CellData **)luaL_checkudata(L, index, META_NAME);
}

void CellDataPush(lua_State *L, CellData *cellData){
	CellData **lCellData = (CellData **)lua_newuserdata(L, sizeof(CellData*));
	*lCellData = cellData;
	luaL_getmetatable(L, META_NAME);
	lua_setmetatable(L, -2);
}

static int CellDataBindGetX (lua_State *L){
	CellData *im = CellDataCheck(L, 1);
	printf("x:%d\n",im->x);
	lua_pushnumber(L, im->x+1);
	return 1;
}

static int CellDataBindGetY (lua_State *L){
	CellData *im = CellDataCheck(L, 1);
	lua_pushnumber(L, im->y+1);
	return 1;
}

static int CellDataBindGetVisibility(lua_State *L){
	CellData *im = CellDataCheck(L, 1);
	lua_pushboolean(L, im->visibility);
	return 1;
}

void CellDataBind(lua_State * L){
    luaL_Reg functions[] = {
        {"get_x",CellDataBindGetX},
        {"get_y",CellDataBindGetY},
        {"get_visibility",CellDataBindGetVisibility},
        { 0, 0 }
    };
    luaL_newmetatable(L, META_NAME);
	luaL_register (L, NULL,functions);
    //     1| metatable "luaL_Foo"   |-1
    lua_pushvalue(L, -1);
    //     2| metatable "luaL_Foo"   |-1
    //     1| metatable "luaL_Foo"   |-2
    // Set the "__index" field of the metatable to point to itself
    // This pops the stack
    lua_setfield(L, -1, "__index");
    lua_pop(L, 1);
}