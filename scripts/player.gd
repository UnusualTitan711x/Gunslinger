extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var jump_velocity = 500.0
@export var gravity = 980.0

@onready var right_marker: Marker2D = $RightMarker
@onready var left_marker: Marker2D = $LeftMarker
@onready var up_marker: Marker2D = $UpMarker
@onready var down_marker: Marker2D = $DownMarker
@onready var right_down_marker: Marker2D = $RightDownMarker
@onready var left_down_marker: Marker2D = $LeftDownMarker

# This is for testing
@onready var normal_sprite: Sprite2D = $normal_sprite
@onready var crouch_sprite: Sprite2D = $crouch_sprite
@onready var normal_collider: CollisionShape2D = $normal_collider
@onready var crouch_collider: CollisionShape2D = $crouch_collider

@onready var gun: Node2D = $Gun

var bullet = preload("res://scenes/projectile.tscn")
var facing_direction = 1
var is_crouching: bool = false
var direction : Vector2
var dead : bool = false

func _ready() -> void:
	# Set the gun at the right position on start
	gun.global_transform = right_marker.global_transform

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if dead: return
	
	# Input
	direction = Input.get_vector("move_left", "move_right", "crouch", "look_up")
	
	# Get proper facing directions
	if direction.x > 0:
		facing_direction = 1
	elif direction.x < 0:
		facing_direction = -1
	
	# Set the gun to face properly depening on input directions
	if direction.y > 0:
		gun.global_transform = up_marker.global_transform
		
		normal_collider.disabled = false
		normal_sprite.visible = true
		crouch_collider.disabled = true
		crouch_sprite.visible = false
	elif direction.y < 0:
		if is_on_floor(): # Basically crouching
			if facing_direction > 0:
				gun.global_transform = right_down_marker.global_transform
			elif facing_direction < 0:
				gun.global_transform = left_down_marker.global_transform
			
			normal_collider.disabled = true
			normal_sprite.visible = false
			crouch_collider.disabled = false
			crouch_sprite.visible = true
			
		else:
			gun.global_transform = down_marker.global_transform
	elif direction.y == 0:
		if facing_direction > 0:
			gun.global_transform = right_marker.global_transform
		elif facing_direction < 0:
			gun.global_transform = left_marker.global_transform
		
		normal_collider.disabled = false
		normal_sprite.visible = true
		crouch_collider.disabled = true
		crouch_sprite.visible = false
	
	# Shoot when shoot button is pressed
	if Input.is_action_just_pressed("shoot"):
		shoot()
	

func _physics_process(delta: float) -> void:
	if dead: return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and direction.y >= 0:
		velocity.y = -jump_velocity

	# Get the input direction (-1, 0, 1)
	var direction := Input.get_axis("move_left", "move_right")
	
	# Apply movement
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func shoot():
	var instance = bullet.instantiate()
	instance.global_transform = gun.global_transform
	instance.dir = gun.rotation
	instance.projectile_owner = "player"
	get_tree().current_scene.add_child(instance)

func die():
	dead = true
	normal_sprite.visible = false
	get_tree().call_deferred("reload_current_scene")
