extends Area2D

func _ready():
	$AnimationPlayer.play("float")

func _on_Key_body_entered(body):
	if body.is_in_group("Player"):
		body.got_key()
		queue_free()
