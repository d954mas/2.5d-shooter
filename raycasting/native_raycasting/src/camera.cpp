#pragma once
#include "camera.h"
#include "math.h"
#include <dmsdk/dlib/log.h>

#define DLIB_LOG_DOMAIN "CAMERA"
Camera MAIN_CAMERA;

void CameraSetFov(double fov){
    if (MAIN_CAMERA.fov == fov)return;
    dmLogInfo("fov changed:%.2f/%.2f",MAIN_CAMERA.fov, fov);
	MAIN_CAMERA.fov = fov;
	CameraViewDistanceUpdated();

}
void CameraSetRays(int rays){
    if (MAIN_CAMERA.rays == rays)return;
    dmLogInfo("rays changed:%d/%d",MAIN_CAMERA.rays, rays);
	MAIN_CAMERA.rays = (rays / 2) * 2; //make it even
	CameraViewDistanceUpdated();
}
void CameraSetMaxDistance(double distance){
    dmLogInfo("max distance changed:%.2f/%.2f",MAIN_CAMERA.maxDistance, distance);
	MAIN_CAMERA.maxDistance = distance;
}
void CameraViewDistanceUpdated(){
	MAIN_CAMERA.viewDist = MAIN_CAMERA.rays/(2 * tan(MAIN_CAMERA.fov/2.0));
	MAIN_CAMERA.angles.resize(MAIN_CAMERA.rays>>1);
	MAIN_CAMERA.angles.clear();
	for(int x=1;x<=MAIN_CAMERA.rays>>1;x++){
		MAIN_CAMERA.angles.push_back(atan(x/MAIN_CAMERA.viewDist));
	}
}
void CameraUpdate(double x, double y, double angle){
	MAIN_CAMERA.x = x;
	MAIN_CAMERA.y = y;
	MAIN_CAMERA.angle = angle;
}