#include "buffer.h"

#define META_NAME "Raycasting::BufferClass"

#include <string>

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

static int BufferClear(lua_State *L){
    Buffer *b = BufferCheck(L, 1);
    return 0;
}

static int BufferSetColor(lua_State *L){
     Buffer *b = BufferCheck(L, 1);
     return 0;
}

static int BufferSetColors(lua_State *L){
     Buffer *b = BufferCheck(L, 1);
     return 0;
}

static int BufferToString(lua_State *L){
    Buffer *b = BufferCheck(L, 1);
    std::string str = "Buffer[buffer:" + std::to_string(b->buffer) +" w:" + std::to_string(b->width) + " h:" +  std::to_string(b->height) + " ]";
    lua_pushstring(L,str.c_str());
	return 1;
}

void BufferBind(lua_State* L){
     luaL_Reg functions[] = {
            {"clear",BufferClear},
            {"set_color",BufferSetColor},
            {"set_colors",BufferSetColors},
            {"__tostring",BufferToString},
            { 0, 0 }
    };
    luaL_newmetatable(L, META_NAME);
    luaL_register (L, NULL,functions);
    lua_pushvalue(L, -1);
    lua_setfield(L, -1, "__index");
    lua_pop(L, 1);
}
