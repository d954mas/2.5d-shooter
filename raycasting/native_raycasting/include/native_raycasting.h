#pragma once
#include <dmsdk/sdk.h>
#include <vector>
#include "world_structures.h"
void getVisibleSprites(lua_State*);
void updateCamera(double, double, double);
void setCameraFov(double);
void setCameraRays(int);
void setMap(lua_State*);
void setCameraMaxDist(double);
void updatePlane(int, int, int, int);
void updateVisibleSprites(lua_State*);
void raycastVisibilityFov(lua_State*);
void findPath(int, int, int, int,std::vector<Point>*);