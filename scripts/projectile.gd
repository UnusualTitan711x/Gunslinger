extends Area2D

@export var speed = 1000
var dir 
var bullet_range = 5000
var distance_covered

func _ready() -> void:
	distance_covered = 0
	pass # Replace with function body.

func _process(delta: float) -> void:
	# Travel
	position += Vector2(speed * delta, 0).rotated(dir)
	
	distance_covered += speed * delta
	
	if distance_covered >= bullet_range:
		queue_free()
	pass


func _on_body_entered(_body: Node2D) -> void:
	queue_free()
