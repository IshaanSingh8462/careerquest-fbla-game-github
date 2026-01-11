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

@onready var ind_num := $indicator_num/SubViewport/Label

@onready var outlet1 := $outlet
@onready var outlet2 := $outlet2
@onready var outlet3 := $outlet3

#locations
@onready var traffic_light := $traffic_light
@onready var factory := $factory
@onready var apartment := $apartment
@onready var house := $house

@onready var red = load("res://scenes/materials/light_red.tres")
@onready var green = load("res://scenes/materials/green.tres")
@onready var white = load("res://scenes/materials/white.tres")
@onready var yellow = load("res://scenes/materials/light_yellow.tres")

@onready var elec_location_pick_ = false

var openingFuse = true
var ROT_SPEED = Vector3(0,deg_to_rad(-3),0)
var rot = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	var all_switches = [switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8, switch9, switch10]
	for s in all_switches:
		s.global_rotation.y = deg_to_rad(-30)
	fuse_door.global_rotation = Vector3(0,deg_to_rad(179.5),0)
	traffic_light.hide()
	factory.hide()
	apartment.hide()
	house.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	elec_location_pick()
	open_fuse()
	sw_values()
	ind_num.text = str(Global.load)
	if Global.load == Global.elec_cond["load_limit"]:
		indicator.material = green
		Global.elec_job_comp["breaker"] = true
		var all_switches = [switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8, switch9, switch10]
		for s in all_switches:
			s.global_rotation.y = deg_to_rad(-30)
		var sw_value = [trip1,trip2,trip3,trip4,trip5,trip6,trip7,trip8,trip9,trip10]
		for i in range(10):
			sw_value[i].material = red
		for i in range(10):
			Global.sw_states[i] = false
		Global.load = 0
		Global.elec_cond["load_limit"] = null
	check_comp()

#open fusebox door animation
func open_fuse():
	if Global.open_fusebox and openingFuse:
		for i in range(80):
			pass
		fuse_door.global_rotation.y += ROT_SPEED.y
		rot.y += fuse_door.global_rotation.y
		if rot.y >= 80:
			openingFuse = false
			Global.open_fusebox = false

#flip switch animation
func switches_move(switch):
	if Global.elec_job_comp["breaker"]:
		return
	var switches = [switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8, switch9, switch10]
	for i in range(10):
		if i == switch - 1:
			var angle = switches[i].global_rotation.y
			if abs(angle - deg_to_rad(-30)) < 0.01:
				switches[i].global_rotation.y = deg_to_rad(30)
			elif abs(angle - deg_to_rad(30)) < 0.01:
				switches[i].global_rotation.y = deg_to_rad(-30)

func sw_values():
	if Global.elec_job_comp["breaker"]:
		return
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
		indicator.material = yellow

func elec_location_pick():
	if Global.is_elec and not elec_location_pick_:
		var elec_location = ["house","coffee_shop","office","traffic_light","factory","apartment"]
		var locations = [house, house, house, traffic_light, factory, apartment]
		for i in range(6):
			if Global.elec_cond["location"] == elec_location[i]:
				locations[i].show()
				print(elec_location[i])
				elec_location_pick_ = true
		loc_coll()
		openingFuse = true
		rot = Vector3(0,0,0)


func loc_coll():
	var loc = {
		"house": [house, 3],
		"coffee_shop": [house, 3],
		"office": [house, 3],
		"factory": [factory, 3],
		"traffic_light": [traffic_light, 3],
		"apartment": [apartment, 3]
	}
	var current = Global.elec_cond["location"]
	# First hide all unique nodes
	var unique_nodes = {}
	for key in loc.keys():
		unique_nodes[loc[key][0]] = true
	for node in unique_nodes.keys():
		node.hide()
		node.position.y = 10
	# Then show the active one
	var node = loc[current][0]
	node.show()
	node.position.y = loc[current][1]


	'''if Global.elec_cond["location"] == "traffic_light" or Global.elec_cond["location"] == "factory":
		house.global_position = Vector3(10,0,0)
		apartment.global_position = Vector3(0,0,0)
	if Global.elec_cond["location"] == "apartment":
		house.global_position = Vector3(0,10,0)'''

func check_comp():
	if Global.elec_games:
		#elec_location_pick_ = false
		fuse_door.global_rotation = Vector3(0,deg_to_rad(179.5),0)
		house.position.y = 3
		apartment.position.y = 3
		factory.position.y = 3
		traffic_light.position.y = 3
		Global.is_elec = false
		print("elec done")
		elec_location_pick_ = false
		var rand_loc = Global.elec_location.pick_random()
		Global.elec_cond["location"] = rand_loc
		print(Global.pick_desc(rand_loc))
		Global.elec_games = false
