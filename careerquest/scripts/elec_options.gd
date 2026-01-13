extends Control

@onready var stars := $"."
@onready var star1 := $"stars/MarginContainer/VBoxContainer/HBoxContainer/1star"
@onready var star3 := $"stars/MarginContainer/VBoxContainer/HBoxContainer/3star"
@onready var star5 := $"stars/MarginContainer/VBoxContainer/HBoxContainer/5star"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	star1.disabled = false
	star3.disabled = false
	star5.disabled = false
	update_stars_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

	update_stars_visibility()

func update_stars_visibility() -> void:
	if Global.is_elec:
		if Global.elec_cond["difficulty"] == null:
			stars.show()
		else:
			stars.hide()
	else:
		stars.hide()
