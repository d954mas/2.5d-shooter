#pragma once
#include <dmsdk/sdk.h>
#include "colors.h"

void LightMapSetColors(dmBuffer::HBuffer& buffer,int size, int w,int h, int colors[]){
    uint32_t size_ignored = 0;
    uint32_t components = 0;
    uint32_t stride = 0;
    uint8_t* stream;
    dmBuffer::Result result = dmBuffer::GetBytes(buffer, (void**)&stream, &size_ignored);
    int r=0, g=0, b = 0;
    for(int y = 0; y<h; y++){
        int index = (size-y-1)*size*3;
        int color_idx = y * w;
         for(int x = 0; x<w; x++){
             int color = colors[color_idx + x];
             if(color != 0xF0000000){
                 RGBIntToRGB(color,r,g,b);
                 stream[index] = r;
                 stream[index+1] = g;
                 stream[index+2] = b;
             }
             index+=3;
         }
    }
}
