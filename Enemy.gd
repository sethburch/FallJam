extends Node2D

onready var current_patrol = get_node("Patrol1").position

func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.kill_player()

func _on_Jumpbox_body_entered(body):
	if body.is_in_group("Player"):
		body.enemy_jump()
		queue_free()
		
func _physics_process(delta):
	position = lerp(position, current_patrol, 0.05)
	if position.distance_to(current_patrol) < 10:
		_switch_patrol()
		
func _switch_patrol():
	if current_patrol == get_node("Patrol1").position:
		current_patrol = get_node("Patrol2").position
	elif current_patrol == get_node("Patrol2").position:
		current_patrol = get_node("Patrol1").position