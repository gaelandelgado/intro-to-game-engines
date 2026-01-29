extends Node2D

const SPEED: float = 60.0
var is_dead: bool = false
var direction: int = 1

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	$StompDetector.body_entered.connect(_on_stomped)

func _on_stomped(body):
	if is_dead:
		return
	
	# Check if it's the player jumping DOWN onto the slime
	if body.name == "Player" and body.velocity.y > 0:
		print("Slime stomped!")  # Debug
		
		# Mark slime as dead
		is_dead = true
		
		# Bounce the player
		body.velocity.y = -280
		
		# Stop the slime from moving
		set_process(false)
		
		# Visual feedback
		animated_sprite.modulate.a = 0.5
		
		# Disable the killzone so it doesn't kill the player
		$Killzone.monitoring = false
		
		# Remove slime after delay
		await get_tree().create_timer(0.3).timeout
		queue_free()

func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
	position.x += direction * SPEED * delta
