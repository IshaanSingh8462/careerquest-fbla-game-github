extends Node

var pause_game = null
var mouse_mode = 0 #0=captured, 1=visible


var notify = ""

'''doctor variables'''
var is_doc = false
var doc_tutor = true

#condition
var condition = {"asthma":false, "arthritis":false, "copd":false, "flu":false, "migraine":false,
"diabetes":false, "acid":false, "iron":false, "blood_pressure":false, "temp":0, "sugar":0, "symptoms":""}

var random_symp = false
var repetition = 0
var score = 0

#clipboard
var clipboard_info = {"first":null,"last":null,"dob":null,"gender":null,"clip_ui":null,"checkbox_checked":null,
"clicked":null,"forward":null,"backward":null, "is_editing":null}
var doc_desc = ["Asthma is a long-term condition where the airways become inflamed and narrow, making it hard to breathe. People may experience wheezing, coughing, chest tightness, or shortness of breath, often triggered by exercise, allergens, or cold air.", 
"Arthritis causes inflammation in the joints, leading to pain, stiffness, and swelling. It can make everyday movements difficult and often worsens with age or repeated joint use.", 
"COPD is a progressive lung disease that makes breathing increasingly difficult. It is commonly caused by long-term smoking and includes symptoms like chronic cough and shortness of breath.c", 
"The flu is a contagious viral infection that affects the respiratory system. Common symptoms include fever, chills, body aches, fatigue, and a sore throat.", 
"A migraine is a severe headache often accompanied by nausea, light sensitivity, or visual disturbances. Attacks can last for hours or even days and may be triggered by stress, food, or lack of sleep.",
"Diabetes is a condition where the body has trouble regulating blood sugar levels. This can happen when the body does not make enough insulin or cannot use it effectively.", 
"GERD is a chronic condition where stomach acid frequently flows back into the esophagus. This can cause heartburn, chest discomfort, and irritation of the throat, especially after eating or when lying down.", 
"Iron deficiency occurs when the body does not have enough iron to produce healthy red blood cells. This can lead to fatigue, weakness, and difficulty concentrating.", 
"High blood pressure happens when the force of blood against artery walls is consistently too strong. Over time, it can damage the heart and increase the risk of serious health problems."]

func pick_doc_desc():
	var keys = condition.keys()
	for i in range(keys.size()):
		var key = keys[i]
		if condition[key] == true:
			return doc_desc[i]
	return ""

func get_condition():
	var cond = ["Asthma","Arthritis","Chronic Obstructive Pulmonary Disease (COPD)","Influenza (Flu)","Migraine","Diabetes","Gastroesophageal Reflux 
Disease (GERD)","Iron Deficiency","High Blood Pressure"]
	var keys = condition.keys()
	for i in range(keys.size()):
		var key = keys[i]
		if condition[key]:
			return cond[i]
	return ""

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
var doc_gluc_text = ""

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
var elec_games = false

#switch variables
var open_fusebox = false
var sw_states = [false,false,false,false,false,false,false,false,false,false] #switch is in on/off position
var load_val = [4,5,3,1,3,2,6,6,4,5]
var load_ = 0
var tripped_status = false

#pick options variables (stars, card, etc.)
var elec_location = ["house","coffee_shop","office","basement","factory","apartment"]
var elec_desc = [
  "Electricians install and repair wiring that powers lights, outlets, and appliances. Working with electricity can be dangerous, so they use insulated tools and safety gear to avoid shocks.",
  
  "Circuit breakers protect buildings by automatically shutting off power when too much electricity flows. Without breakers, wires could overheat and cause electrical fires.",
  
  "Wall outlets deliver electricity from your home's wiring to devices like chargers and computers. Overloading an outlet with too many plugs can cause overheating and fire hazards.",
  
  "Ground wires are a key safety feature — they provide a safe path for electricity to travel in case of a fault. This helps prevent electric shock if something goes wrong.",
  
  "Factories use high-voltage equipment that requires industrial electricians. These systems power heavy machines but can be extremely dangerous without proper training and lockout procedures.",
  
  "GFCI outlets (the ones with test/reset buttons) are used in bathrooms and kitchens. They shut off power in milliseconds if they detect current flowing through water or a person."
];
var elec_job_comp = {"breaker":false,"outlet":false,"light":false}
func pick_desc(location):
	if is_doc:
		return
	load_val.shuffle()
	var index = elec_location.find(location)
	if index != -1:
		return elec_desc[index]
	return ""
var random_location = elec_location.pick_random()

var elec_cond = {
	"difficulty": null,
	"location": "apartment", #random_location,
	"desc": pick_desc(random_location),
	"load_limit":null
}# difficulty: 1-star, 3-star, 5-star; 

func calc_load():
	load_ = 0
	var load_limits = [15, 22, 29]

	# Calculate load
	for i in range(10):
		if sw_states[i]:
			load_ += load_val[i]
	var limit = load_limits[elec_cond["difficulty"]]
	elec_cond["load_limit"] = limit
	# Breaker logic
	if tripped_status:
		# Breaker is already tripped → only reset if load is zero
		if load_ == 0:
			tripped_status = false
	else:
		# Breaker is NOT tripped → check if it should trip
		if load_ > limit:
			tripped_status = true

#changes state of fusebox switches
func sw_num(i):
	sw_states[i] = !sw_states[i]

#outlet variables
var outlet = {"is_case_removed":false,"is_unplugged":false,"is_fixed":false}

'''Pick Items'''
var pick_item = false
