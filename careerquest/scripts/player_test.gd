extends CharacterBody3D

#constants
const SPEED = 7.5
const JUMP_VELOCITY = 6.0

#pick item variables
@onready var head := $head
@onready var camera := $head/camera
@onready var ray := $head/camera/ray
@onready var hand := $head/camera/hand

#doctor tools
@onready var steth := $head/camera/steth
@onready var therm := $head/camera/therm
@onready var tongue := $head/camera/tongue
@onready var gluc := $head/camera/gluc
@onready var tri := $head/camera/tri

#doctor ui variables
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

#electrician outlet scene
@onready var o_scene1 := $"../electric_scene/outlet/scene1"
@onready var o_scene2 := $"../electric_scene/outlet/scene2"
@onready var o_scene3 := $"../electric_scene/outlet/scene3"

@onready var electric = get_node("/root/main/electric_scene")

@onready var doc_npc = get_node("/root/main/npc")

# Called when the node enters the scene tree for the first time.
func _ready():
	player_dia.hide()
	o_scene1.position = Vector3(0,1.331,.08)
	o_scene2.position = Vector3(0,10,0)
	o_scene3.position = Vector3(0,10,0)
	
#Captures/hides and shows mouse when moving/press esc
func _input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion and $head/camera.current:
			head.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#sets mouse value based on ui position
	if Global.clipboard_info["clip_ui"].position.y == 0:
		if Global.flip_book_anim or Global.is_talking:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Global.clipboard_info["clip_ui"].position.y == -300:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#calls init functions, also hides all ui
	player_dialogue()
	move_clip()
	label.hide()
	book.hide()
	book_ui.hide()
	flip_book()
	#detects what the player is looking at, then performs functions based off of object
	var object = ray.get_collider()
	if ray.is_colliding():
		if Global.at_start:
			#starts doctor roleplay
			if object.is_in_group("doctor_start"):
				if !object.has_method("interact"):
					label.show()
					if Input.is_action_just_pressed("interact"):
						global_position.x = -1.5
						global_position.z = 1.5
						global_rotation = Vector3(0,0,0)
						await get_tree().create_timer(2.0).timeout
						Global.interact()
		else:
			#allows talking to doctor npc
			if object == doc_npc:
				if !object.has_method("interact"):
					label.show()
					if Input.is_action_just_pressed("interact"):
						if Global.active_tool != -1:
							if Global.active_tool == 0:
								#Enter Heartbeat Noise Here
								if Global.condition["asthma"] or Global.condition["flu"] or Global.condition["copd"] or Global.condition["acid"] or Global.condition["iron"]:
									print("The patient's heartbeat sounds irregular...")
								else:
									print("The patient's heartbeat sounds fine...")
							if Global.active_tool == 1:
								print("Temp: " + str(Global.condition["temp"]))
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

		#starts electrician roleplay
		if object.is_in_group("electrician_start"):
			if !object.has_method("interact"):
					label.show()
					if Input.is_action_just_pressed("interact"):
						global_position.x = -15
						global_position.z = -6
						global_rotation = Vector3(0,0,0)
						await get_tree().create_timer(2.0).timeout
						Global.is_elec = true
						print("elec start")
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
							electric.switches_move(i+1)
							Global.sw_num(i) 
		if object.is_in_group("outlet_scene1") and Global.is_elec:
			if !object.has_method("interact"):
				label.show()
				if Input.is_action_just_pressed("interact"):
					if Global.active_tool != 0:
						print("use a screwdriver")
					elif o_scene3.position == Vector3(0,0,0):
						print("scene 3 in progress")
					elif o_scene1.position == Vector3(0,1.331,.08):
						o_scene2.position = Vector3(0,0,0)
						o_scene2.visible = true
						o_scene1.position = Vector3(-.55,.275,1)
						o_scene1.rotation = Vector3(deg_to_rad(90),deg_to_rad(-35),0)
					else:
						o_scene2.position = Vector3(0,10,0)
						o_scene1.position = Vector3(0,1.331,.08)
						o_scene1.rotation = Vector3(0,0,0)
		elif object.is_in_group("outlet_scene2") and Global.is_elec:
			if !object.has_method("interact"):
				label.show()
				if Input.is_action_just_pressed("interact"):
					if Global.active_tool != 0:
						print("use a screwdriver")
					elif o_scene2.position == Vector3(0,0,0):
						o_scene3.position = Vector3(0,0,0)
						o_scene3.visible = true
						o_scene2.position = Vector3(1.591,.25,1.672)
						o_scene2.rotation = Vector3(deg_to_rad(-90),deg_to_rad(35),0)
					else:
						o_scene3.position = Vector3(0,10,0)
						o_scene3.visible = false
						o_scene2.position = Vector3(0,0,0)
						o_scene2.rotation = Vector3(0,0,0)
		elif object.is_in_group("outlet_scene3") and Global.is_elec:
			if !object.has_method("interact"):
				label.show()
				if Input.is_action_just_pressed("interact"):
					print("scene 3 over, start wire fix")

		'''if object.is_in_group("medicine"):
			if object.is_in_group("amoxicillin"):
				if !object.has_method("interact"):
					med_pick.show()
					if Input.is_action_just_pressed("pick_up"):
						if !Global.pick_item:
							Global.pick_item = true
			if object.is_in_group("penicillin"):
				if !object.has_method("interact"):
					med_pick.show()
					if Input.is_action_just_pressed("pick_up"):
						if !Global.pick_item:
							Global.pick_item = true
			if object.is_in_group("nasal_drop"):
				if !object.has_method("interact"):
					med_pick.show()
					if Input.is_action_just_pressed("pick_up"):
						if !Global.pick_item:
							Global.pick_item = true
		if Global.pick_item:
			if object == npc:
				label.show()
				if Input.is_action_just_pressed("interact"):
					if pick_amox:
						if Global.gave_amox:
							print("already used amoxicillin. throw away.")
							return
						print("used amoxicillin")
						Global.gave_amox = true
					elif pick_peni:
						if Global.gave_peni:
							print("already used penicillin. throw away.")
							return
						print("used penicillin")
						Global.gave_peni = true
					elif pick_nasal:
						if Global.gave_nasal:
							print("already used nasal drops. throw away.")
							return
						print("used nasal drops")
						Global.gave_nasal = true
					return
			elif object != npc:
				if object.is_in_group("trash_doctor"):
					label.show()
					if Input.is_action_just_pressed("interact"):
						if Global.gave_amox:
							pick_amox = false
							Global.gave_amox = false
							Global.pick_item = false
							amoxicillin.global_position = Vector3(0,2.1,15)
							return
						elif Global.gave_peni:
							pick_peni = false
							Global.gave_peni = false
							Global.pick_item = false
							penicillin.global_position = Vector3(2,2,15)
							return
						else:
							if pick_amox:
								print("Amoxicillin is still full")
							elif pick_peni:
								print("Penicillin is still full")
							
		
	
	if Input.is_action_just_pressed("pick_up") and (pick_amox or pick_peni or pick_nasal):
		Global.pick_item = false
	pick_or_drop(object)
	pick_medicine()'''
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
	if Input.is_action_just_pressed("jump") and is_on_floor() and Global.clipboard_info["checkbox_checked"].position.y == 0:
		velocity.y = JUMP_VELOCITY
	
	#doctor inventory selection - select tools for analysis
	var doc_tools = [steth, therm, tongue, gluc, tri]
	var elec_tools = [screw, plier, volt, wire, tape]
	var input_index = ["1","2","3","4","5"]
	if Global.is_doc:
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
	if Global.is_elec:
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
	if Global.clipboard_info["clip_ui"].position.y == 0:
		if direction and $head/camera.current:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
#clipboard animation (pull out/keep back)
func move_clip():
	if Input.is_action_just_pressed("clipboard") and !Global.clipboard_info["is_editing"]:
		if Global.clipboard_info["clip_ui"].position.y == -300:
			Global.clipboard_info["clip_ui"].position.y = 0
		elif Global.clipboard_info["clip_ui"].position.y == 0:
			Global.clipboard_info["clip_ui"].position.y = -300

'''func pick_or_drop(object=null):
	if object == null:
		if !Global.pick_item:
			pick_amox = false
			pick_peni = false
			pick_nasal = false
			return
	if Global.pick_item:
		if pick_peni:
			return
		elif pick_nasal:
			return
		if object == amoxicillin:
			pick_amox = true
		elif object == penicillin:
			pick_peni = true
		elif object == nasal:
			pick_nasal = true
	if !Global.pick_item:
		pick_amox = false
		pick_peni = false
		pick_nasal = false
		return

func pick_medicine():
	if pick_amox:
		amoxicillin.global_position = hand.global_position
		amoxicillin.global_rotation = hand.global_rotation - Vector3(0,0,0.25)
		amoxicillin.linear_velocity = Vector3(0.1,1.5,0.1)
	elif pick_peni:
		penicillin.global_position = hand.global_position
		penicillin.global_rotation = hand.global_rotation - Vector3(0,0,0.25)
		penicillin.linear_velocity = Vector3(0.1,1.5,0.1)
	elif pick_nasal:
		nasal.global_position = hand.global_position
		nasal.global_rotation = hand.global_rotation - Vector3(0,0,0.25)
		nasal.linear_velocity = Vector3(0.1,1.5,0.1)'''

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
