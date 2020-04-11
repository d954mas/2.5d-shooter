#pragma once



void RGBtoHSV(float fR, float fG, float fB, float& fH, float& fS, float& fV);
void HSVtoRGB(float& fR, float& fG, float& fB, float fH, float fS, float fV);
void RGBIntToRGB(int rgb,int& r, int& g, int& b);
int RGBToRGBInt(int r,int g, int b);
void RGBIntToHSV(int rgb, float& fH, float& fS, float& fV);
int HSVToRGBInt(float fH, float fS, float fV);
int RGBBlendAdditive(int rgb1, int rgb2);

