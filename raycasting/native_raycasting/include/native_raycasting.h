#pragma once
#include <dmsdk/sdk.h>
#include <vector>
#include "world_structures.h"
#include "camera.h"


void getVisibleSprites(lua_State*);
void setMap(lua_State*);
void updatePlane(int, int, int, int);
void updateVisibleSprites(lua_State*);
void findPath(int, int, int, int,std::vector<Point>*);