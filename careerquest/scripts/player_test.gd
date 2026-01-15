extends CharacterBody3D

#constants
const SPEED = 7.5
const JUMP_VELOCITY = 6.0

#main ui
@onready var start := $CanvasLayer/main
@onready var credits := $CanvasLayer/credits
@onready var careers := $CanvasLayer/careers
@onready var career_desc := $CanvasLayer/career_desc
@onready var pause := $CanvasLayer/pause
@onready var loading := $CanvasLayer/load_screen

@onready var tutorial := $CanvasLayer/tutorial

#pick item variables
@onready var head := $head
@onready var camera := $head/camera
@onready var ray := $head/camera/ray

#doctor tools
@onready var steth := $head/camera/steth
@onready var therm := $head/camera/therm
@onready var therm_off := $head/camera/therm/therm_off
@onready var therm_on_good := $head/camera/therm/therm_on
@onready var tongue := $head/camera/tongue
@onready var gluc := $head/camera/gluc
@onready var tri := $head/camera/tri
var doc_tool_processing := false

#doctor ui variables
@onready var clipboard := $clipboard
@onready var label := $CanvasLayer/Interact/interact_button
@onready var book := $CanvasLayer/Book/book
@onready var book_ui := $CanvasLayer/book_ui
@onready var asthma := $CanvasLayer/book_ui/asthma
@onready var arthritis := $CanvasLayer/book_ui/arthritis
@onready var flu := $CanvasLayer/book_ui/flu
@onready var copd := $CanvasLayer/book_ui/copd
@onready var migraine := $CanvasLayer/book_ui/migraine
@onready var diabetes := $CanvasLayer/book_ui/diabetes
@onready var gerd := $CanvasLayer/book_ui/gerd
@onready var iron := $CanvasLayer/book_ui/iron
@onready var blood := $CanvasLayer/book_ui/blood
@onready var forward := $CanvasLayer/book_ui/buttons/forward
@onready var backward := $CanvasLayer/book_ui/buttons/backwards
@onready var player_dia := $CanvasLayer/player_dialogue_main
@onready var player_dia_exit := $CanvasLayer/player_dialogue_main/MarginContainer/vbox/VBoxContainer2/exit
@onready var pages = [asthma, arthritis, flu, copd, migraine, diabetes, gerd, iron, blood]

#electrician tools
@onready var screw := $head/camera/screw
@onready var plier := $head/camera/plier
@onready var volt := $head/camera/volt
@onready var wire := $head/camera/wire
@onready var tape := $head/camera/tape
var elec_tool_processing := false

#electrician locations
@onready var house := $"../electric_scene/house2"
@onready var coffee := $"../electric_scene/coffee_test"
@onready var office := $"../electric_scene/office"
@onready var nasa := $"../electric_scene/nasa"
@onready var factory := $"../electric_scene/factory2"
@onready var apartment := $"../electric_scene/apartment2"

#electrician ui
@onready var star := $CanvasLayer/elec_options

#electrician outlet scene
@onready var outlet1 = get_outlet_by_id(0)
@onready var outlet2 = get_outlet_by_id(1)
@onready var outlet3 = get_outlet_by_id(2)

@onready var electric = get_node("/root/main/electric_scene")

@onready var doc_npc = get_node("/root/main/npc")

# Called when the node enters the scene tree for the first time.
func _ready():
	tutorial.hide()
	clipboard.hide()
	loading.hide()
	start.show()
	credits.hide()
	careers.hide()
	career_desc.hide()
	pause.hide()
	star.hide()
	global_position.x = 25.5
	global_position.z = -15.5
	global_rotation = Vector3(0,0,0)
	player_dia.hide()
	outlet1.position = Vector3(3,0,.5)
	outlet2.position = Vector3(4.5,0,.5)
	outlet3.position = Vector3(6,0,.5)
	print(Global.elec_cond)

#Captures/hides and shows mouse when moving/press esc
func _input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and !Global.pause_game:
		if event is InputEventMouseMotion and $head/camera.current:
			head.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Global.mouse_mode == 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Global.mouse_mode == 1:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#pause game
	if Input.is_action_just_pressed("pause") and !start.visible and !careers.visible and !loading.visible and !career_desc.visible and !credits.visible:
		if Global.pause_game:
			pause.hide()
			return
		else:
			pause.show()
			return
	
	#sets mouse value based on ui position
	if pause.visible or start.visible or credits.visible or careers.visible or career_desc.visible or tutorial.visible:
		Global.mouse_mode = 1
	elif Global.is_doc:
		if Global.clipboard_info["clip_ui"].position.y == -300 or Global.flip_book_anim or Global.is_talking:
			Global.mouse_mode = 1
		else:
			Global.mouse_mode = 0
	elif Global.is_elec:
		if star.visible:
			Global.mouse_mode = 1
		else:
			Global.mouse_mode = 0
	else:
		Global.mouse_mode = 0

	#calls init functions, also hides all ui
	player_dialogue()
	move_clip()
	book.hide()
	book_ui.hide()
	flip_book()
	check_comp()
	#detects what the player is looking at, then performs functions based off of object
	var object = ray.get_collider()
	if ray.is_colliding() and !Global.pause_game:
		if !Global.at_start:
			#allows talking to doctor npc
			if object == doc_npc:
				if !object.has_method("interact"):
					label.show()
					if Input.is_action_just_pressed("interact"):
						if Global.active_tool != -1:
							if Global.active_tool == 0:
								#Enter Heartbeat Noise Here
								if Global.condition["asthma"] or Global.condition["flu"] or Global.condition["copd"] or Global.condition["acid"] or Global.condition["iron"]  and !doc_tool_processing:
									print("The patient's heartbeat sounds irregular...")
								else:
									print("The patient's heartbeat sounds fine...")
							if Global.active_tool == 1 and !doc_tool_processing:
								doc_tool_processing = true
								Global.doc_therm_text = ""
								for i in range(3):
									print("whirring...")
									await get_tree().create_timer(1.0).timeout
								Global.doc_therm_text = str(Global.condition["temp"])
								therm_off.hide()
								therm_on_good.show()
								Global.doc_therm_text = str(Global.condition["temp"])
								print("Temp: " + str(Global.condition["temp"]))
								doc_tool_processing = false
							if Global.active_tool == 2:
								if Global.condition["flu"] or Global.condition["copd"] or Global.condition["acid"]:
									print("You see a redness in the patient's throat...")
								else:
									print("The patient's throat looks normal...")
							if Global.active_tool == 3:
								print("Sugar level: " + str(Global.condition["sugar"]) + "mg/dl")
							if Global.active_tool == 4:
								if Global.condition["arthritis"]:
									print("The patient had some joint pain and swelling...")
								else:
									print("The patient has normal reaction to reflex hammer...")
						else:
							Global.is_talking = true
		#opens doctor book for medications
		if object.is_in_group("book"):
			if !object.has_method("interact"):
				book.show()
				if Input.is_action_just_pressed("interact"):
					Global.flip_book_anim = true
		#opens electrician switchboard function
		if object.is_in_group("switch_board_elec"):
			if !object.has_method("interact"):
				label.show()
				if Input.is_action_just_pressed("interact"):
					if Global.is_elec:
						Global.open_fusebox = true
					else:
						print("elec not started yet")
		#press switches in fusebox
		if object.is_in_group("fusebox_switch"):
			if !object.has_method("interact"):
				label.show()
				if Input.is_action_just_pressed("interact"):
					var sw = ["sw1","sw2","sw3","sw4","sw5","sw6","sw7","sw8","sw9","sw10"]
					for i in range(10):
						if object.is_in_group(sw[i]):
							if Global.elec_job_comp["breaker"]:
								return
							electric.switches_move(i+1)
							Global.sw_num(i) 
							Global.calc_load()
		#plays outlet fixing animation when interacted with
		if object.is_in_group("outlet"):
			if !object.has_method("interact"):
				label.show()
				if Input.is_action_just_pressed("interact"):
					var outlet = object.get_parent()
					if object.is_in_group("outlet_scene1"):
						outlet.remove_case()
					elif object.is_in_group("outlet_scene2"):
						outlet.unplug()
					elif object.is_in_group("outlet_scene3"):
						outlet.fix_wiring()
	else:
		label.hide()
	#hides/shows forward/backward button of doctor book
	if asthma.visible:
		backward.hide()
	else:
		backward.show()
	if blood.visible:
		forward.hide()
	else:
		forward.show()

	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and Global.clipboard_info["checkbox_checked"].position.y == 0 and !Global.pause_game:
		velocity.y = JUMP_VELOCITY

	#doctor inventory selection - select tools for analysis
	var doc_tools = [steth, therm, tongue, gluc, tri]
	var elec_tools = [screw, plier, volt, wire, tape]
	var input_index = ["1","2","3","4","5"]
	if Global.is_doc and Global.mouse_mode == 0:
		if Global.active_tool == -1:
			for i in range(5):
				doc_tools[i].hide()
		for i in range(5):
			if Input.is_action_just_pressed(input_index[i]):
				# If selecting the same tool → unequip
				if Global.active_tool == i:
					doc_tools[i].visible = false
					Global.active_tool = -1
					continue
				# Selecting a new tool
				for t in doc_tools:
					t.visible = false
				doc_tools[i].visible = true
				Global.active_tool = i
				if Global.active_tool == 1:
					therm_off.show()
					therm_on_good.hide()
	if Global.is_elec and Global.mouse_mode == 0:
		if Global.active_tool == -1:
			for i in range(5):
				elec_tools[i].hide()
		for i in range(5):
			if Input.is_action_just_pressed(input_index[i]):
				# If selecting the same tool → unequip
				if Global.active_tool == i:
					elec_tools[i].visible = false
					Global.active_tool = -1
					continue
				# Selecting a new tool
				for t in elec_tools:
					t.visible = false
				elec_tools[i].visible = true
				Global.active_tool = i

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Global.clipboard_info["clip_ui"].position.y == 0 and !Global.pause_game and !start.visible and !careers.visible and !loading.visible and !career_desc.visible and !credits.visible:
		if direction and $head/camera.current:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

#clipboard animation (pull out/keep back)
func move_clip():
	if Input.is_action_just_pressed("clipboard") and !Global.clipboard_info["is_editing"] and Global.is_doc:
		if Global.clipboard_info["clip_ui"].position.y == -300:
			Global.clipboard_info["clip_ui"].position.y = 0
		elif Global.clipboard_info["clip_ui"].position.y == 0:
			Global.clipboard_info["clip_ui"].position.y = -300

#doctor book animation (flip pages)
func flip_book():
	if not Global.flip_book_anim:
		return
	book_ui.show()
	if Global.escape_doctor_button:
		book_ui.hide()
		Global.escape_doctor_button = false
		Global.flip_book_anim = false
		return
	# find current visible page
	var current_index = -1
	for i in range(pages.size()):
		if pages[i].visible:
			current_index = i
			break
	if current_index == -1:
		return  # nothing visible
	if Global.doc_forward and current_index < pages.size() - 1:
		pages[current_index].hide()
		pages[current_index + 1].show()
		Global.doc_forward = false
	elif Global.doc_backward and current_index > 0:
		pages[current_index].hide()
		pages[current_index - 1].show()
		Global.doc_backward = false

#player dialogue to doctor npc
func player_dialogue():
	if Global.is_talking:
		player_dia.show()
	else:
		player_dia.hide()

func check_comp():
	if (outlet1.outlet["is_case_removed"] and outlet1.outlet["is_fixed"]
	and outlet2.outlet["is_case_removed"] and outlet2.outlet["is_fixed"]
	and outlet3.outlet["is_case_removed"] and outlet3.outlet["is_fixed"]):
		Global.elec_job_comp["outlet"] = true
	if Global.elec_job_comp["breaker"] and Global.elec_job_comp["outlet"]:
		$CanvasLayer/career_desc/MarginContainer/VBoxContainer/Label.text = Global.pick_desc(Global.elec_cond["location"])
		global_position.x = 25.5
		global_position.z = -15.5
		global_rotation = Vector3(0,0,0)
		Global.is_elec = false
		Global.elec_job_comp["breaker"] = false
		Global.elec_job_comp["outlet"] = false
		Global.elec_job_comp["light"] = false
		outlet1.reset()
		outlet2.reset()
		outlet3.reset()
		Global.elec_cond["difficulty"] = null
		Global.active_tool = -1
		var elec_tools = [screw, plier, volt, wire, tape]
		for i in range(5):
			elec_tools[i].hide()
		Global.elec_games = true
		career_desc.show()
	if Global.is_doc and Global.repetition == 1:
		book_ui.hide()
		clipboard.hide()
		print("Score: " + str(Global.score))
		Global.is_doc = false
		global_position.x = 25.5
		global_position.z = -15.5
		global_rotation = Vector3(0,0,0)
		$CanvasLayer/career_desc/MarginContainer/VBoxContainer/Label.text = Global.pick_doc_desc()
		$CanvasLayer/career_desc/MarginContainer/VBoxContainer/score.text = str(Global.score)
		career_desc.show()
		Global.repetition = 0

func move_outlet():
	var layouts = {
		"house": [
			Vector3(3.014,0,.592),
			Vector3(-4.748,0,2.118),
			Vector3(5.196,0,8.248),
			Vector3(0,0,0),
			Vector3(0,deg_to_rad(90),0),
			Vector3(0,deg_to_rad(-90),0)
		],
		"coffee_shop": [
			Vector3(3.014,0,.592),
			Vector3(-4.748,0,8.105),
			Vector3(4.828,0,6.206),
			Vector3(0,0,0),
			Vector3(0,deg_to_rad(90),0),
			Vector3(0,deg_to_rad(-90),0)
		],
		"office": [
			Vector3(13.007,0,3.069),
			Vector3(-2.834,0,8.374),
			Vector3(4,0,13.662),
			Vector3(0,deg_to_rad(-90),0),
			Vector3(0,deg_to_rad(90),0),
			Vector3(0,deg_to_rad(90),0)
		],
		"nasa": [
			Vector3(7.485,0,.721),
			Vector3(-3,0,8.676),
			Vector3(-7.502,0,1.431),
			Vector3(0,deg_to_rad(-90),0),
			Vector3(0,deg_to_rad(-180),0),
			Vector3(0,deg_to_rad(90),0)
		],
		"factory": [
			Vector3(7.006,0,-2.331),
			Vector3(-3,0,7),
			Vector3(-7,0,-5.65),
			Vector3(0,deg_to_rad(-90),0),
			Vector3(0,deg_to_rad(180),0),
			Vector3(0,deg_to_rad(90),0)
		],
		"apartment": [
			Vector3(4.536,0,3.227),
			Vector3(-3,0,9.787),
			Vector3(-4.523,0,-.905),
			Vector3(0,deg_to_rad(-90),0),
			Vector3(0,deg_to_rad(-180),0),
			Vector3(0,deg_to_rad(90),0)
	]}
	var loc = {"house":[house,2.491],"coffee_shop":[coffee,0],"office":[office,2.491],"nasa":[nasa,4.99],"factory":[factory,4.99],"apartment":[apartment,3.185]}
	# find which condition is active
	for key in layouts.keys():
		if Global.elec_cond["location"] == key:
			var pos = layouts[key]
			for k in loc.keys():
				loc[k][0].hide()
				loc[k][0].position.y = 10
			loc[key][0].show()
			loc[key][0].position.y = loc[key][1]
			outlet1.position = pos[0]
			outlet2.position = pos[1]
			outlet3.position = pos[2]
			outlet1.rotation = pos[3]
			outlet2.rotation = pos[4]
			outlet3.rotation = pos[5]
			return

func get_outlet_by_id(id: int):
	for child in $"../electric_scene".get_children():
		if child is Outlet:  # <— IMPORTANT
			if child.outlet_id == id:
				return child
	return null


#signals
func _on_forward_pressed() -> void:
	Global.doc_forward = true # Replace with function body.

func _on_escape_pressed() -> void:
	Global.escape_doctor_button = true # Replace with function body.

func _on_backwards_pressed() -> void:
	Global.doc_backward = true # Replace with function body.

func _on_names_pressed() -> void:
	Global.ask_name = true # Replace with function body.
	Global.is_talking = false

func _on_feelings_pressed() -> void:
	Global.ask_feel = true # Replace with function body.
	Global.is_talking = false

func _on_exit_pressed() -> void:
	Global.is_talking = false # Replace with function body.

func _on_star1_pressed() -> void:
	Global.elec_cond["difficulty"] = 0
	print("easy mode")

func _on_star3_pressed() -> void:
	Global.elec_cond["difficulty"] = 1
	print("intermediate mode")
func _on_star5_pressed() -> void:
	Global.elec_cond["difficulty"] = 2
	print("hard mode")

func _on_resume_pressed() -> void:
	Global.pause_game = false
	pause.hide()
	 # Replace with function body.

func _on_exit_game_pressed() -> void:
	get_tree().quit() # Replace with function body.

func _on_start_game_pressed() -> void:
	start.hide()
	careers.show() # Replace with function body.

func _on_credits_pressed() -> void:
	credits.show() # Replace with function body.
	start.hide()

func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.

func _on_back_main_pressed() -> void:
	credits.hide() # Replace with function body.
	start.show()

func _on_back_career_pressed() -> void:
	careers.hide()
	start.show()

#starts doctor roleplay
func _on_start_doc_pressed() -> void:
	Global.clipboard_info["clip_ui"].go_to_info()
	Global.clipboard_info["clip_ui"].position.y = 0
	clipboard.show()
	careers.hide()
	if Global.at_start:
		global_position.x = -1.5
		global_position.z = 1.5
		global_rotation = Vector3(0,0,0)
		await get_tree().create_timer(2.0).timeout
		tutorial.show()
		Global.interact() # Replace with function body.

#starts electrician roleplay
func _on_elec_pressed() -> void:
	clipboard.hide()
	Global.clipboard_info["clip_ui"].position.y = 0
	careers.hide()
	global_position.x = -20
	global_position.z = -3
	global_rotation = Vector3(0,0,0)
	loading.show()
	await get_tree().create_timer(2.0).timeout
	loading.hide()
	Global.is_elec = true
	move_outlet()
	tutorial.show()
	star.show()
	print("elec start") # Replace with function body.

#provides 
func _on_exit_career_desc_pressed() -> void:
	career_desc.hide()
	careers.show()

func _on_exit_tut_pressed() -> void:
	tutorial.hide() # Replace with function body.
