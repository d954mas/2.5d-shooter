#include "world_structures.h"
#include <stdlib.h>
#include <dmsdk/sdk.h>

void parseMap(lua_State* L, struct Map* map){
	lua_getfield(L, 1, "WIDTH");
	lua_getfield(L, 1, "HEIGHT");
	int width = lua_tonumber(L, -2);
	int height = lua_tonumber(L, -1);
	lua_pop(L, 2);
	map->width = width;
	map->height = height;
	free(map->cells);
	map->cells = (ZoneData*)malloc(sizeof(ZoneData)*width*height);
	memset(map->cells, 0, sizeof(ZoneData)*width*height);
	lua_pushstring(L, "CELLS");
	lua_gettable(L, -2);
	lua_pushnil(L);
	for(int y = 0;lua_next(L, -2) != 0;y++){
		lua_pushnil(L);
		for(int x = 0;lua_next(L, -2) != 0;x++){
			map->cells[y * width + x].x = x;
			map->cells[y * width + x].y = y;
			lua_getfield(L, -1, "blocked");
			map->cells[y * width + x].blocked = lua_toboolean(L, -1);
			lua_pop(L, 2);
		}
		lua_pop(L, 1);
	}
}

void updateCamera(struct Camera* camera, double x, double y, double angle){
	camera->x = x;
	camera->y = y;
	camera->angle = angle;
}