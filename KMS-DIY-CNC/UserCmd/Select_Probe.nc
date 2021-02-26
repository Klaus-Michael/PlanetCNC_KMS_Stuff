#<_Probe_error_pin>=1

O<Probe_check> if [[#<_hw_input_num|#<_Probe_error_pin>>]]
 (msg,Probe not turned on or in sleep!!!)
 M2
O<Probe_check> else
	T255 M6
O<Probe_check> endif