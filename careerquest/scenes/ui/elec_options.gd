extends Control

@onready var stars := $stars
@onready var star1 := $"stars/MarginContainer/VBoxContainer/HBoxContainer/1star"
@onready var star3 := $"stars/MarginContainer/VBoxContainer/HBoxContainer/3star"
@onready var star5 := $"stars/MarginContainer/VBoxContainer/HBoxContainer/5star"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	star1.disabled = false
	star3.disabled = false
	star5.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stars.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	stars.hide()
	if Global.is_elec:
		stars.show()
		if Global.elec_cond["difficulty"] != null:
			stars.hide()


func _on_star_pressed() -> void:
	Global.elec_cond["difficulty"] = 0

func _on_star5_pressed() -> void:
	Global.elec_cond["difficulty"] = 1

func _on_star3_pressed() -> void:
	Global.elec_cond["difficulty"] = 2
