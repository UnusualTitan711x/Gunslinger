extends Area2D

var speed = 450
var dir 
var range = 5000
var distance_covered

func _ready() -> void:
	distance_covered = 0
	pass # Replace with function body.

func _process(delta: float) -> void:
	# Travel
	position += Vector2(0, -speed * delta).rotated(dir)
	
	distance_covered += speed * delta
	
	if distance_covered >= range:
		queue_free()
	pass


func _on_body_entered(_body: Node2D) -> void:
	queue_free()
