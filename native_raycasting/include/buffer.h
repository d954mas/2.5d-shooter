#pragma once
#include <dmsdk/sdk.h>
#include <vector>

struct Buffer{
    dmBuffer::HBuffer buffer;
    int width;
    int height;
    int channels;
    uint8_t* bytes;
    uint32_t length;
};


Buffer* BufferCreate(dmBuffer::HBuffer&, int, int, int);
void BufferDestroy(Buffer*);


void BufferBind(lua_State* L);
Buffer* BufferCheck(lua_State*, int);
void BufferPush(lua_State *, Buffer *);
static void inline BufferSetColor(Buffer* buffer, int id, uint8_t r,uint8_t g,uint8_t b){
    id = id *3;
    buffer->bytes[id] = r;
    buffer->bytes[id+1] = g;
    buffer->bytes[id+2] = b;
}

static void inline BufferSetColorYTop(Buffer* buffer, int id, uint8_t r,uint8_t g,uint8_t b){
    int y = id / buffer->width ,x = id % buffer->width;
    id = ((buffer->height-y-1)*buffer->height + x)*3;
    buffer->bytes[id] = r;
    buffer->bytes[id+1] = g;
    buffer->bytes[id+2] = b;
}