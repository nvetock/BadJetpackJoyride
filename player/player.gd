extends RigidBody2D

const jetpack_boost: float = 50.0
var is_jetpack_active: bool = false

var char_ani_prefix: String = "astro_"
var char_ani: String = "run"

## Player receives input of 'jetpack'. While pressed jetpack boosts upwards
## On release, player falls at gravity rate running on ground.

## Player animations are running, jumping, falling ... idle for constant jetpack mode?

func _process(delta: float) -> void:
	if Input.is_action_pressed("jetpack"):
		is_jetpack_active = true
	else:
		is_jetpack_active = false
	
	if linear_velocity.y > 0:
		update_animation("jump")
	elif linear_velocity.y < 0:
		update_animation("fall")
	else:
		update_animation("run")
	
	$AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	linear_velocity += activate_jetpack()
	

func activate_jetpack() -> Vector2:
	if is_jetpack_active:
		return Vector2.UP * jetpack_boost
	
	return Vector2.ZERO

# --------------------------------------------------- #
# ------------------ Animation ---------------------- #

## Animation takes a statement that locks a variable that is always being played
## is_astro param is a bool on if this should change the prefix. Prefix will default to alien,
## but can be manually set back to astro if armor is regained
func update_animation(new_ani: String, change_prefix: bool = false, new_prefix: String = "alien_") -> void:
	if change_prefix:
		char_ani_prefix = new_prefix
	
	char_ani = new_ani
