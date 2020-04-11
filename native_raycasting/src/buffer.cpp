#include "buffer.h"

#define META_NAME "Raycasting::BufferClass"

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
//Buffer* BufferBind(lua_State*, int);
