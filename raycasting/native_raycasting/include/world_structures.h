#pragma once
#include <dmsdk/sdk.h>
#include <tuple>
#include "micropather.h"
#include <limits>
#include <vector>
#include <functional>
using namespace micropather;
struct Camera {
	double x = 1;
	double y = 1;
	double angle = 0;
	double fov=3.1415/2.0 * 1.3;
	int rays = 128;
};

struct ZoneData{
	bool visibility;
	bool top;
	bool right;
	bool rayCasted;
	bool blocked; 
	int x;
	int y;
};

struct Point{
	int x, y;
};


class Map  : public Graph{
	private:
		MicroPather* pather;
	public:
		int width;
		int height;
		ZoneData* cells;
		Map()
		{
			pather = new MicroPather( this, 20 );	// Use a very small memory block to stress the pather
		}
		virtual ~Map() {
			delete pather;
		}
		/**
		Return the least possible cost between 2 states. For example, if your pathfinding 
		is based on distance, this is simply the straight distance between 2 points on the 
		map. If you pathfinding is based on minimum time, it is the minimal travel time 
		between 2 points given the best possible terrain.
		*/
		virtual float LeastCostEstimate( void* stateStart, void* stateEnd ){
			ZoneData start = cells[*((int *)stateStart)];
			ZoneData end = cells[*((int *)stateEnd)];
			/* Compute the minimum path cost using distance measurement. It is possible
			to compute the exact minimum path using the fact that you can move only 
			on a straight line or on a diagonal, and this will yield a better result.
			*/
			int dx = start.x - end.x;
			int dy = start.y - end.y;
			if ( (dx != 0) && (dy != 0) ){
				// no diagonal move
				return std::numeric_limits<float>::infinity();
			}else if (dx!=0) {
				return dx;
			}else if( dy!=0){
				return dy;
			}
			return 0;
		}

		/** 
		Return the exact cost from the given state to all its neighboring states. This
		may be called multiple times, or cached by the solver. It *must* return the same
		exact values for every call to MicroPather::Solve(). It should generally be a simple,
		fast function with no callbacks into the pather.
		*/	
		virtual void AdjacentCost( void* state, MP_VECTOR< micropather::StateCost > *neighbors  ){
			ZoneData zoneData = cells[*((int *)state)];
			bool pass = Passable(zoneData.x + 1,zoneData.y);
			if (pass) {
				StateCost nodeCost = {(void*)( zoneData.y * width + zoneData.x +1 ), 1};
				neighbors ->push_back( nodeCost );
			}
			pass = Passable(zoneData.x - 1,zoneData.y);
			if (pass) {
				StateCost nodeCost = {(void*)( zoneData.y * width + zoneData.x - 1), 1};
				neighbors ->push_back( nodeCost );
			}
			pass = Passable(zoneData.x,zoneData.y - 1);
			if (pass) {
				StateCost nodeCost = {(void*)( (zoneData.y - 1) * width + zoneData.x), 1};
				neighbors ->push_back( nodeCost );
			}
				pass = Passable(zoneData.x,zoneData.y + 1);
			if (pass) {
				StateCost nodeCost = {(void*)( (zoneData.y + 1)* width + zoneData.x), 1};
				neighbors ->push_back( nodeCost );
			}
		}

		virtual bool Passable(int x, int y) {
			if (x >= 0 && x < width && y >= 0 && y < height){
				ZoneData cell = cells[y * width + x];
				return !cell.blocked;
			}		
			return false;
		}

		/**
		This function is only used in DEBUG mode - it dumps output to stdout. Since void* 
		aren't really human readable, normally you print out some concise info (like "(1,2)") 
		without an ending newline.
		*/
		virtual void PrintStateInfo(void* state){
			printf("print info");
		}

		void findPath(int x, int y, int x2, int y2, std::vector<Point>* points){
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
};

struct Zone{
	int x,y;
	bool right,top;
	bool operator == ( const Zone& p ) const
	{
		return ( ( x == p.x ) && ( y == p.y ) );
	}
};

namespace std {
	template <>
	struct hash<Zone>
	{
		std::size_t operator()(const Zone& z) const
		{
			std::hash<int> hash_fn;
			std::size_t h1 = hash_fn(z.x);
			std::size_t h2 = hash_fn(z.y);
			return h1 ^ h2;
		}
	};

}
inline bool operator<(const Zone& lhs, const Zone& rhs){
	if(lhs.x == rhs.x){
		return lhs.y < rhs.y;
	}else{
		return lhs.x < rhs.x;
	}
};

void updateCamera(struct Camera*, double, double, double);
void parseMap(lua_State*, struct Map*);
