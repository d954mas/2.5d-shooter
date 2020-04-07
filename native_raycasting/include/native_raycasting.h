#pragma once
#include <dmsdk/sdk.h>
#include <vector>
#include "camera.h"
#include "map.h"
#include <unordered_set>


void MapSet(lua_State*);
void CellsUpdateVisible(bool);

void CastRays(Camera&,std::unordered_set<CellData>& , bool);