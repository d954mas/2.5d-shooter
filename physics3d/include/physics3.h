#pragma once
#include "reactphysics3d.h"


using namespace reactphysics3d;

rp3d::WorldSettings settings;
//settings.defaultVelocitySolverNbIterations = 20;
//settings.isSleepingEnabled = false;


// Contact manager
class ContactManager : public rp3d::CollisionCallback {
   public:
        ContactManager() {}
        /// This method will be called for each reported contact point
        virtual void notifyContact(const CollisionCallbackInfo& collisionCallbackInfo){

        }
};

class Physics3d {
  public:
    rp3d::CollisionWorld* world = NULL;
    ContactManager contact;
    Physics3d() {}
    void init(){
        clear();
        world = new rp3d::CollisionWorld(settings);
    }
    void clear(){
        delete world;
        world = NULL;
    }

    void update(){
        world->testCollision(&contact);
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

static void Physics3Update(){
    physics.update();
}

static void Physics3Clear(){
    printf("Physics3d clear\n");
    physics.clear();
}