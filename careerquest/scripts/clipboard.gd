extends Control

#creates reference nodes
@onready var confirm_button :=$prescriptions/MarginContainer/confirm

@onready var first_name := $info/MarginContainer/VBoxContainer2/HBoxContainer/first_name
@onready var last_name := $info/MarginContainer/VBoxContainer2/HBoxContainer/last_name
@onready var dob := $info/MarginContainer/VBoxContainer2/VBoxContainer/dob
@onready var gender := $info/MarginContainer/VBoxContainer2/VBoxContainer/gender
@onready var presc_plyr := $prescriptions/MarginContainer/VBoxContainer/presc
@onready var info := $info
@onready var page1 := $page1
@onready var page2 := $page2
@onready var presc := $prescriptions
@onready var forward := $forward
@onready var backward := $backward
#symptoms
@onready var short_breath := $"page1/MarginContainer/VBoxContainer/short breath"
@onready var chest_pain := $"page1/MarginContainer/VBoxContainer/chest pain"
@onready var joint_pain := $"page1/MarginContainer/VBoxContainer/joint pain"
@onready var swell := $page1/MarginContainer/VBoxContainer/swelling
@onready var cough := $page1/MarginContainer/VBoxContainer/cough
@onready var sore_throat := $"page1/MarginContainer/VBoxContainer/sore throat"
@onready var headache := $page1/MarginContainer/VBoxContainer/headache
@onready var nausea := $page2/MarginContainer/VBoxContainer/nausea
@onready var vomit := $page2/MarginContainer/VBoxContainer/vomit
@onready var urination := $page2/MarginContainer/VBoxContainer/urination
@onready var dizzy := $page2/MarginContainer/VBoxContainer/dizzy
@onready var fever := $page2/MarginContainer/VBoxContainer/fever
@onready var fatigue := $page2/MarginContainer/VBoxContainer/fatigue
@onready var thirst_hunger := $page2/MarginContainer/VBoxContainer/thirst_hunger

# Called when the node enters the scene tree for the first time.
func _ready():
	confirm_button.disabled = true
	Global.clipboard_info["clip_ui"] = self
	Global.clipboard_info["checkbox_checked"] = self
	page1.hide()
	page2.hide()
	presc.hide()
	Global.clipboard_info["is_editing"] = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	#if the npc is leaving the room, then the player cannot enter another clipboard entry
	if Global.move:
		confirm_button.disabled = false
	submit()
	button_visible()
	Global.clipboard_info["first"] = first_name.text.to_lower()
	Global.clipboard_info["last"] = last_name.text.to_lower()
	Global.clipboard_info["dob"] = dob.text
	Global.clipboard_info["gender"] = gender.text.to_lower()
	#switch pages on clipboard
	if Global.clipboard_info["forward"]:
		if info.visible:
			info.hide()
			page1.show()
			Global.clipboard_info["forward"] = false
		elif page1.visible:
			page1.hide()
			page2.show()
			Global.clipboard_info["forward"] = false
		elif page2.visible:
			page2.hide()
			presc.show()
			Global.clipboard_info["forward"] = false
	if Global.clipboard_info["backward"]:
		if presc.visible:
			presc.hide()
			page2.show()
			Global.clipboard_info["backward"] = false
		elif page2.visible:
			page2.hide()
			page1.show()
			Global.clipboard_info["backward"] = false
		elif page1.visible:
			page1.hide()
			info.show()
			Global.clipboard_info["backward"] = false

#when 'confirm' button pressed on clipboard, reset clipboard values and timer
func submit():
	if Global.clipboard_info["clicked"] == true:
		var str = presc_plyr.text.to_lower()
		timer_scoring()
		presc_check(str)
		checkbox_checker()
		first_name.text = ""
		last_name.text = ""
		dob.text = ""
		gender.text = ""
		presc_plyr.text = ""
		Global.clipboard_info["clicked"] = null
		Global.timer = false
		print(Global.timer_info)

#makes forward/backward buttons visible/hidden when certain page was open
func button_visible():
	if info.visible:
		backward.hide()
	else:
		backward.show()
	if presc.visible:
		forward.hide()
	else:
		forward.show()

#grades player checkbox input based on condition, also totals points after 5 rounds
func checkbox_checker():
	if Global.condition["asthma"]:
		if short_breath.button_pressed:
			Global.score += 50
		if chest_pain.button_pressed:
			Global.score += 50
		if (joint_pain.button_pressed or swell.button_pressed or cough.button_pressed or sore_throat.button_pressed or headache.button_pressed or 
			nausea.button_pressed or vomit.button_pressed or urination.button_pressed or dizzy.button_pressed or fever.button_pressed or fatigue.button_pressed or thirst_hunger.button_pressed):
			Global.score -= 25
	if Global.condition["arthritis"]:
		if joint_pain.button_pressed:
			Global.score += 50
		if swell.button_pressed:
			Global.score += 50
		if (short_breath.button_pressed or chest_pain.button_pressed or cough.button_pressed or sore_throat.button_pressed or headache.button_pressed or 
			nausea.button_pressed or vomit.button_pressed or urination.button_pressed or dizzy.button_pressed or fever.button_pressed or 
			fatigue.button_pressed or thirst_hunger.button_pressed):
			Global.score -= 25
	if Global.condition["flu"]:
		if fever.button_pressed:
			Global.score += 50
		if cough.button_pressed:
			Global.score += 50
		if sore_throat.button_pressed:
			Global.score += 50
		if headache.button_pressed:
			Global.score += 50
		if fatigue.button_pressed:
			Global.score += 50
		if (short_breath.button_pressed or chest_pain.button_pressed or joint_pain.button_pressed or 
			swell.button_pressed or nausea.button_pressed or vomit.button_pressed or urination.button_pressed or dizzy.button_pressed or thirst_hunger.button_pressed):
			Global.score -= 25
	if Global.condition["copd"]:
		if cough.button_pressed:
			Global.score += 50
		if short_breath.button_pressed:
			Global.score += 50
		if fatigue.button_pressed:
			Global.score += 50
		if chest_pain.button_pressed:
			Global.score += 50
		if (joint_pain.button_pressed or swell.button_pressed or sore_throat.button_pressed or headache.button_pressed or nausea.button_pressed or vomit.button_pressed
			 or urination.button_pressed or dizzy.button_pressed or fever.button_pressed or thirst_hunger.button_pressed):
			Global.score -= 25
	if Global.condition["migraine"]:
		if headache.button_pressed:
			Global.score += 50
		if nausea.button_pressed:
			Global.score += 50
		if vomit.button_pressed:
			Global.score += 50
		if (short_breath.button_pressed or chest_pain.button_pressed or joint_pain.button_pressed or 
			swell.button_pressed or cough.button_pressed or sore_throat.button_pressed or urination.button_pressed or dizzy.button_pressed or fever.button_pressed or 
			fatigue.button_pressed or thirst_hunger.button_pressed):
			Global.score -= 25
	if Global.condition["diabetes"]:
		if urination.button_pressed:
			Global.score += 50
		if fatigue.button_pressed:
			Global.score += 50
		if thirst_hunger.button_pressed:
			Global.score += 50
		if (short_breath.button_pressed or chest_pain.button_pressed or joint_pain.button_pressed or 
			swell.button_pressed or cough.button_pressed or sore_throat.button_pressed or headache.button_pressed or 
			nausea.button_pressed or vomit.button_pressed or dizzy.button_pressed or fever.button_pressed):
			Global.score -= 25
	if Global.condition["acid"]:
		if chest_pain.button_pressed:
			Global.score += 50
		if cough.button_pressed:
			Global.score += 50
		if sore_throat.button_pressed:
			Global.score == 50
		if (short_breath.button_pressed or joint_pain.button_pressed or swell.button_pressed or 
		headache.button_pressed or nausea.button_pressed or vomit.button_pressed or urination.button_pressed 
		or dizzy.button_pressed or fever.button_pressed or fatigue.button_pressed or thirst_hunger.button_pressed):
			Global.score -= 25
	if Global.condition["iron"]:
		if short_breath.button_pressed:
			Global.score += 50
		if fatigue.button_pressed:
			Global.score += 50
		if dizzy.button_pressed:
			Global.score == 50
		if (chest_pain.button_pressed or joint_pain.button_pressed or 
			swell.button_pressed or cough.button_pressed or sore_throat.button_pressed or headache.button_pressed or 
			nausea.button_pressed or vomit.button_pressed or urination.button_pressed or fever.button_pressed or thirst_hunger.button_pressed):
			Global.score -= 25
	if Global.condition["blood_pressure"]:
		if headache.button_pressed:
			Global.score += 50
		if dizzy.button_pressed:
			Global.score == 50
		if (short_breath.button_pressed or chest_pain.button_pressed or joint_pain.button_pressed or 
			swell.button_pressed or cough.button_pressed or sore_throat.button_pressed or
			nausea.button_pressed or vomit.button_pressed or urination.button_pressed or fever.button_pressed or 
			fatigue.button_pressed or thirst_hunger.button_pressed):
			Global.score -= 25
	remove_check()
	print(Global.score)
	if Global.repetition == 5:
		print()
		print("Total Score: " + str(Global.score))

#resets all checkboxes
func remove_check():
	short_breath.button_pressed = false
	chest_pain.button_pressed = false
	joint_pain.button_pressed = false
	swell.button_pressed = false
	cough.button_pressed = false
	sore_throat.button_pressed = false
	headache.button_pressed = false
	nausea.button_pressed = false
	vomit.button_pressed = false
	urination.button_pressed = false
	dizzy.button_pressed = false
	fever.button_pressed = false
	fatigue.button_pressed = false
	thirst_hunger.button_pressed = false

#adds to score based on time it took to complete diagnosis
func timer_scoring():
	var minu = Global.timer_info[0] * 60
	var sec = Global.timer_info[1]
	sec += minu
	if sec <= 90:
		Global.score += 20
	elif sec > 90 and sec <= 120:
		Global.score += 30
	elif (minu >= 2 and sec >= 30):
		Global.score += 10

func presc_check(str):
	var presc = {"asthma":["inhaler"], "arthritis":["corticosteroids", "dmard"], "flu":["antiviral", "pain relievers"], "copd":["inhaled bronchodilators"], "migraine":["triptans", "antiemetics",
	 "beta-blockers", "anticonvulsant"], "diabetes":["metformin", "sulfonylureas"], "acid":["proton pump", "inhibitors", "ppi", "h2 blockers"], "iron":["iron supplements"], "blood_pressure":["ace inhibitors", "beta-blockers"]}
	for condition in presc.keys():
		if Global.condition[condition]:  # check if condition is active
			for keyword in presc[condition]:
				if str.find(keyword) != -1:
					Global.score += 50
					break  # stop after first match for this condition

'''func text_input():
	if Input.is_action_just_pressed("pick_up"):
		if Global.clipboard_info["is_editing"]:
			print("pick up")
			first_name.release_focus()
			Global.clipboard_info["is_editing"] = false
func _on_first_name_focus_entered() -> void:
	Global.clipboard_info["is_editing"] = true
	print("enter")

func _on_first_name_focus_exited() -> void:
	Global.clipboard_info["is_editing"] = false
	print("exit")'''

#signals for buttons
func _on_forward_pressed() -> void:
	Global.clipboard_info["forward"] = true

func _on_backward_pressed() -> void:
	Global.clipboard_info["backward"] = true

func _on_confirm_pressed() -> void:
	Global.clipboard_info["clicked"] = true
	confirm_button.disabled = true
