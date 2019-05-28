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

struct Point{int x, y;};


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
