extends Node

var pause_game = null
var mouse_mode = 0 #0=captured, 1=visible

'''doctor variables'''
var is_doc = false
var doc_tutor = true

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
var doc_therm_text = ""

#starts doctor functions
func interact():
	move = true
	at_start = false
	random_symp = true
	timer = true
	is_doc = true


'''Electric Variables'''
var is_elec = false
var elec_tutor = true

#switch variables
var open_fusebox = false
var sw_states = [false,false,false,false,false,false,false,false,false,false] #switch is in on/off position
var load_val = [4,5,3,1,3,2,6,6,4,5]
@warning_ignore("shadowed_global_identifier")
var load = 0
var tripped_status = false

#pick options variables (stars, card, etc.)
var elec_location = ["house","coffee_shop","office","traffic_light","factory","apartment"]
var elec_desc = ["house desc", "coffee_shop desc","office desc","traffic_light desc","factory desc","apartment desc"]
var elec_job_comp = {"breaker":false,"outlet":false,"light":false}
func pick_desc(location):
	load_val.shuffle()
	var index = elec_location.find(location)
	if index != -1:
		return elec_desc[index]
	return ""
var random_location = elec_location.pick_random()

var elec_cond = {
	"difficulty": null,
	"location": random_location,
	"desc": pick_desc(random_location),
	"load_limit":null
}# difficulty: 1-star, 3-star, 5-star; 

func calc_load():
	load = 0
	var load_limits = [29, 22, 15]

	# Calculate load
	for i in range(10):
		if sw_states[i]:
			load += load_val[i]
	var limit = load_limits[elec_cond["difficulty"]]
	elec_cond["load_limit"] = limit
	# Breaker logic
	if tripped_status:
		# Breaker is already tripped → only reset if load is zero
		if load == 0:
			tripped_status = false
	else:
		# Breaker is NOT tripped → check if it should trip
		if load > limit:
			tripped_status = true

#changes state of fusebox switches
func sw_num(i):
	sw_states[i] = !sw_states[i]

#outlet variables
var outlet = {"is_case_removed":false,"is_unplugged":false,"is_fixed":false}

'''Pick Items'''
var pick_item = false
