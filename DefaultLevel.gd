extends Area2D

var room_transition_start = false

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			get_parent().get_parent().get_node("CurrentLevel").update_level(self)
			get_parent().get_parent().get_node("Camera").change_room($CameraPos.global_position)
			if room_transition_start:
				get_tree().paused = true
				yield(get_tree().create_timer(0.5), 'timeout')
				get_tree().paused = false
				room_transition_start = false
			

func _on_DefaultLevel_body_entered(body):
	get_parent().get_parent().get_node("CurrentLevel").respawn_enemies()
	#get_parent().get_parent().get_node("Player").motion = Vector2(0, 0)
	room_transition_start = true
	