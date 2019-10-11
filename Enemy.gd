extends Node2D

func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.kill_player()

func _on_Jumpbox_body_entered(body):
	if body.is_in_group("Player"):
		body.enemy_jump()
		queue_free()