#pragma once
#include "reactphysics3d.h"


using namespace reactphysics3d;

rp3d::WorldSettings settings;
//settings.defaultVelocitySolverNbIterations = 20;
//settings.isSleepingEnabled = false;

class Physics3d {
  public:
    rp3d::CollisionWorld* world = NULL;
    Physics3d() {}
    void init(){
        clear();
        world = new rp3d::CollisionWorld(settings);
    }
    void clear(){
        delete world;
        world = NULL;
    }
    ~Physics3d(){
        delete world;
    }
};

Physics3d physics;

static void Physics3Init(){
    printf("Physics3d init\n");
    physics.init();
}

static void Physics3Clear(){
    printf("Physics3d clear\n");
    physics.clear();
}