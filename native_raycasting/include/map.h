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
		inline bool Passable(int startX, int startY, int endX, int endY) {
			if (startX >= 0 && startX < width && startY >= 0 && startY < height
			&& endX >= 0 && endX < width && endY >= 0 && endY < height){
			    CellData startCell = cells[CoordsToId(startX,startY)];
			    if(startCell.blocked){return false;}
				CellData cell = cells[CoordsToId(endX,endY)];
				if (cell.blocked){
				    return false;
				}else{
				   int dx = endX-startX;
				   int dy = endY-startY;
				     //check diagonals
				   if (dx!=0 && dy !=0){
				        CellData cell1 = cells[CoordsToId(startX+dx,startY)];
				        CellData cell2 = cells[CoordsToId(startX,startY+dy)];
				        return !cell1.blocked && !cell2.blocked;
				   }else{
				        return !cell.blocked;
				   }
				}
				return !cell.blocked;
			}		
			return false;
		}
		void findPath(int, int, int, int, std::vector<CellData*>&);
		virtual float LeastCostEstimate( void* stateStart, void* stateEnd );
		virtual void AdjacentCost( void* state, MP_VECTOR< micropather::StateCost > *neighbors );
		virtual void PrintStateInfo(void* state);
		virtual void changeCellBlocked(int x, int y, bool blocked);
		virtual void changeCellTransparent(int x, int y, bool transparent);
};

void MapParse(lua_State*);
void MapFindPath(int, int, int, int, std::vector<CellData*>&);
void MapChangeCellBlocked(int x, int y, bool blocked);
void MapChangeCellTransparent(int x, int y, bool transparent);