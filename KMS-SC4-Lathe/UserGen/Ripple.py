#! /usr/bin/env python 
#name=Ripple
#desc=Generates rippled surface

import sys
import time
import math
import planetcnc
import gcode

#sys.path.append(planetcnc.getPathProfile("Python"))


def calc(x, y):
	z = x * math.exp(-x**2 - y**2)
	return z

def Grid(size, sizeZ):
	if not gcode.lineAddAllowed():
		planetcnc.msg("Adding g-code lines is not allowed!")
		return 1

	start = -size/2
	end = +size/2
	delta = 2.5
	
	offx = size/2
	offy = size/2

	gcode.lineAdd("%")
	planetcnc.points_clear()
	
	gcode.lineAdd("G00 X", start+offx, " Y", start+offy, " Z", 0)

	xx = start
	yy = start
	zz = 0
	
	while True:
		dir = +1
		while True:
			zz = calc(4*xx/size, 4*yy/size) * 2*sizeZ
			gcode.lineAdd("G01 X", xx+offx, " Y", yy+offy, " Z", zz)
			planetcnc.points_add(xx+offx, yy+offy, zz)
			xx += dir * delta
			if (xx > end):
				break
		
		xx = end
		yy += delta
		dir = -1
		
		if (yy > end):
			break
			
		while True:
			zz = calc(4*xx/size, 4*yy/size) * 2*sizeZ
			gcode.lineAdd("G01 X", xx+offx, " Y", yy+offy, " Z", zz)
			planetcnc.points_add(xx+offx, yy+offy, zz)
			xx += dir * delta
			if (xx < start):
				break
					
		xx = start
		yy += delta
		
		if (yy > end):
			break
		
	cnt = planetcnc.points_count()
	gcode.lineAdd("(points:", cnt, ")")
	gcode.lineAdd("%")

	
if __name__ == '__main__':
	Grid(100, 25)

