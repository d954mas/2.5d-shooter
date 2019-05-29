#pragma once
#include <unordered_set>
#include "world_structures.h"
#include "camera.h"
#include "map.h"

void castRay(Camera*, double, Map*, double, std::unordered_set<Zone>&, bool);