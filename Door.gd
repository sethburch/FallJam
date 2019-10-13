extends Node2D

func open():
	$AnimatedSprite.play("open")
	
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "open":
		queue_free()
