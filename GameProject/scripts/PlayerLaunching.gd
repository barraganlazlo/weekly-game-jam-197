extends RigidBody2D

const UP = Vector2(0,-1)

#nodes
onready var raycasts : Node2D = $Body/Raycasts
onready var body : CollisionShape2D = $Body
onready var sprite : Sprite = $Body/Sprite

#reglages
export(NodePath) var Bag : NodePath
export(float) var move_speed : float = 3

#runtime
var velocity :=Vector2(0,0)
var is_grounded :=false
var animation_frames : int 

func _ready():
	animation_frames=sprite.hframes

func _physics_process(delta:float) -> void :
	var move_direction := -Input.get_action_strength("move_left") +Input.get_action_strength("move_right")
	velocity.x=move_direction * move_speed * Globals.UNIT_SIZE
	if move_direction >0:
		body.scale.x=1
	elif move_direction <0:
		body.scale.x=-1
	#add_central_force(velocity - veloc)
