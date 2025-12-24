extends Node3D

#create reference nodes and variables
@onready var fuse_door := $hinge
@onready var switch1 := $circuit_button1
@onready var switch2 := $circuit_button2
@onready var switch3 := $circuit_button3
@onready var switch4 := $circuit_button4
@onready var switch5 := $circuit_button5
@onready var switch6 := $circuit_button6
@onready var switch7 := $circuit_button7
@onready var switch8 := $circuit_button8
@onready var switch9 := $circuit_button9
@onready var switch10 := $circuit_button10

var openingFuse = true
var ROT_SPEED = Vector3(0,deg_to_rad(-3),0)
var rot = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	var all_switches = [switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8, switch9, switch10]
	for s in all_switches:
		s.global_rotation.y = deg_to_rad(-30)
	fuse_door.global_rotation = Vector3(0,deg_to_rad(179.5),0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Global.open_fusebox:
		open_fuse()

#open fusebox door animation
func open_fuse():
	if openingFuse:
		fuse_door.global_rotation.y += ROT_SPEED.y
		rot.y += fuse_door.global_rotation.y
		if rot.y >= 80:
			openingFuse = false

#flip switch animation
func switches_move(switch):
	var switches = [switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8, switch9, switch10]
	for i in range(10):
		if i == switch - 1:
			var angle = switches[i].global_rotation.y
			if abs(angle - deg_to_rad(-30)) < 0.01:
				switches[i].global_rotation.y = deg_to_rad(30)
			elif abs(angle - deg_to_rad(30)) < 0.01:
				switches[i].global_rotation.y = deg_to_rad(-30)
