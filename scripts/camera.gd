extends Camera2D

var player : Player

@export var follow_offset : Vector2 = Vector2(0, -200)

var follow : bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		follow = not follow
	
	if follow:
		follow_player()
	
func follow_player():
	global_position = player.global_position + follow_offset
