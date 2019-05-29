#pragma once
#include "camera.h"
#include "math.h"

Camera MAIN_CAMERA;

void CameraSetFov(double fov){
	MAIN_CAMERA.fov = fov;
	CameraViewDistanceUpdated();
}
void CameraSetRays(int rays){
	MAIN_CAMERA.rays = (rays / 2) * 2; //make it even
	CameraViewDistanceUpdated();
}
void CameraSetMaxDistance(double distance){
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