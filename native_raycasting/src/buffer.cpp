#include "buffer.h"

#define META_NAME "Raycasting::BufferClass"

#include <string>
#include "colors.h"

Buffer* BufferCreate(dmBuffer::HBuffer& buffer, int w, int h, int channels){
    Buffer* resultBuffer = new Buffer();
    assert(dmBuffer::IsBufferValid(buffer));
    resultBuffer->buffer = buffer;
    dmBuffer::Result result = dmBuffer::GetBytes(resultBuffer->buffer, (void**)&resultBuffer->bytes, &resultBuffer->length);
    assert(result == dmBuffer::RESULT_OK);
    assert(channels == 3);   //alpha chanel not supported.Not need it.
    assert(w > 0);
    assert(h> 0);

    resultBuffer->width = w;
    resultBuffer->height = h;
    resultBuffer->channels = channels;
    return resultBuffer;
}
void BufferDestroy(Buffer* buffer){
    delete buffer;
}

Buffer* BufferCheck(lua_State *L, int index){
    return *(Buffer **)luaL_checkudata(L, index, META_NAME);
}
void BufferPush(lua_State *L, Buffer *buffer){
    Buffer **lbuffer = (Buffer **)lua_newuserdata(L, sizeof(Buffer*));
	*lbuffer = buffer;
	luaL_getmetatable(L, META_NAME);
	lua_setmetatable(L, -2);
}



static int BufferBindClear(lua_State *L){
    Buffer *b = BufferCheck(L, 1);
    return 0;
}

static int BufferBindSetColor(lua_State *L){
    Buffer *buffer = BufferCheck(L, 1);

    int id = lua_tonumber(L,2);
    int color = lua_tonumber(L,3);
    int r,g,b;
    RGBIntToRGB(color, r,g,b);
    BufferSetColorYTop(buffer,id,(uint8_t)r,(uint8_t)g,(uint8_t)b);
    
    return 0;
}

static int BufferBindSetColors(lua_State *L){
     Buffer *buffer = BufferCheck(L, 1);
     if(!lua_istable (L,2)){
         lua_pushstring(L, "[2] should be table");
         lua_error(L);
         return 0;
     }
     lua_pushnil(L);

     while(lua_next(L,-2)){
        //convert map id to buffer id
        int id = lua_tonumber(L,-2);

        int color = lua_tonumber(L,-1);
        int r,g,b;
        RGBIntToRGB(color, r,g,b);

        //assert(id<buffer->width*buffer->height);
        BufferSetColorYTop(buffer,id,(uint8_t)r,(uint8_t)g,(uint8_t)b);
        lua_pop(L,1);
     }
     lua_pop(L, 1); // THE FIX, pops the nil on the stack used to process the table
     return 0;
}

static int BufferBindToString(lua_State *L){
    Buffer *b = BufferCheck(L, 1);
    std::string str = "Buffer[buffer:" + std::to_string(b->buffer) +" w:" + std::to_string(b->width) + " h:" +  std::to_string(b->height) + " ]";
    lua_pushstring(L,str.c_str());
	return 1;
}

void BufferBind(lua_State* L){
     luaL_Reg functions[] = {
            {"clear",BufferBindClear},
            {"set_color",BufferBindSetColor},
            {"set_colors",BufferBindSetColors},
            {"__tostring",BufferBindToString},
            { 0, 0 }
    };
    luaL_newmetatable(L, META_NAME);
    luaL_register (L, NULL,functions);
    lua_pushvalue(L, -1);
    lua_setfield(L, -1, "__index");
    lua_pop(L, 1);
}
