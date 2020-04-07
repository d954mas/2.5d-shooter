#pragma once
#include "camera.h"
#include "math.h"
#include <dmsdk/dlib/log.h>

#define DLIB_LOG_DOMAIN "CAMERA"
Camera MAIN_CAMERA;


void CameraSetFov(Camera& camera, double fov){
    if (camera.fov == fov)return;
	dmLogInfo("fov changed:%.2f/%.2f",camera.fov, fov);
	camera.fov = fov;
	CameraViewDistanceUpdated(camera);

}
void CameraSetRays(Camera& camera,int rays){
    if (camera.rays == rays)return;
    dmLogInfo("rays changed:%d/%d",camera.rays, rays);
	camera.rays = (rays / 2) * 2; //make it even
	CameraViewDistanceUpdated(camera);
}
void CameraSetMaxDistance(Camera& camera,double distance){
    dmLogInfo("max distance changed:%.2f/%.2f",camera.maxDistance, distance);
	camera.maxDistance = distance;
}
void CameraViewDistanceUpdated(Camera& camera){
	camera.viewDist = camera.rays/(2 * tan(camera.fov/2.0));
	camera.angles.resize(MAIN_CAMERA.rays>>1);
	camera.angles.clear();
	for(int x=1;x<=camera.rays>>1;x++){
		camera.angles.push_back(atan(x/camera.viewDist));
	}
}
void CameraUpdate(Camera& camera,double x, double y, double angle){
	camera.x = x;
	camera.y = y;
	camera.angle = angle;
}