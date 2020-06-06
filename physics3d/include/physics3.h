#pragma once
#include "reactphysics3d.h"
#include "rectbody.h"
#include "collision/ContactManifold.h"
#include "constraint/ContactPoint.h"
#include <list>
#include <iostream>


using namespace reactphysics3d;

rp3d::WorldSettings settings;
//settings.defaultVelocitySolverNbIterations = 20;
//settings.isSleepingEnabled = false;

struct CollisionInfoManifoldPoint {
    rp3d::Vector3 normal,point1,point2;
    float depth;
};

struct CollisionInfoManifold {
    std::list<CollisionInfoManifoldPoint> points;
};

struct CollisionInfo {
    RectBody* body1;
    RectBody* body2;
    std::list<CollisionInfoManifold> manifolds;
};

struct Physics3dRaycastInfo {
    CollisionBody* body;
    ProxyShape* shape;
    rp3d::Vector3 position;
};

// Class WorldRaycastCallback
class RaycastCallbackAll : public rp3d::RaycastCallback {

public:
      std::list<Physics3dRaycastInfo> objects;

   virtual decimal notifyRaycastHit(const RaycastInfo& info) {
      // Display the world hit point coordinates
      Physics3dRaycastInfo savedInfo;
      savedInfo.position.x = info.worldPoint.x;
      savedInfo.position.y = info.worldPoint.y;
      savedInfo.position.z = info.worldPoint.z;
      savedInfo.body = info.body;
      savedInfo.shape = info.proxyShape;
      // Return a fraction of 1.0 to gather all hits
      objects.push_back(savedInfo);
      return decimal(1.0);
    }

    std::list<Physics3dRaycastInfo> getObjects() {return objects;}
};


// Contact manager
class ContactManager : public rp3d::CollisionCallback {
    private:
          std::list<CollisionInfo*> collisionInfoList;
    public:
        ContactManager() {}
        /// This method will be called for each reported contact point
        virtual void notifyContact(const CollisionCallbackInfo& collisionCallbackInfo){
            CollisionInfo* info = new CollisionInfo();
            info->body1 = ((RectBody*)(collisionCallbackInfo.body1->getUserData()));
            info->body2 = ((RectBody*)(collisionCallbackInfo.body2->getUserData()));

            rp3d::ContactManifoldListElement* manifoldElement = collisionCallbackInfo.contactManifoldElements;
            while (manifoldElement != nullptr) {
                // Get the contact manifold
                rp3d::ContactManifold* contactManifold = manifoldElement->getContactManifold();
                CollisionInfoManifold manifold;


                // For each contact point
                rp3d::ContactPoint* contactPoint = contactManifold->getContactPoints();
                while (contactPoint != nullptr) {
                    // Contact normal
                    rp3d::Vector3 normal = contactPoint->getNormal();
                    rp3d::Vector3 point1 = contactPoint->getLocalPointOnShape1();
                    point1 = collisionCallbackInfo.proxyShape1->getLocalToWorldTransform() * point1;

                    rp3d::Vector3 point2 = contactPoint->getLocalPointOnShape2();
                    point2 = collisionCallbackInfo.proxyShape2->getLocalToWorldTransform() * point2;

                    CollisionInfoManifoldPoint point;
                    point.normal = normal;
                    point.point1 = point1;
                    point.point2 = point2;
                    point.depth = contactPoint->getPenetrationDepth();
                    manifold.points.push_back(point);

                    contactPoint = contactPoint->getNext();
                }

                info->manifolds.push_back(manifold);
                manifoldElement = manifoldElement->getNext();
            }
            
            collisionInfoList.push_back(info);
        }

        void clearCollision(){
            for(auto &it:collisionInfoList) delete it; collisionInfoList.clear();
        }

        std::list<CollisionInfo*> getCollisionInfo(){
            return collisionInfoList;
        }
};

#define LUA_ENUM(L, name, val) \
  lua_pushnumber(L, val); \
  lua_setfield(L,-2, name);

static void bindGroupsEnum(lua_State* L){
    lua_newtable(L);
	LUA_ENUM(L,"OBSTACLE",0x0001);
	LUA_ENUM(L,"PICKUPS",0x0002);
	LUA_ENUM(L,"PLAYER",0x0004);
	LUA_ENUM(L,"ENEMY",0x0008);
	LUA_ENUM(L,"BULLET_PLAYER",0x0010);
}



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
        contact.clearCollision();
        delete world;
        world = NULL;
    }

    RectBody* createRectBody(float x, float y, float z,float w,float h, float l, bool mStatic, unsigned short group,  unsigned short mask){
        RectBody* body = new RectBody();
        //create body
        rp3d::Vector3 initPosition(x, y, z);
        rp3d::Quaternion initOrientation = rp3d::Quaternion::identity();
        rp3d::Transform transform(initPosition, initOrientation);
        
        body->position = initPosition;
        body->rotation = initOrientation;
        body->mStatic = mStatic;
         
        body->body = world->createCollisionBody(transform);

        body->body->setUserData(body);

        // Create the box shape
        const rp3d::Vector3 halfSize(w/2.0, h/2.0, l/2.0);
        const rp3d::Vector3 size(w, h, l);
        body->size = size;
        
        body->boxShape = new rp3d::BoxShape(halfSize);
        
        // Add the collision shape to the rigid body
        // Place the shape at the origin of the body local-space 
        rp3d::ProxyShape* proxyShape;
        proxyShape = body->body->addCollisionShape(body->boxShape, rp3d::Transform::identity());
        proxyShape->setCollisionCategoryBits(group);
        proxyShape->setCollideWithMaskBits(mask);

        body->group = group;
        body->mask = mask;
        body->proxyShape = proxyShape;

        return body;
    }

    void destroyRectBody(RectBody* body){
        world->destroyCollisionBody(body->body);
        delete body->boxShape;
        delete body;
    }

    void update(){
        contact.clearCollision();
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

static std::list<CollisionInfo*> Physics3GetCollisionInfo(){
    return physics.contact.getCollisionInfo();
}

static std::list<Physics3dRaycastInfo> Physics3Raycast(rp3d::Vector3 start, rp3d::Vector3 end){
    // Create the ray
    rp3d::Ray ray(start, end);
    // Create an instance of your callback class
    RaycastCallbackAll callbackObject;
    // Raycast test
    physics.world->raycast(ray, &callbackObject);
    return callbackObject.getObjects();
}

static std::list<Physics3dRaycastInfo>  Physics3Raycast(rp3d::Vector3 start, rp3d::Vector3 end, unsigned short mask){
    std::list<Physics3dRaycastInfo>  info = Physics3Raycast(start,end);
    std::list<Physics3dRaycastInfo>::iterator i = info.begin();
    while (i != info.end()) {
        Physics3dRaycastInfo data = *i;
        if ((data.shape->getCollisionCategoryBits() & mask) == 0){
            info.erase(i++);
        }else{
            ++i;
        }
    }
    //  info.remove_if([](RaycastInfo info) { return (info.shape->getCollisionCategoryBits() & mask) !=0;  });
    return info;
}



static RectBody* Physics3CreateRectBody(float x,float y, float z, float w, float h, float l, bool mStatic, unsigned short group, unsigned short mask){
    return physics.createRectBody(x,y,z,w,h,l,mStatic,group,mask);
}

static void Physics3DestroyRectBody(RectBody* rect){
    physics.destroyRectBody(rect);
}