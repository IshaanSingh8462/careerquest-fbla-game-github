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

@onready var trip1 := $trip1
@onready var trip2 := $trip2
@onready var trip3 := $trip3
@onready var trip4 := $trip4
@onready var trip5 := $trip5
@onready var trip6 := $trip6
@onready var trip7 := $trip7
@onready var trip8 := $trip8
@onready var trip9 := $trip9
@onready var trip10 := $trip10

@onready var indicator := $indicator

@onready var red = load("res://scenes/materials/light_red.tres")
@onready var green = load("res://scenes/materials/green.tres")
@onready var white = load("res://scenes/materials/white.tres")

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
	sw_values()

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

func sw_values():
	var sw_value = [trip1,trip2,trip3,trip4,trip5,trip6,trip7,trip8,trip9,trip10]
	for i in range(10):
		if Global.sw_states[i]:
			sw_value[i].material = green
		else:
			sw_value[i].material = red
	if Global.tripped_status:
		indicator.material = red
		for i in sw_value:
			i.material = red
	else:
		indicator.material = green
