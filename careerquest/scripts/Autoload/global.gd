extends Node

'''doctor variables'''
var is_doc = false

#condition
var condition = {"asthma":false, "arthritis":false, "copd":false, "flu":false, "migraine":false,
"diabetes":false, "acid":false, "iron":false, "blood_pressure":false, "temp":0, "sugar":0}

var random_symp = false
var repetition = 0
var score = 0

#clipboard
var clipboard_info = {"first":null,"last":null,"dob":null,"gender":null,"clip_ui":null,"checkbox_checked":null,
"clicked":null,"forward":null,"backward":null, "is_editing":null}

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

var active_tool = -1

#starts doctor functions
func interact():
	move = true
	at_start = false
	random_symp = true
	timer = true
	is_doc = true
	
'''Electric Variables'''
var is_elec = false

#switch variables
var open_fusebox = false
var sw_states = [true,true,true,true,true,true,true,true,true,true] #true = switch is in 'on' position
var load_val = [4,5,3,1,3,2,6,6,4,5]
var load = 0
var fuse_states = [true,true,true,true,true,true,true,true,true,true] #true = switch not tripped

func calc_load():
	load = 0
	for i in range(10):
		if fuse_states[i]:
			load += load_val[i]
	print("current load: " + str(load))

#changes state of fusebox switches
func sw_num(i):
	sw_states[i] = !sw_states[i]
	if sw_states[i] and !fuse_states[i]:
		fuse_states[i] = true
	print(str(i+1) + " is " + str(sw_states[i]) + " and tripped status is " + str(fuse_states[i]))

'''Pick Items'''
var pick_item = false
