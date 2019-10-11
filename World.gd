extends Node

enum TILES {BLUE, RED}

export(int) var switch_time = 5
var current_color = TILES.BLUE

var red_enabled = true
var blue_enabled = false

func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		red_enabled = !red_enabled
		blue_enabled = !blue_enabled
		if red_enabled:
			$CurrentLevel.enable_red(true)
		if !red_enabled:
			$CurrentLevel.enable_red(false)
		if blue_enabled:
			$CurrentLevel.enable_blue(true)
		if !blue_enabled:
			$CurrentLevel.enable_blue(false)
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
			
func _switch():
	red_enabled = !red_enabled
	blue_enabled = !blue_enabled
	if red_enabled:
		$CurrentLevel.enable_red(true)
	if !red_enabled:
		$CurrentLevel.enable_red(false)
	if blue_enabled:
		$CurrentLevel.enable_blue(true)
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

func _on_GameTimer_timeout():
	_switch()
