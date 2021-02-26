#! /usr/bin/env python 
#name=Laser Photo Engrave (Python)
#desc=Generates gcode from image

import sys
import time
import math
import planetcnc
import gcode

_imgwidth = 85	# resulting g-code width
_border = 3		# border width for reducing burned edges
_resx = 0.2		# X resolution
_resy = 0.2		# Y resolution
_power = 1000.0	# maximum powr (S value)

#internal
_sf = 0.0
_size = 0,0

#sys.path.append(planetcnc.getPathProfile("Python"))


def Power(z):
	#return "Z" + str(round(_power*z, 2)
	return "S" + str(round(_power*z, 2))

def Color(z):
	c = 255-int(z*255.0)
	return "(color=0x" + ("%0.2X"%c) + ("%0.2X"%c) + ("%0.2X"%c) + ")"

def LineP(img, iy):
	if (_border > 0):
		gcode.lineAdd("G01 X", _border, " (color=0xBB8FCE)")
	xcnt = 0
	xx = 0
	while (xx <= _imgwidth):
		ix = round(xx * _sf)
		if (ix >= _size[0]):
			ix = _size[0]-1
		g = 1.0-planetcnc.imageGetPixelGray(img, ix, iy)
		gcode.lineAdd("G01 X", xx+_border, " ", Power(g), " ", Color(g), ";", ix, "x", iy)
		xcnt += 1
		xx = xx+_resx
		
	if (_border > 0):
		gcode.lineAdd("G01 X", xx+2*_border, " ", Power(0), " (color=0xBB8FCE)")
	
def LineN(img, iy):	
	if (_border > 0):
		gcode.lineAdd("G01 X", _imgwidth+_border, " (color=0xBB8FCE)")
		
	xcnt = 0
	xx = _imgwidth
	while (xx >= 0):
		ix = round(xx * _sf)
		if (ix >= _size[0]):
			ix = _size[0]-1
		g = 1.0-planetcnc.imageGetPixelGray(img, ix, iy)
		gcode.lineAdd("G01 X", xx+_border, " ", Power(g), " ", Color(g), ";", ix, "x", iy)
		xcnt += 1
		xx = xx-_resx	
	
	if (_border > 0):
		gcode.lineAdd("G01 X", 0, " ", Power(0), " (color=0xBB8FCE)")
		
def Generate():
	global _imgwidth
	global _border
	global _resx
	global _resy
	global _power
	global _sf
	global _size

	if not gcode.lineAddAllowed():
		planetcnc.msg("Adding g-code lines is not allowed!")
		return None
		
	fn = planetcnc.dlgFileOpen(".png")
	img = planetcnc.imageOpen(fn)
	if (img == 0):
		print("Can not open image")
		return None
	_size = planetcnc.imageSize(img)
	
	hh = _imgwidth*_size[1]/_size[0]
	_sf = _size[0] / float(_imgwidth)
	
	gcode.lineAdd("%")
	gcode.lineAdd(";  Image Size:", _size[0], "x", _size[1], " Scale: ", _sf)
	gcode.lineAdd(";  GCode Size:", _imgwidth, "x", hh, " Border:", _border)
	gcode.lineAdd(";  Power:", _power)
	
	gcode.lineAdd("G00 X0 Y0")
	gcode.lineAdd("M3 ", Power(0))	

	ycnt = 0
	yy = 0
	while (yy <= hh):
		iy = _size[1]-1 - round(yy * _sf)
		if (iy < 0):
			iy = 0
			
		gcode.lineAdd(";Row ", iy)
		gcode.lineAdd("G00 Y", yy, " (color)" )
		if (ycnt%2 == 0):
			LineP(img, iy)
		else:
			LineN(img, iy)

		ycnt += 1
		yy = yy+_resy

		
	gcode.lineAdd("M5")		
	gcode.lineAdd("%")
	planetcnc.imageClose(img)
	
if __name__ == '__main__':
	Generate()

