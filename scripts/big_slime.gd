extends Node2D

const SPEED: float = 60.0
var lives: int = 3
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
	
	if body.name == "Player" and body.velocity.y > 0:
		# Disable killzone immediately so it doesn't kill player
		$Killzone.monitoring = false
		
		# Bounce player
		body.velocity.y = -400
		
		# Take damage
		lives -= 1
		print("Lives: ", lives)
		
		# Flash white
		animated_sprite.modulate = Color(2, 2, 2, 1)
		await get_tree().create_timer(0.1).timeout
		animated_sprite.modulate = Color(1, 1, 1, 1)
		
		# Re-enable killzone if still alive
		if lives > 0:
			$Killzone.monitoring = true
		
		# Die if no lives left
		if lives <= 0:
			is_dead = true
			set_process(false)
			animated_sprite.modulate.a = 0.5
			
			# Spawn a jumpfruit at this position
			var jumpfruit = preload("res://scenes/jumpfroot.tscn").instantiate()
			jumpfruit.position = position
			get_parent().add_child(jumpfruit)
			
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
