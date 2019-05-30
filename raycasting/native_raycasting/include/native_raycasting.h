#pragma once
#include <dmsdk/sdk.h>
#include <vector>
#include "camera.h"
#include "map.h"


void getVisibleSprites(lua_State*);
void setMap(lua_State*);
void updatePlane(int, int, int, int);
void updateVisibleSprites(lua_State*);
void findPath(int, int, int, int, std::vector<ZoneData>&);