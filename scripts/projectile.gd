extends Area2D

var speed = 450
var dir 

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	position += Vector2(0, -speed * delta).rotated(dir)
	pass


func _on_body_entered(body: Node2D) -> void:
	queue_free()
