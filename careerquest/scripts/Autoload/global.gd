extends Node

'''doctor variables'''
var is_doc = true

#condition
var condition = {"asthma":false, "arthritis":false, "copd":false, "flu":false, "migraine":false,
	"diabetes":false, "acid":false, "iron":false, "blood_pressure":false}

var gave_amox = null
var gave_peni = null
var gave_nasal = null

var random_symp = false
var repetition = 0
var score = 0

#clipboard
var clipboard_ui = null
var glob_first_name = null
var glob_last_name = null
var glob_dob = null
var glob_gender = null
var checkbox_checked = null

var clicked = null
var forward = null
var backward = null
var info = null
var physical = null
var systematic = null

var move = false
var submit = false
var at_start = true

#book
var flip_book_anim = null
var escape_doctor_button = null
var doc_forward = null
var doc_backward = null

#timer
var timer = null
var timer_info = [0,0]

#npc dialogue
var is_talking = false
var ask_name = false
var ask_feel = false

#starts doctor functions
func interact():
	move = true
	at_start = false
	random_symp = true
	timer = true
	
'''Electric Variables'''
var is_elec = false

#switch variables
var open_fusebox = false
var sw_states = [true,true,true,true,true,true,true,true,true,true]

#changes state of fusebox switches
func sw_num(i):
	sw_states[i] = !sw_states[i]
	print(str(i+1) + " is " + str(sw_states[i]))

'''Pick Items'''
var pick_item = false
