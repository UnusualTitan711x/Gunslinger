extends CharacterBody2D
class_name Enemy

var player : Player
var speed = 300
var distance_to_player : float
var gravity = 980.0
var bullet = preload("res://scenes/projectile.tscn")
var shot_timer = 0.0

@export var attack_distance = 800.0
@export var personal_distance = 100
@export var shot_interval = 1.0

@onready var right_marker: Marker2D = $RightMarker
@onready var left_marker: Marker2D = $LeftMarker
@onready var up_marker: Marker2D = $UpMarker
@onready var down_marker: Marker2D = $DownMarker
@onready var gun: Node2D = $Gun

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _process(delta: float) -> void:
	if player:
		distance_to_player = player.global_position.x - global_position.x
	
	if distance_to_player > 0:
		gun.global_transform = right_marker.global_transform
	elif distance_to_player < 0:
		gun.global_transform = left_marker.global_transform
	
	
	shot_timer -= delta
	if abs(distance_to_player) <= attack_distance:
		# shooting implementation
		if shot_timer <= 0:
			shoot()
			shot_timer = shot_interval
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if abs(distance_to_player) >= attack_distance:
		# Move towards player
		velocity.x = speed * sign(distance_to_player)
	elif abs(distance_to_player) <= personal_distance:
		velocity.x = -speed * sign(distance_to_player)
	else:
		velocity.x = 0
	
	move_and_slide()

func shoot():
	var instance = bullet.instantiate()
	instance.global_transform = gun.global_transform
	instance.dir = gun.rotation
	instance.projectile_owner = "enemy"
	get_tree().current_scene.add_child(instance)
