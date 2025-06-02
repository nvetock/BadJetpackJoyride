extends RigidBody2D

const jetpack_boost: float = 30.0
var is_jetpack_active: bool = false

var char_ani_prefix: String = "astro_"
var char_ani: String = "run"
var has_jumped: bool = false

var is_on_floor := false
var desired_jump := false

var last_running_speed := 1.0

@onready var ground_ray: RayCast2D = $GroundRayCast

## Player receives input of 'jetpack'. While pressed jetpack boosts upwards
## On release, player falls at gravity rate running on ground.

## Player animations are running, jumping, falling ... idle for constant jetpack mode?

func ready() -> void:
	$AnimatedSprite2D.animation_finished.connect(_on_jump_finished)


func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	is_on_floor = is_grounded()
	
	if Input.is_action_pressed("jetpack"):
		linear_velocity += Vector2.UP * jetpack_boost
		if not desired_jump:
			desired_jump = true
	else:
		linear_velocity += Vector2.ZERO
	
	if is_on_floor:
		if not desired_jump:
			update_animation(get_current_anim_prefix(), "run")
			
		else:
			if not has_jumped:
				update_animation(get_current_anim_prefix(), "jump")
				has_jumped = true
			else:
				update_animation(get_current_anim_prefix(), "idle")
	
	if has_jumped and is_on_floor:
		desired_jump = false

# ----------------------------------------------- #
# ------------------ LOGIC ---------------------- #

## Returns if player is currently on the ground or not
func is_grounded() -> bool:
	return ground_ray.is_colliding()

func speed_up() -> void:
	if $AnimatedSprite2D.get_playing_speed() < 3.0:
				$AnimatedSprite2D.speed_scale += .1
				print($AnimatedSprite2D.get_playing_speed())
	
	# Place this after
	# last_running_speed = $AnimatedSprite2D.get_playing_speed()
	# 		$AnimatedSprite2D.speed_scale = 1.0


# ------------------------------------------------- #
# ------------------ RUNNING ---------------------- #

func run_speed() -> void:
	pass

# --------------------------------------------------- #
# ------------------ ANIMATION ---------------------- #

## Returns the animation prefix string before the "_"
func get_current_anim_prefix() -> String:
	var temp = $AnimatedSprite2D.animation
	return temp.split("_")[0]

## Updates the current animation. Concats a "_" between the two arguments prefix_anim
func update_animation(prefix: String, anim: String):
	$AnimatedSprite2D.play(prefix + "_" + anim, last_running_speed)

## After jump animation is complete switches to a looping idle state
func _on_jump_finished() -> void:
	var temp = get_current_anim_prefix()
	update_animation(temp, "idle")

# ------------------------------------------------------ #
# ------------------ SIGNAL LOGIC ---------------------- #

func _on_collision_speed_reset() -> void:
	$AnimatedSprite2D.speed_scale = 1.0
	last_running_speed = 1.0

'''
func _ready() -> void:
	$AnimatedSprite2D.animation_finished.connect(_on_jump_complete)
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("jetpack"):
		if not has_jumped:
			jump_animation()
			has_jumped = true
		is_jetpack_active = true
	else:
		is_jetpack_active = false
	
	
	$AnimatedSprite2D.play()
	
	

func _physics_process(delta: float) -> void:
	linear_velocity += activate_jetpack()
	
	if is_on_floor():
		update_animation("run")
		has_jumped = false
	elif not is_on_floor() and not is_jetpack_active:
		update_animation("fall")
	

func activate_jetpack() -> Vector2:
	if is_jetpack_active:
		return Vector2.UP * jetpack_boost
	
	return Vector2.ZERO

func is_on_floor() -> bool:
	return ground_ray.is_colliding()

# --------------------------------------------------- #
# ------------------ ANIMATION ---------------------- #

## Animation takes a statement that locks a variable that is always being played
## is_astro param is a bool on if this should change the prefix. Prefix will default to alien,
## but can be manually set back to astro if armor is regained
func update_animation(new_ani: String, change_prefix: bool = false, new_prefix: String = "alien_") -> void:
	if change_prefix:
		char_ani_prefix = new_prefix
	
	char_ani = new_ani

func get_current_anim_prefix() -> String:
	#if $AnimatedSprite2D.ends_with("_jump"):
	return $AnimatedSprite2D.animation.split("_")[0]

func jump_animation() -> void:
	var prefix = get_current_anim_prefix()
	$AnimatedSprite2D.play(prefix + "_jump")

# ---------------------------------------------------------- #
# ------------------ SIGNAL FUNCTIONS ---------------------- #

func _on_jump_complete() -> void:
	if $AnimatedSprite2D.animation.ends_with("_jump"):
		update_animation("idle")

'''
