extends Area2D

@export var boost_amount: float = 25

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var popup_label = $PopupLabel
@onready var pickup_sound = $PickupSound

var fading := false
var popup_velocity := Vector2(0, -20)
var elapsed_time := 0.0
var popup_lifetime := 1.2
var start_position := Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	popup_label.visible = false
	popup_label.text = "+Speed"

func _on_body_entered(body):
	if not body.has_method("apply_speed_boost"):
		return

	print("Fruit collected by: ", body.name)  # Debug

	# Apply speed boost
	body.apply_speed_boost(boost_amount)

	# Disable collision
	collision.disabled = true

	# Hide fruit sprite
	sprite.visible = false

	# Play sound
	if pickup_sound:
		pickup_sound.play()

	# Show popup
	start_position = popup_label.position
	popup_label.visible = true
	popup_label.modulate.a = 1.0
	fading = true
	elapsed_time = 0.0

func _process(delta):
	if fading:
		elapsed_time += delta
		var t = elapsed_time / popup_lifetime
		popup_label.position.y = start_position.y - popup_velocity.y * t
		popup_label.modulate.a = 1.0 - t
		if elapsed_time >= popup_lifetime:
			queue_free()
