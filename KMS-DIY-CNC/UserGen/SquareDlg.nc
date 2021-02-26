%
(name,Square)

(dlgname,Square)
(dlg,Size, dec=1, def=30, min=1, max=100, param=sqsize)
(dlgshow)

G00 X-#<sqsize> Y-#<sqsize>
G01 X-#<sqsize> Y+#<sqsize>
G01 X+#<sqsize> Y+#<sqsize>
G01 X+#<sqsize> Y-#<sqsize>
G01 X-#<sqsize> Y-#<sqsize>

M02
%