#pragma once
#include "reactphysics3d.h"
#include "rectbody.h"


using namespace reactphysics3d;

rp3d::WorldSettings settings;
//settings.defaultVelocitySolverNbIterations = 20;
//settings.isSleepingEnabled = false;




// Contact manager
class ContactManager : public rp3d::CollisionCallback {
   public:
        ContactManager() {}
        /// This method will be called for each reported contact point
        void notifyContact(const CollisionCallbackInfo& collisionCallbackInfo){

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

    RectBody* createRectBody(float x, float y, float z,float w,float h, float l, bool mStatic){
        RectBody* body = new RectBody();
        //create body
        rp3d::Vector3 initPosition(x, y, z);
        rp3d::Quaternion initOrientation = rp3d::Quaternion::identity();
        rp3d::Transform transform(initPosition, initOrientation);
        
        body->position = initPosition;
        body->rotation = initOrientation;
        body->mStatic = mStatic;
         
        body->body = world->createCollisionBody(transform);

        // Create the box shape
        const rp3d::Vector3 halfSize(w/2.0, h/2.0, l/2.0);
        const rp3d::Vector3 size(w, h, l);
        body->size = size;
        
        body->boxShape = new rp3d::BoxShape(halfSize);
        
        // Add the collision shape to the rigid body
        // Place the shape at the origin of the body local-space 
        rp3d::ProxyShape* proxyShape;
        proxyShape = body->body->addCollisionShape(body->boxShape, rp3d::Transform::identity());

        return body;
    }

    void destroyRectBody(RectBody* body){
        world->destroyCollisionBody(body->body);
        delete body->boxShape;
        delete body;
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



static RectBody* Physics3CreateRectBody(float x,float y, float z, float w, float h, float l, bool mStatic){
    return physics.createRectBody(x,y,z,w,h,l,mStatic);
}

static void Physics3DestroyRectBody(RectBody* rect){
    physics.destroyRectBody(rect);
}