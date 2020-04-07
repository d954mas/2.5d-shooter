#pragma once
#include <dmsdk/sdk.h>
#include <vector>

struct Camera {
	double x = 0,y = 0,angle = 0;
	double fov=3.1415/2.0 * 1.3;
	int rays = 128; //rays always power of two
	double viewDist=0,maxDistance=0;
	std::vector<double> angles; //angle for every ray
};

void CameraUpdate(Camera&, double, double, double);
void CameraSetFov(Camera&, double);
void CameraSetRays(Camera&, int);
void CameraSetMaxDistance(Camera&, double);
void CameraViewDistanceUpdated(Camera&);
