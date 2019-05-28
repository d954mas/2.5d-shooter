#pragma once
#include <unordered_set>
#include "world_structures.h"

void castRay(Camera*, double, Map*, double, std::unordered_set<Zone>&, bool);