#pragma once
#include <dmsdk/sdk.h>
#include <tuple>
#include "micropather.h"
#include <limits>
#include "math.h"
#include "cell_data.h"
#include <vector>
#include <functional>
using namespace micropather;

class Map  : public Graph{
	private:
		MicroPather* pather;
	public:
		int width, height;
		CellData* cells;
		Map();
		virtual ~Map();
		inline int CoordsToId(int x,int y){return  y * width + x;}
		inline bool Passable(int x, int y) {
			if (x >= 0 && x < width && y >= 0 && y < height){
				CellData cell = cells[CoordsToId(x,y)];
				return !cell.blocked;
			}		
			return false;
		}
		void findPath(int, int, int, int, std::vector<CellData*>&);
		virtual float LeastCostEstimate( void* stateStart, void* stateEnd );
		virtual void AdjacentCost( void* state, MP_VECTOR< micropather::StateCost > *neighbors );
		virtual void PrintStateInfo(void* state);
};
void MapParse(lua_State*);
void MapFindPath(int, int, int, int, std::vector<CellData*>&);