#pragma once

// Copyright (c) 2014, Jan Winkler <winkler@cs.uni-bremen.de>
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Universität Bremen nor the names of its
//       contributors may be used to endorse or promote products derived from
//       this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	// POSSIBILITY OF SUCH DAMAGE.

	/* Author: Jan Winkler */


	#include <cmath>

	using namespace std;


	/*! \brief Convert RGB to HSV color space

	Converts a given set of RGB values `r', `g', `b' into HSV
	coordinates. The input RGB values are in the range [0, 1], and the
	output HSV values are in the ranges h = [0, 360], and s, v = [0,
	1], respectively.

	\param fR Red component, used as input, range: [0, 1]
	\param fG Green component, used as input, range: [0, 1]
	\param fB Blue component, used as input, range: [0, 1]
	\param fH Hue component, used as output, range: [0, 360]
	\param fS Hue component, used as output, range: [0, 1]
	\param fV Hue component, used as output, range: [0, 1]

	*/
	void RGBtoHSV(float fR, float fG, float fB, float& fH, float& fS, float& fV) {
		float fCMax = max(max(fR, fG), fB);
		float fCMin = min(min(fR, fG), fB);
		float fDelta = fCMax - fCMin;

		if(fDelta > 0) {
			if(fCMax == fR) {
				fH = 60 * (fmod(((fG - fB) / fDelta), 6));
			} else if(fCMax == fG) {
				fH = 60 * (((fB - fR) / fDelta) + 2);
			} else if(fCMax == fB) {
				fH = 60 * (((fR - fG) / fDelta) + 4);
			}

			if(fCMax > 0) {
				fS = fDelta / fCMax;
			} else {
				fS = 0;
			}

			fV = fCMax;
		} else {
			fH = 0;
			fS = 0;
			fV = fCMax;
		}

		if(fH < 0) {
			fH = 360 + fH;
		}
	}


	/*! \brief Convert HSV to RGB color space

	Converts a given set of HSV values `h', `s', `v' into RGB
	coordinates. The output RGB values are in the range [0, 1], and
	the input HSV values are in the ranges h = [0, 360], and s, v =
	[0, 1], respectively.

	\param fR Red component, used as output, range: [0, 1]
	\param fG Green component, used as output, range: [0, 1]
	\param fB Blue component, used as output, range: [0, 1]
	\param fH Hue component, used as input, range: [0, 360]
	\param fS Hue component, used as input, range: [0, 1]
	\param fV Hue component, used as input, range: [0, 1]

	*/
	void HSVtoRGB(float& fR, float& fG, float& fB, float fH, float fS, float fV) {
		float fC = fV * fS; // Chroma
		float fHPrime = fmod(fH / 60.0, 6);
		float fX = fC * (1 - fabs(fmod(fHPrime, 2) - 1));
		float fM = fV - fC;

		if(0 <= fHPrime && fHPrime < 1) {
			fR = fC;
			fG = fX;
			fB = 0;
		} else if(1 <= fHPrime && fHPrime < 2) {
			fR = fX;
			fG = fC;
			fB = 0;
		} else if(2 <= fHPrime && fHPrime < 3) {
			fR = 0;
			fG = fC;
			fB = fX;
		} else if(3 <= fHPrime && fHPrime < 4) {
			fR = 0;
			fG = fX;
			fB = fC;
		} else if(4 <= fHPrime && fHPrime < 5) {
			fR = fX;
			fG = 0;
			fB = fC;
		} else if(5 <= fHPrime && fHPrime < 6) {
			fR = fC;
			fG = 0;
			fB = fX;
		} else {
			fR = 0;
			fG = 0;
			fB = 0;
		}

		fR += fM;
		fG += fM;
		fB += fM;
	}

	void RGBIntToHSV(int rgb, float& fH, float& fS, float& fV){
		float r = ((rgb & 0x00FF0000) >> 16)/(float)0xff;
		float g = ((rgb & 0x0000FF00) >> 8)/(float)0xff;
		float b = ((rgb & 0x000000ff) >> 0)/(float)0xff;
		RGBtoHSV(r,g,b,fH,fS,fV);
	}

	int HSVToRGBInt(float fH, float fS, float fV){
		float r = 0, g = 0, b = 0;
		HSVtoRGB(r,g,b,fH,fS,fV);
		return ((int)(0xff*r) << 16) | ((int)(0xff*g) << 8) |((int)(0xff*b) << 0);
	}