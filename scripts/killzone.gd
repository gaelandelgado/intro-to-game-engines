extends Area2D

@onready var timer = $Timer

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print ("You died!")
	body.die()
	Engine.time_scale = 0.5
	$FallAudio.play()
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
