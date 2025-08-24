extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = 500.0

@onready var right_marker: Marker2D = $RightMarker
@onready var left_marker: Marker2D = $LeftMarker
@onready var up_marker: Marker2D = $UpMarker
@onready var down_marker: Marker2D = $DownMarker
@onready var right_down_marker: Marker2D = $RightDownMarker
@onready var left_down_marker: Marker2D = $LeftDownMarker

@onready var character_sprite: Sprite2D = $Character
@onready var character_collider: CollisionShape2D = $CollisionShape2D

@onready var gun: Node2D = $Gun

var bullet = preload("res://scenes/projectile.tscn")
var facing_direction = 1

func _ready() -> void:
	# Set the gun at the right position on start
	gun.global_transform = right_marker.global_transform

func _process(delta: float) -> void:
	# Input
	var direction := Input.get_vector("move_left", "move_right", "crouch", "look_up")
	
	# Get proper facing directions
	if direction.x > 0:
		facing_direction = 1
	elif direction.x < 0:
		facing_direction = -1
	
	# Set the gun to face properly depening on input directions
	if direction.y > 0:
		gun.global_transform = up_marker.global_transform
	elif direction.y < 0:
		if is_on_floor():
			if facing_direction > 0:
				gun.global_transform = right_down_marker.global_transform
			elif facing_direction < 0:
				gun.global_transform = left_down_marker.global_transform
		else:
			gun.global_transform = down_marker.global_transform
	elif direction.y == 0:
		if facing_direction > 0:
			gun.global_transform = right_marker.global_transform
		elif facing_direction < 0:
			gun.global_transform = left_marker.global_transform
	
	# Shoot when shoot button is pressed
	if Input.is_action_just_pressed("shoot"):
		shoot()
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY

	# Get the input direction (-1, 0, 1)
	var direction := Input.get_axis("move_left", "move_right")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func shoot():
	var instance = bullet.instantiate()
	instance.global_transform = gun.global_transform
	instance.dir = gun.rotation
	get_tree().root.add_child(instance)
