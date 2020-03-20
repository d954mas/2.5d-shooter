#pragma once
#include "reactphysics3d.h"


using namespace reactphysics3d;

rp3d::WorldSettings settings;
//settings.defaultVelocitySolverNbIterations = 20;
//settings.isSleepingEnabled = false;

rp3d::CollisionWorld *world = new rp3d::CollisionWorld(settings);

void Physics3Clear(){
	delete world;
	world = new rp3d::CollisionWorld(settings);
}