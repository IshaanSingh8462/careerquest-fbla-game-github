extends CharacterBody3D

#constants
const SPEED = 7.5
const JUMP_VELOCITY = 6.0

#pick item variables
@onready var head := $head
@onready var camera := $head/camera
@onready var ray := $head/camera/ray
@onready var hand := $head/camera/hand

#doctor ui variables
@onready var label := $CanvasLayer/Interact/interact_button
@onready var book := $CanvasLayer/Book/book
@onready var book_ui := $CanvasLayer/book_ui
@onready var mei := $CanvasLayer/book_ui/mei
@onready var strep := $CanvasLayer/book_ui/strep
@onready var stomach := $CanvasLayer/book_ui/stomach
@onready var cold := $CanvasLayer/book_ui/cold
@onready var croup := $CanvasLayer/book_ui/croup
@onready var pink_eye := $CanvasLayer/book_ui/pink_eye
@onready var hfmd := $CanvasLayer/book_ui/hfmd
@onready var forward := $CanvasLayer/book_ui/buttons/forward
@onready var backward := $CanvasLayer/book_ui/buttons/backwards
@onready var player_dia := $CanvasLayer/player_dialogue_main
@onready var player_dia_exit := $CanvasLayer/player_dialogue_main/MarginContainer/vbox/VBoxContainer2/exit

@onready var electric = get_node("/root/main/electric_wall")

@onready var doc_npc = get_node("/root/main/npc")

# Called when the node enters the scene tree for the first time.
func _ready():
	player_dia.hide()
	
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
						Global.interact()
		else:
			#allows talking to doctor npc
			if object == doc_npc:
				if !object.has_method("interact"):
					label.show()
					if Input.is_action_just_pressed("interact"):
						Global.is_talking = true
		#opens doctor book for medications
		if object.is_in_group("book"):
			if !object.has_method("interact"):
				book.show()
				if Input.is_action_just_pressed("interact"):
					Global.flip_book_anim = true
		#
		if object.is_in_group("doctor_presc"):
			if !object.has_method("interact"):
				label.show()
				if Input.is_action_just_pressed("interact"):
					print("give prescription")

		#starts electrician roleplay
		if object.is_in_group("electrician_start"):
			if !object.has_method("interact"):
					label.show()
					if Input.is_action_just_pressed("interact"):
						Global.is_elec = true
						print("elec start")
		#eopens lectrician switchboard function
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
	if mei.visible:
		backward.hide()
	else:
		backward.show()
	if hfmd.visible:
		forward.hide()
	else:
		forward.show()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and Global.clipboard_info["checkbox_checked"].position.y == 0:
		velocity.y = JUMP_VELOCITY

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
	if Input.is_action_just_pressed("clipboard"):
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
	if Global.flip_book_anim:
		book_ui.show()
		if Global.escape_doctor_button:
			book_ui.hide()
			Global.escape_doctor_button = false
			Global.flip_book_anim = false
		if Global.doc_forward:
			if mei.visible:
				mei.hide()
				strep.show()
			elif strep.visible:
				strep.hide()
				stomach.show()
			elif stomach.visible:
				stomach.hide()
				cold.show()
			elif cold.visible:
				cold.hide()
				croup.show()
			elif croup.visible:
				croup.hide()
				pink_eye.show()
			elif pink_eye.visible:
				pink_eye.hide()
				hfmd.show()
			Global.doc_forward = false
		if Global.doc_backward:
			if strep.visible:
				strep.hide()
				mei.show()
			elif stomach.visible:
				stomach.hide()
				strep.show()
			elif cold.visible:
				cold.hide()
				stomach.show()
			elif croup.visible:
				croup.hide()
				cold.show()
			elif pink_eye.visible:
				pink_eye.hide()
				croup.show()
			elif hfmd.visible:
				hfmd.hide()
				pink_eye.show()
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
