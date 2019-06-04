#pragma once
#include <dmsdk/sdk.h>
#include <tuple>
#include "micropather.h"
#include <limits>
#include "math.h"
#include <vector>
#include <functional>
using namespace micropather;

struct CellData{
	//use prevValues to find if cellData was updated
	bool top, right, raycastingTop,raycastingRight; //Mark which sides of wall we see
	bool rayCasted, visibility,raycastingVisibility, blocked;
	int x,y,id; //x,y,id starts from 0. In lua they will be start from 1
	bool operator == ( const CellData& a ) const{
		return id == a.id;
	}
	bool operator<(const CellData& a) const {
		return id < a.id;
	};
};
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
		void findPath(int, int, int, int, std::vector<CellData>&);
		virtual float LeastCostEstimate( void* stateStart, void* stateEnd );
		virtual void AdjacentCost( void* state, MP_VECTOR< micropather::StateCost > *neighbors );
		virtual void PrintStateInfo(void* state);
};

namespace std {
	template <>
	struct hash<CellData>{
		std::size_t operator()(const CellData& z) const{
			return std::hash<int>()(z.id);
		}
	};
}
void MapParse(lua_State*);
void MapFindPath(int, int, int, int, std::vector<CellData>&);