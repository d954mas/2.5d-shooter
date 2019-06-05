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

namespace std {
	template <>
	struct hash<CellData>{
		std::size_t operator()(const CellData& z) const{
			return std::hash<int>()(z.id);
		}
	};
}

void CellDataBind(lua_State*);
CellData* CellDataCheck(lua_State*, int);
void CellDataPush(lua_State *, CellData *);
