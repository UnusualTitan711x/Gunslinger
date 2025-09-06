extends Node
class_name GameManager

@export var spawn_interval := 2.0

@onready var left_spawner: Marker2D = %LeftSpawner
@onready var right_spawner: Marker2D = %"Right Spawner"

const ENEMY = preload("res://scenes/enemy.tscn")

var spawn_timer

func _ready() -> void:
	spawn_timer = spawn_interval
	pass # Replace with function body.


func _process(delta: float) -> void:
	spawn_timer -= delta
	
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = spawn_interval
		
	

func spawn_enemy():
	var instance = ENEMY.instantiate()
	instance.global_position = left_spawner.global_position
	get_tree().current_scene.add_child(instance)
	await get_tree().create_timer(3).timeout
	var instance2 = ENEMY.instantiate()
	instance2.global_position = right_spawner.global_position
	get_tree().current_scene.add_child(instance2)
