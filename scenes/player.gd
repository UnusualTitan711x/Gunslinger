extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var right_marker: Marker2D = $RightMarker
@onready var left_marker: Marker2D = $LeftMarker
@onready var up_marker: Marker2D = $UpMarker
@onready var down_marker: Marker2D = $DownMarker
@onready var gun: Sprite2D = $Gun

var bullet = preload("res://scenes/projectile.tscn")

func _process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var look := Input.get_axis("crouch", "look_up")
	
	# Flip sprite to face movement direction
	if direction > 0:
		gun.global_transform = right_marker.global_transform
	elif direction < 0:
		gun.global_transform = left_marker.global_transform
	
	if look > 0:
		gun.global_transform = up_marker.global_transform
	elif look < 0:
		gun.global_transform = down_marker.global_transform
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction (-1, 0, 1)
	var direction := Input.get_axis("move_left", "move_right")
	var look := Input.get_axis("crouch", "look_up")
	
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
