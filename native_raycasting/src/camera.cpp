#pragma once
#include "camera.h"
#include "math.h"
#include <string>
#include <dmsdk/dlib/log.h>

#define META_NAME "Raycasting::CameraClass"

#define DLIB_LOG_DOMAIN "CAMERA"
Camera MAIN_CAMERA;


void CameraSetFov(Camera& camera, double fov){
    if (camera.fov == fov)return;
	//dmLogInfo("fov changed:%.2f/%.2f",camera.fov, fov);
	camera.fov = fov;
	CameraViewDistanceUpdated(camera);

}
void CameraSetRays(Camera& camera,int rays){
    if (camera.rays == rays)return;
   // dmLogInfo("rays changed:%d/%d",camera.rays, rays);
	camera.rays = (rays / 2) * 2; //make it even
	CameraViewDistanceUpdated(camera);
}
void CameraSetMaxDistance(Camera& camera,double distance){
    //dmLogInfo("max distance changed:%.2f/%.2f",camera.maxDistance, distance);
	camera.maxDistance = distance;
}
void CameraViewDistanceUpdated(Camera& camera){
	camera.angles.resize(camera.rays);
	camera.angles.clear();
	for(int x=0;x<camera.rays;x++){
		camera.angles.push_back(camera.fov/camera.rays * x);
	}
}


Camera* CameraCheck(lua_State *L, int index){
	 return *(Camera **)luaL_checkudata(L, index, META_NAME);
}
void CameraPush(lua_State *L, Camera *camera){
	Camera **lCamera = (Camera **)lua_newuserdata(L, sizeof(Camera*));
	*lCamera = camera;
	luaL_getmetatable(L, META_NAME);
	lua_setmetatable(L, -2);
}

static int CameraGetPos (lua_State *L){
	Camera *im = CameraCheck(L, 1);
	lua_pushnumber(L, im->x);
	lua_pushnumber(L, im->y);
	return 2;
}

static int CameraSetPos(lua_State *L){
	Camera *im = CameraCheck(L, 1);
	float x = luaL_checknumber(L,2);
	float y = luaL_checknumber(L,3);
	im->x = x;
	im->y = y;
	return 0;
}

static int CameraSetAngle(lua_State *L){
	Camera *im = CameraCheck(L, 1);
	float angle = luaL_checknumber(L,2);
	im->angle = angle;
	return 0;
}

static int CameraSetRays(lua_State *L){
	Camera *im = CameraCheck(L, 1);
	int rays = luaL_checknumber(L,2);
	CameraSetRays(*im,rays);
	return 0;
}

static int CameraSetFov(lua_State *L){
	Camera *im = CameraCheck(L, 1);
	float fov = luaL_checknumber(L,2);
	CameraSetFov(*im,fov);
	return 0;
}


static int CameraSetMaxDistance(lua_State *L){
	Camera *im = CameraCheck(L, 1);
	float maxDistance = luaL_checknumber(L,2);
	CameraSetMaxDistance(*im,maxDistance);
	return 0;
}

static int CameraToString(lua_State *L){
    Camera *im = CameraCheck(L, 1);
    std::string str = "Camera[x:" +  std::to_string(im->x) + " y:" +  std::to_string(im->y) + " angle:" +  std::to_string(im->angle)
        + " fov:" + std::to_string(im->fov) + " rays:" + std::to_string(im->rays) +
        + " maxDistance:" + std::to_string(im->maxDistance) + " ]";
    lua_pushstring(L,str.c_str());
	return 1;
}

void CameraBind(lua_State * L){
    luaL_Reg functions[] = {
        {"get_pos",CameraGetPos},
        {"set_pos",CameraSetPos},
        {"set_angle",CameraSetAngle},
        {"set_rays",CameraSetRays},
        {"set_fov",CameraSetFov},
        {"set_max_dist",CameraSetMaxDistance},

        {"__tostring",CameraToString},
        { 0, 0 }
    };
    luaL_newmetatable(L, META_NAME);
	luaL_register (L, NULL,functions);
    //     1| metatable "luaL_Foo"   |-1
    lua_pushvalue(L, -1);
    //     2| metatable "luaL_Foo"   |-1
    //     1| metatable "luaL_Foo"   |-2
    // Set the "__index" field of the metatable to point to itself
    // This pops the stack
    lua_setfield(L, -1, "__index");
    lua_pop(L, 1);
}