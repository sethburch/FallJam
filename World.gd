extends Node

enum TILES {BLUE, RED}

export(float) var switch_time = 120.0
var current_color = TILES.BLUE
var switch_timer : float = 0.0

var red_enabled = true
var blue_enabled = false

var red_player = preload("res://RedPlayer.tres")
var blue_player = preload("res://BluePlayer.tres")

var open_game = preload("res://sound/get_key.wav")
var start_game = preload("res://sound/pickup_key.wav")

var previous_delta : float = -1.0

var start_timer = true

var time_begin
var time_delay

var game_start = false

func _ready():
	$CanvasLayer/GUI/TextureRect2/AnimationPlayer.play("float_up")

func _process(delta):
	if !game_start and Input.is_action_just_pressed("jump"):
		game_start = true
		$GameTimer.start()
		game_start()
#	if Input.is_action_just_pressed("reload"):
#		get_tree().reload_current_scene()

func _switch():
	$Camera.shake(0.1, 5, 4)
	red_enabled = !red_enabled
	blue_enabled = !blue_enabled
	if red_enabled:
		$CurrentLevel.enable_red(true)
		$Player/Sprite.frames = red_player
	if !red_enabled:
		$CurrentLevel.enable_red(false)
	if blue_enabled:
		$CurrentLevel.enable_blue(true)
		$Player/Sprite.frames = blue_player
	if !blue_enabled:
		$CurrentLevel.enable_blue(false)

func update_level():
	if red_enabled:
		$CurrentLevel.enable_red(true)
	if !red_enabled:
		$CurrentLevel.enable_red(false)
	if blue_enabled:
		$CurrentLevel.enable_blue(true)
	if !blue_enabled:
		$CurrentLevel.enable_blue(false)

func set_key_count(count):
	$CanvasLayer/GUI/Label.text = str(count) + "/7"

func game_start():
	$Sound.stream = start_game
	$Sound.play()
	$CanvasLayer/GUI/TextureRect2/AnimationPlayer.play("float_away")

func _on_GameTimer_timeout():
	if !$Music.is_playing():
		$Music.play()
	_switch()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "float_up":
		$CanvasLayer/GUI/TextureRect2/AnimationPlayer.play("idle")


func _on_FinalArea_final_time(time):
	$CanvasLayer/GUI/End/Header.text = time
	$CanvasLayer/GUI/End/AnimationPlayer.play("fade")
