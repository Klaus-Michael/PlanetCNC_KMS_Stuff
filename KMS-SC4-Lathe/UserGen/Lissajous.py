#! /usr/bin/env python 
#name=Lissajous curve
#desc=Generates Lissajous curve

import sys
import time
import math
import planetcnc
import gcode

#sys.path.append(planetcnc.getPathProfile("Python"))

def calc(angle, A, A2, A3, B, B2, B3):
	xx = A * math.sin(math.radians(A2 * angle + A3))
	yy = B * math.cos(math.radians(B2 * angle + B3))
	return xx, yy
	
def Lissajous(x, y, z, A, B, A2, B2, A3, B3, scale, res):
	if not gcode.lineAddAllowed():
		planetcnc.msg("Adding g-code lines is not allowed!")
		return 1

	gcode.lineAdd("%")
	gcode.lineAdd("G00 X", x, " Y", y+scale, " Z", z)
	angle = 0
	while angle < 360:
		xx, yy = calc(angle, A, A2, A3, B, B2, B3)
		gcode.lineAdd("G01 X", x+(scale*xx), " Y", y+(scale*yy))
		angle += res
	gcode.lineAdd("%")

	
if __name__ == '__main__':
	Lissajous(0, 0, 0, 1, 1, 1, 3, 0, 0, 100, 1)
	#Lissajous(0, 0, 0, 1, 1, 2, 5, 0, 0, 100, 1)
	#Lissajous(0, 0, 0, 1, 1, 5, 3, 0, 0, 100, 1)