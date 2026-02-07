extends Area2D

@onready var pickup_sound = $PickupSound
@onready var collision = $CollisionShape2D
@onready var popup_label = $PopupLabel
@onready var sprite = $AnimatedSprite2D
@onready var game_manager = $"../Game Manager"

var fading := false
var popup_velocity := Vector2(0, -20)
var elapsed_time := 0.0
var popup_lifetime := 1.2
var start_position := Vector2.ZERO
var collected := false  # Prevent multiple pickups

func _ready():
	body_entered.connect(_on_body_entered)
	popup_label.visible = false
	popup_label.text = "+1 Coin"

func _on_body_entered(body):
	
	game_manager.add_point()
	
	if collected:
		return
	collected = true
	
		# Hide fruit sprite
	sprite.visible = false
	
		# Show popup
	start_position = popup_label.position
	popup_label.visible = true
	popup_label.modulate.a = 1.0
	fading = true
	elapsed_time = 0.0
	
	if pickup_sound:
		pickup_sound.play()
		
	collision.disabled = true
	self.monitoring = false
	self.set_deferred("collision_layer", 0)
	self.set_deferred("collision_mask", 0)

func _process(delta):
	if fading:
		elapsed_time += delta
		var t = elapsed_time / popup_lifetime

		# Float popup upward
		popup_label.position.y = start_position.y - popup_velocity.y * t

		# Fade out
		popup_label.modulate.a = 1.0 - t

		# Remove the fruit (and popup) after lifetime
		if elapsed_time >= popup_lifetime:
			queue_free()
