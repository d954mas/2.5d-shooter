#pragma once
#include <dmsdk/sdk.h>
#include <tuple>
#include "micropather.h"
#include <limits>
#include <vector>
#include "map.h"


Map::Map(){
	pather = new MicroPather( this, 20 );	// Use a very small memory block to stress the pather
}
Map::~Map() {delete pather;}

//Return the least possible cost between 2 states.
float Map::LeastCostEstimate( void* stateStart, void* stateEnd ){
	ZoneData start = cells[*((int *)stateStart)];
	ZoneData end = cells[*((int *)stateEnd)];
	return  pow(end.x - start.x,2) + pow(end.y - start.y,2);
}
void Map::AdjacentCost( void* state, MP_VECTOR< micropather::StateCost > *neighbors  ){
	ZoneData zoneData = cells[*((int *)state)];
	for(int y=-1;y<=1;y++){
		for(int x=-1;x<=1;x++){
			if(x!=0 && y!=0){
				bool pass = Passable(zoneData.x + x,zoneData.y+y);
				if (pass) {
					//TODO add bigger dist for diagonals
					StateCost nodeCost = {(void*)CoordsToId(zoneData.x+x,zoneData.y+y), 1};
					neighbors ->push_back(nodeCost);
				}
			}
		}
	}
}

/**This function is only used in DEBUG mode - it dumps output to stdout. Since void* 
aren't really human readable, normally you print out some concise info (like "(1,2)") 
without an ending newline.*/
void Map::PrintStateInfo(void* state){printf("print info");}

void Map::findPath(int x, int y, int x2, int y2, std::vector<Point>* points){
	points->clear();
	void* startState = (void*)( y * width + x );
	void* endState = (void*)( y2 * width + x2 );
	std::vector< void* > path;
	float totalCost = 0;
	int result = pather->Solve( startState, endState, &path, &totalCost );
	for(void* id: path){
		ZoneData zoneData = cells[*((int *)id)];
		Point point;
		point.x = zoneData.x;
		point.y = zoneData.y;
		points->push_back(point);
	}
	pather->Reset();
}

namespace std {
	template <>
	struct hash<ZoneData>
	{
		std::size_t operator()(const ZoneData& z) const
		{
			std::hash<int> hash_fn;
			std::size_t h1 = hash_fn(z.id);
			return h1;
		}
	};

}