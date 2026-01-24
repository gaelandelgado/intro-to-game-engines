extends CharacterBody2D

@export var speed: float = 100.0
var current_speed: float = speed

var JUMP_VELOCITY = -200

@onready var animated_sprite = $AnimatedSprite2D

func apply_jump_boost(boost_amount: float):
	JUMP_VELOCITY -= boost_amount  # negative because up is negative in Godot

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpSound.play()

	# Horizontal input
	var direction = Input.get_axis("move_left", "move_right")

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walking")
	else:
		animated_sprite.play("jump")

	# Movement
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	move_and_slide()


# Permanent speed boost
func apply_speed_boost(boost_amount: float):
	current_speed += boost_amount
