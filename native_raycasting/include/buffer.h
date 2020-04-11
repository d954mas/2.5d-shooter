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


//void BufferBind(lua_State*);
Buffer* BufferCheck(lua_State*, int);
void BufferPush(lua_State *, Buffer *);
