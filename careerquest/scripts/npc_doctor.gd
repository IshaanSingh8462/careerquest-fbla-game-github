extends Node3D

#create reference nodes and variables
var SPEED = 5
var start = Vector3(3.5, 1.75, 10)
var move_into = Vector3(3.5, 1.75, 0)
var going_back = false

@onready var mesh_mat = $MeshInstance3D
@onready var dialogue = $Sprite3D/SubViewport/Label

var red = load("res://scenes/materials/light_red.tres")
var white = load("res://scenes/materials/white.tres")
var green = load("res://scenes/materials/green.tres")
var blue = load("res://scenes/materials/light_blue.tres")

var all_symptoms = ["asthma", "arthritis", "copd", "flu", "migraine", "diabetes", "acid", "iron", "blood_pressure"]
var boy_first_names = ["aiden","liam","noah","ethan","mason","lucas","james",
						"benjamin","henry","alexander","daniel","matthew","samuel"]
var girl_first_names = ["sophia","livia","emma","ava","isabella","mia","charlotte",
						"amelia","harper","evelyn","abigail","ella"]
var last_names = ["smith", "johnson", "williams", "brown", "jones", "garcia", "miller",
				"davis", "rodriguez", "martinez", "hernandez", "lopez", "gonzalez",
				"wilson", "anderson", "thomas", "taylor", "moore", "jackson", "martin",
				"lee", "perez", "thompson", "white", "harris"]
var birth_year = [1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990,
				1991, 1992, 1993, 1994, 1995,1996,1997,1998,1999, 2000, 2001,
				2002, 2003, 2004, 2005, 2006]
var birth_month_30 = [4,6,9,11]
var birth_month_31 = [1,3,5,7,8,10,12]
var birth_day_30 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
					21,22,23,24,25,26,27,28,29,30]
var birth_day_31 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
					21,22,23,24,25,26,27,28,29,30,31]
var dictionary = {"first_name":"", "last_name":"", "dob":"","gender":"","condition":""}
var dict_comp = {"first_name":"", "last_name":"", "dob":"", "gender":"male", "condition":"",}
var repetition = 0

var total_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_condition()
	position = start
	change_color(white)
	dialogue.text = ""
	if Global.condition["asthma"] or Global.condition["flu"] or Global.condition["copd"] or Global.condition["acid"] or Global.condition["iron"]:
		Global.condition["temp"] = randi_range(100,103)
	elif Global.condition["diabetes"]:
		Global.condition["sugar"] = randi_range(140,210)
	else:
		Global.condition["temp"] = randi_range(97,99)
		Global.condition["sugar"] = randi_range(100,140)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#calls functions to start doctor npc scene
	random()
	get_condition()
	npc_dialogue(delta)
	#move npc into room animation, then resets global condition varialbe
	if Global.move:
		position = position.move_toward(move_into, SPEED * delta)
	if position == start:
		Global.at_start = true
		for i in all_symptoms:
			Global.condition[i] = false
	#npc leaves room animation
	if going_back:
		position = position.move_toward(start, SPEED * delta)
		if position == start:
			going_back = false
	#tests to confirm condition, then calls condition function
	for i in all_symptoms:
		if Global.condition[i]:
			submit()

#randomizes condition
func random():
	if Global.random_symp:
		var first_names = [boy_first_names.pick_random(), girl_first_names.pick_random()]
		var birth_month = [birth_month_30.pick_random(), birth_month_31.pick_random(), 2]
		dictionary["condition"] = all_symptoms.pick_random()
		dictionary["first_name"] = first_names.pick_random()
		if dictionary["first_name"] == first_names[0]:
			dictionary["gender"] = "male"
		else:
			dictionary["gender"] = "female"
		dictionary["last_name"] = last_names.pick_random()
		var random_month = birth_month.pick_random()
		var random_year = birth_year.pick_random()
		if random_month == birth_month[0]:
			dictionary["dob"] = (str(random_month) + "/" + str(birth_day_30.pick_random()) + "/" + str(random_year))
		elif random_month == birth_month[1]:
			dictionary["dob"] = (str(random_month) + "/" + str(birth_day_31.pick_random()) + "/" + str(random_year))
		else:
			dictionary["dob"] = (str(2) + "/" + str(random_month) + "/" + str(random_year))
		print(dictionary["condition"], ", ", dictionary["first_name"], " ", dictionary["last_name"], ", ", dictionary["gender"], ", ", dictionary["dob"])
		Global.random_symp = false
	
#tests to see what condition the npc has
func get_condition():
	for i in all_symptoms:
		if dictionary["condition"] == i:
			Global.condition[i] = true

#scores player input on clipboard
func submit():
	change_color(blue)
	if Global.clipboard_info["clicked"]:
		dict_comp["first_name"] = Global.clipboard_info["first"]
		dict_comp["last_name"] = Global.clipboard_info["last"]
		dict_comp["dob"] = Global.clipboard_info["dob"]
		dict_comp["gender"] = Global.clipboard_info["gender"]
		print(dict_comp)
		print(dictionary)
		if dict_comp["first_name"] == dictionary["first_name"]:
			Global.score += 50
		if dict_comp["last_name"] == dictionary["last_name"]:
			Global.score += 50
		if dict_comp["dob"] == dictionary["dob"]:
			Global.score += 50
		if dict_comp["gender"] == dictionary["gender"]:
			Global.score += 50
		going_back = true
		Global.move = false
		Global.repetition += 1
		dialogue.text = ""
		if !Global.timer:
			Global.clipboard_info["clicked"] = false

#changed color of mesh (testing)
func change_color(col):
	mesh_mat.set_surface_override_material(0, col)

#generates dialogue for npc when player interacts with it
func npc_dialogue(delta):
	if Global.ask_name:
		dialogue.text = "My name is " + dictionary["first_name"] + " " + dictionary["last_name"] + ", and \nmy dob is " + dictionary["dob"]
		total_time += delta
	elif Global.ask_feel:
		dialogue.text = "My condition is " + dictionary["condition"]
		total_time += delta
	else:
		dialogue.text = ""
	if total_time >= 5:
		Global.ask_name = false
		Global.ask_feel = false
		total_time = 0
