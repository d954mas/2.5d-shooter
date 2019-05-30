#pragma once
#include <unordered_set>
#include "camera.h"
#include "map.h"

void castRay(Camera*, double, Map*, double, std::unordered_set<ZoneData>&, bool);