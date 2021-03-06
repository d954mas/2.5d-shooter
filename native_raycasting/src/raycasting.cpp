#include <math.h>
#include "raycasting.h"
#include "map.h"
#include "camera.h"
#include <set>
//some problems here.Looks like mapX and mapY wrong.
static inline void countStep(int mapX, double startX, double dx, double absDx, int* stepX, double* sx){
	if (dx>0){
		*sx = (mapX - startX + 1) * absDx;
		*stepX = 1;
	}else{
		*sx = (startX  - mapX) * absDx;
		*stepX = - 1;
	}
}
void castRay(Camera* camera, double rayAngle, Map* map, double maxDistance, std::unordered_set<CellData> &cells, bool blocking){
	double angle = camera->angle + rayAngle;
	int mapX = (int)camera->x, mapY = (int)camera->y;
	double angleSin = sin(angle), angleCos = cos(angle);
	double dx = 1.0/angleSin, dy = 1.0/angleCos;
	double absDx = fabs(dx), absDy = fabs(dy);
	double sx=0, sy=0;
	int stepX, stepY;
	countStep(mapX, camera->x, dx, absDx, &stepX, &sx);
	countStep(mapY, camera->y, dy, absDy, &stepY, &sy);
	bool hitX = true;
	while (true){	
		double distanceX = mapX - (int)camera->x;
		double distanceY = mapY - (int)camera->y;
		double distX = fabs(distanceX);
		double distY = fabs(distanceY);
		if(mapX >= 0 && mapY >= 0 && mapX < map->width && mapY < map->height && distX <= maxDistance && distY <= maxDistance){
			CellData &cell = map->cells[map->CoordsToId(mapX,mapY)];
			cell.raycastingRight = distanceX > 0;
			cell.raycastingTop = distanceY > 0;
			cells.insert(cell);
			if(blocking){
				if(cell.blocked && !cell.transparent){
					return;
				}
			}
		}else{
			return;
		}
		if(sx < sy){
			mapX = mapX + stepX;
			sx = sx + absDx;
			hitX = true;
		}else{
			mapY = mapY + stepY;
			sy = sy + absDy;
			hitX = false;
		}
	}
} 