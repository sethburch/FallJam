extends Area2D

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			get_parent().get_parent().get_node("Camera").offset = lerp(get_parent().get_parent().get_node("Camera").offset, $CameraPos.global_position, .2)
			get_parent().get_parent().get_node("CurrentLevel").update_level(self)