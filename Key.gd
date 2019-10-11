extends Area2D

func _on_Key_body_entered(body):
	if body.is_in_group("Player"):
		body.got_key()
