extends Node2D

onready var p1_pos = $Patrol1.global_position
onready var p2_pos = $Patrol2.global_position
onready var current_patrol = p1_pos

export(String) var color = "red"

var dead = false

var RED = preload("res://RedEnemy.tres")
var BLUE = preload("res://BlueEnemy.tres")

func _ready():
	if color == "red":
		$Sprite.frames = RED
	elif color == "blue":
		$Sprite.frames = BLUE

func _on_Hitbox_body_entered(body):
	if dead:
		return
	if body.is_in_group("Player"):
		body.kill_player()

func _on_Jumpbox_body_entered(body):
	if dead:
		return
	if body.is_in_group("Player"):
		body.enemy_jump()
		kill_enemy()
		dead = true
		
func _physics_process(delta):
	global_position = lerp(global_position, current_patrol, 0.05)
	if global_position.distance_to(current_patrol) < 10:
		_switch_patrol()
		
func _switch_patrol():
	if current_patrol == p1_pos:
		current_patrol = p2_pos
	elif current_patrol == p2_pos:
		current_patrol = p1_pos
		
func kill_enemy():
	visible = false
	$Hitbox/CollisionShape2D.disabled = true
	$Jumpbox/CollisionShape2D.disabled = true
	
func respawn_enemy():
	visible = true
	dead = false
	$Hitbox/CollisionShape2D.disabled = false
	$Jumpbox/CollisionShape2D.disabled = false
	
func enable(enable):
	if dead:
		return
	if enable:
		$Sprite.animation = "enabled"
		$Hitbox/CollisionShape2D.disabled = false
		$Jumpbox/CollisionShape2D.disabled = false
	else:
		$Sprite.animation = "disabled"
		$Hitbox/CollisionShape2D.disabled = true
		$Jumpbox/CollisionShape2D.disabled = true