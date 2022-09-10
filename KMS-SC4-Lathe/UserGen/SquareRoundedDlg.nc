%
(name,Rounded Square)

(dlgname,Rounded Square)
(dlg,Size, dec=2, def=30, min=0, max=1000, param=size)
(dlg,Radius, dec=2, def=5, min=0, max=250, param=rad)
(dlg,Speed, dec=1, def=1000, min=1, max=50000, param=speed)
(dlg,Loop, dec=0, def=3, min=1, max=100, param=loop)
(dlgshow)

;Uniform circular motion

;The acceleration due to change in the direction is:
;a = v^2 / r

;Radius that machine can make without lowering speed is:
;r = v^2 / a

;Note that both speed and acceleration must use same units.
;Normally speeds are set in units/minute and need to be converted to units/second.

F#<speed>
G00 X[#<rad>] Y0

o<loop> repeat[#<loop>]
  G01 X[#<size>] Y0
  G03 X[#<size>+#<rad>] Y[#<rad>] J[#<rad>]
  G01 Y[#<size>]
  G03 X[#<size>] Y[#<size>+#<rad>] I-[#<rad>]
  G01 X[#<rad>]
  G03 X0 Y[#<size>] J-[#<rad>]
  G01 Y[#<rad>]
  G03 X[#<rad>] Y0 I[#<rad>]
o<loop> endrepeat

M02
%



		

		

	