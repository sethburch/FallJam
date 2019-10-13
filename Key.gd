extends Area2D

var follow_player = false
var player = null
var inital_position
var stop_following = false

func _ready():
	$AnimationPlayer.play("float")
	inital_position = global_position

func _process(delta):
	if follow_player:
		global_position = lerp(global_position, player.get_key_pos(), 0.02)
	if stop_following:
		global_position = lerp(global_position, inital_position, 0.02)
		if ((abs(global_position.x) - inital_position.x) < 5) and ((abs(global_position.y) - inital_position.y) < 5):
			stop_following = false

func _on_Key_body_entered(body):
	if follow_player:
		return
	if body.is_in_group("Player"):
		player = body
		body.got_key(self)
		follow_player = true
#		queue_free()

func collected():
	$AnimationPlayer.play("got")

func stop_following():
	stop_following = true
	follow_player = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "got":
		queue_free()
