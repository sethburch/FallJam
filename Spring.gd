extends Area2D

export(String) var color = "red"

var RED = preload("res://RedSpring.tres")
var BLUE = preload("res://BlueSpring.tres")

func _ready():
	if color == "red":
		$Sprite.frames = RED
	elif color == "blue":
		$Sprite.frames = BLUE

func _on_Spring_body_entered(body):
	if body.is_in_group("Player"):
		body.spring_jump(rotation_degrees)
		$Sprite.playing = true

func enable(enable):
	if enable:
		$Sprite.animation = "enabled"
		$CollisionShape2D.disabled = false
		$CollisionShape2D.disabled = false
		if $Sprite.frame >= 3:
			$Sprite.frame = 0
			$Sprite.playing = false
	else:
		$Sprite.animation = "disabled"
		$CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true