%
(name,Thread)

;Coarse:
;M3  - Pitch: 0.5
;M4  - Pitch: 0.7
;M5  - Pitch: 0.8
;M6  - Pitch: 1
;M8  - Pitch: 1.25
;M10 - Pitch: 1.5
;M12 - Pitch: 1.75
;M16 - Pitch: 2
;M20 - Pitch: 2.5
;M24 - Pitch: 3
;M30 - Pitch: 3.5
;M36 - Pitch: 4
;M42 - Pitch: 4.5
;M48 - Pitch: 5
;M56 - Pitch: 5.5
;M64 - Pitch: 6
;Fine:
;M3  - Pitch: 0.35
;M4  - Pitch: 0.5
;M5  - Pitch: 0.5
;M6  - Pitch: 0.75
;M8  - Pitch: 0.75
;M8  - Pitch: 1
;M10 - Pitch: 1
;M10 - Pitch: 1.25
;M12 - Pitch: 1.25
;M12 - Pitch: 1.5
;M16 - Pitch: 1.5
;M20 - Pitch: 1.5
;M20 - Pitch: 2
;M24 - Pitch: 2
;M30 - Pitch: 2
;M36 - Pitch: 3
;M42 - Pitch: 3
;M48 - Pitch: 3
;M56 - Pitch: 4
;M64 - Pitch: 4

(dlgname,Thread)
(dlg,Length, dec=3, def=-20, min=-1000, max=1000, param=length)
(dlg,Pitch, dec=2, def=2.5, min=0.25, max=6, param=pitch)
(dlg,Peak, dec=3, def=-2, min=-1000, max=1000, param=peak)
(dlg,Cut, dec=3, def=0.1, min=0, max=1000, param=cut)
(dlgshow)

#<depth>       = [0.614 * #<pitch>]
#<degression>  = 1
#<compoundang> = 29.5
#<finish>      = 1 ;Number of finishing passes
#<taper>       = 3 ;0=None, 1=Entry, 2=Exit, 3=Entry+Exit
#<taperang>    = 45
#<taperdist>   = [TAN[#<taperang>] * #<depth>]

(print,Length            : #<length>)
(print,Pitch          'P': #<pitch>)
(print,Peak           'I': #<peak>)
(print,Cut            'J': #<cut>)
(print,Depth          'K': #<depth>)

(print,Degression     'R': #<degression>)
(print,Compound Angle 'Q': #<compoundang>)
(print,Finish         'H': #<finish>)
(print,Taper          'L': #<taper>)
(print,TaperAngle     'A': #<taperang>)
(print,TaperDistance  'E': #<taperdist>)

M73
G21
M03
G76 Z[#<_z>+#<length>] X[#<_x>-#<peak>] P#<pitch> I#<peak> J#<cut> K#<depth> R#<degression> Q#<compoundang> H#<finish> A#<taperang> L#<taper>
M05
M02

%
