#pragma once
#include <dmsdk/sdk.h>
#include <tuple>
#include "micropather.h"
#include <limits>
#include "math.h"
#include <vector>
#include <functional>
#include "world_structures.h"
using namespace micropather;

struct ZoneData{
	bool top, right; //Mark which sides of wall we see
	bool rayCasted, visibility, blocked;
	int x,y,id; //x,y,id starts from 0. In lua they will be start from 1
	bool operator == ( const ZoneData& a ) const{
		return id == a.id;
	}
	bool operator<(const ZoneData& a) const {
		return id < a.id;
	};
};
class Map  : public Graph{
	private:
		MicroPather* pather;
	public:
		int width, height;
		ZoneData* cells;
		Map();
		virtual ~Map();
		inline int CoordsToId(int x,int y){return  y * width + x;}
		inline bool Passable(int x, int y) {
			if (x >= 0 && x < width && y >= 0 && y < height){
				ZoneData cell = cells[CoordsToId(x,y)];
				return !cell.blocked;
			}		
			return false;
		}
		void findPath(int, int, int, int, std::vector<Point>*);
		virtual float LeastCostEstimate( void* stateStart, void* stateEnd );
		virtual void AdjacentCost( void* state, MP_VECTOR< micropather::StateCost > *neighbors );
		virtual void PrintStateInfo(void* state);
};
void parseMap(lua_State*, struct Map*);