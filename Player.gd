extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = Vector2(0, 800)
const MAX_FALL_SPEED = Vector2(0, 200)
const JUMP_SPEED = 300
const JUMP_HEIGHT = 10
const ACCELERATION = 50
const AIR_ACCELERATION = 40
const MAX_SPEED = 150
const MAX_DASH_SPEED = 1500
const AIR_FRICTION = 0.8
const GROUND_FRICTION = .3
const JUMP_FALLOFF_SPEED = .5
const JUMP_BUFFER_MAX = 6

var motion = Vector2()
var friction = false

var current_checkpoint = null
var just_died = false

var anim = ""
var new_anim = ""
var facing_right = true
var wall_jumped = false

var key_count = 0
var keys_carrying = 0
var key_carrying = null
var key_gather_buffer = 0

var coyote_jump_buffer = 0
var jump_buffer = 0
var sticky_wall_buffer = 0
var collision_right = false
var collision_left = false
var on_wall

var has_jumped = false

var haxis = 1
var vaxis = 0
var player_dir = haxis

var snd_jump = preload("res://sound/jump.wav")
var snd_land = preload("res://sound/land.wav")
var snd_pickup_key = preload("res://sound/pickup_key.wav")
var snd_jump_spring = preload("res://sound/jump_spring.wav")
var snd_death = preload("res://sound/death_sound.wav")
var snd_got_key = preload("res://sound/get_key.wav")

var DUST = preload("res://DustParticle.tscn")

func _ready():
	add_to_group("Player")
	set_physics_process(false)

func _physics_process(delta):

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("Hazards"):
			kill_player()
		if keys_carrying > 0:
			if collision.collider.is_in_group("Wall") and is_on_floor():
				key_gather_buffer+=1
				if key_gather_buffer >= 3:
					key_carrying.collected()
					key_carrying = null
					key_count+=keys_carrying
					key_gather_buffer = 0
					keys_carrying = 0
					play_sound(snd_pickup_key, false)
					get_parent().set_key_count(key_count)
			else:
				key_gather_buffer = 0
		
	haxis = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	vaxis = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if haxis != 0:
		player_dir = haxis

	sticky_wall_buffer-=1
	if !on_wall or is_on_floor():
		sticky_wall_buffer=0
	elif (Input.is_action_just_pressed("move_right") and collision_left) or (Input.is_action_just_pressed("move_left") and collision_right):
		sticky_wall_buffer = JUMP_BUFFER_MAX

	#add gravity if we havent reached max fall speed yet
	if on_wall:
		if motion.y < MAX_FALL_SPEED.y/10:
			motion += delta * GRAVITY
		else:
			motion.y = MAX_FALL_SPEED.y/10
	else:
		if motion.y < MAX_FALL_SPEED.y:
			motion += delta * GRAVITY

	#move
	motion = move_and_slide(motion, UP)
	
	if Input.is_action_just_pressed("move_left") || Input.is_action_just_pressed("move_right"):
		just_died = false
	
	#play idle if we're not landing
	if anim != "land":
		new_anim = "idle"
	
	#play landing animation when hitting ground
	if is_on_floor() and anim == "fall":
		dust_floor_particles($FeetPos.global_position)
		play_sound(snd_land, true)
		new_anim = "land"

	#jumping with buffer
	if is_on_floor() || wall_jumped:
		coyote_jump_buffer = 0
		if !has_jumped and jump_buffer < JUMP_BUFFER_MAX:
			dust_floor_particles($FeetPos.global_position)
			play_sound(snd_jump, true)
			jump_buffer = JUMP_BUFFER_MAX
			has_jumped = true
			motion.y = -JUMP_SPEED
			new_anim = "jump"
			wall_jumped = false
	jump_buffer+=1
		
	#jumping with coyote time
	if Input.is_action_just_pressed("jump"):
		jump_buffer = 0
		if !has_jumped and coyote_jump_buffer < JUMP_BUFFER_MAX:
			dust_floor_particles($FeetPos.global_position)
			play_sound(snd_jump, true)
			coyote_jump_buffer = JUMP_BUFFER_MAX
			has_jumped = true
			motion.y = -JUMP_SPEED
			new_anim = "jump"
			wall_jumped = false
	coyote_jump_buffer+=1

	#if we release the jump key while rising then cut off the jump
	if Input.is_action_just_released("jump"):
		has_jumped = false
		#if we're falling
		if motion.y < 0:
			motion.y = lerp(motion.y, 0, JUMP_FALLOFF_SPEED)
			new_anim = "midair"

	#play jump animations
	if !is_on_floor():
		if motion.y > -100 and motion.y < 100:
			new_anim = "midair"
		elif motion.y < 0 and motion.y > -JUMP_SPEED+100:
			new_anim = "jump"
		elif motion.y > 0:
			new_anim = "fall"
				
	#if sticky_wall_buffer <= 0:
	#movement on ground
	if is_on_floor():
		if Input.is_action_pressed("move_right") and !just_died:
			motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
			if motion.x < ACCELERATION+1:
				dust_floor_particles($FeetPos.global_position)
			#else:
			new_anim = "walk"
			if !on_wall:
				facing_right = true
			friction = false
		elif Input.is_action_pressed("move_left") and !just_died:
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
			if motion.x > -ACCELERATION+1:
				dust_floor_particles($FeetPos.global_position)
#				else:
			new_anim = "walk"
			if !on_wall:
				facing_right = false
			friction = false
		else:
			friction = true
	#movement in air
	else:
		if Input.is_action_pressed("move_right") and !just_died:
			motion.x = min(motion.x+AIR_ACCELERATION, MAX_SPEED)
			if !on_wall:
				facing_right = true
			friction = false
		elif Input.is_action_pressed("move_left") and !just_died:
			motion.x = max(motion.x-AIR_ACCELERATION, -MAX_SPEED)
			if !on_wall:
				facing_right = false
			friction = false
		else:
			friction = true

	#deceleration
	if is_on_floor():
		if friction:
			motion.x = lerp(motion.x, 0, GROUND_FRICTION)
	else:
		if friction:
			motion.x = lerp(motion.x, 0, AIR_FRICTION)
			
	#wall jump
	if on_wall:
		if anim != "cling":
			play_sound(snd_land, true)
		$Sprite/WallParticles/DustParticle.emitting = true
		new_anim = "cling"
		if Input.is_action_just_pressed("jump"):
			#dust_floor_particles(Vector2($Sprite/WallParticles.global_position.x, $Sprite/WallParticles.global_position.y+10))
			motion.x = -haxis*MAX_SPEED*1.5
			wall_jumped = true
	else:
		$Sprite/WallParticles/DustParticle.emitting = false
			

func _process(delta):
	if get_parent().game_start:
		set_physics_process(true)

	#play animation
	if anim != new_anim:
		anim = new_anim
		$Sprite.play(anim)
	$Sprite.flip_h = !facing_right
	if facing_right:
		$Sprite/WallParticles.position.x = -5
		$KeyPos.position.x = -20
	else:
		$Sprite/WallParticles.position.x = 5
		$KeyPos.position.x = 20

func kill_player():
	just_died = true
	play_sound(snd_death, false)
	global_position = current_checkpoint.global_position
	get_parent().get_node("CurrentLevel").respawn_enemies()
	motion = Vector2(0,0)
	wall_jumped = false
	if key_carrying != null:
		key_carrying.stop_following()
		key_carrying = null
		keys_carrying = 0
		
	
func enemy_jump():
	play_sound(snd_jump_spring, false)
	motion.y = -JUMP_SPEED
	wall_jumped = true
	
func spring_jump(rot):
	play_sound(snd_jump_spring, false)
	if rot == 90:
		motion.x = JUMP_SPEED
	if rot == 0:
		motion.y = -JUMP_SPEED
	if rot == 180:
		motion.x = -JUMP_SPEED
	if rot == 270:
		motion.y = JUMP_SPEED
	wall_jumped = true

func _on_WallOverlap_body_entered(body):
	if body is TileMap:
		kill_player()

func _on_WallOverlap_area_entered(area):
	if area.is_in_group("Checkpoint"):
		current_checkpoint = area
	
func _on_CollisionRight_body_entered(body):
	if body is TileMap:
		#play_sound(snd_land, true)
		facing_right = false
		collision_right = true
		on_wall = true

func _on_CollisionRight_body_exited(body):
	if body is TileMap:
		facing_right = true
		collision_right = false
		on_wall = false

func _on_CollisionLeft_body_entered(body):
	if body is TileMap:
		#play_sound(snd_land, true)
		facing_right = true
		collision_left = true
		on_wall = true

func _on_CollisionLeft_body_exited(body):
	if body is TileMap:
		facing_right = false
		collision_left = false
		on_wall = false
		
func got_key(key):
	play_sound(snd_got_key, false)
	keys_carrying=1
	key_carrying = key
	#key_count += 1

func _on_Sprite_animation_finished():
	if $Sprite.animation == "land":
		new_anim = "idle"
	
func play_sound(snd, is_pitched):
	if $Sound.playing:
		var asp = $Sound.duplicate(DUPLICATE_USE_INSTANCING)
		$Sound.add_child(asp)
		asp.stream = snd
		if is_pitched:
			asp.pitch_scale = rand_range(0.90, 1.1)
		asp.play()
		yield(asp, "finished")
		asp.queue_free()
	else:
		$Sound.stream = snd
		if is_pitched:
			$Sound.pitch_scale = rand_range(0.90, 1.1)
		$Sound.play()
		
func dust_floor_particles(pos):
	if !is_on_floor():
		return
	var dust_particle = DUST.instance()
	get_node("..").add_child(dust_particle)
	dust_particle.set_position(pos)
	
func get_key_pos():
	return $KeyPos.global_position