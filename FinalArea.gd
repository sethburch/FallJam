extends Area2D

var t_str = ""

signal final_time(time);

func _on_FinalArea_body_entered(body):
	var f_time = get_parent().final_time
	var f_time_sec = f_time/60
	
	
	
	var m = round(f_time_sec / 60)
	var s = f_time_sec % 60
	if s < 10:
		t_str = str(m) + ":0" + str(s)
	else:
		t_str = str(m) + ":" + str(s)
	emit_signal("final_time", t_str)