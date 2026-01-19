extends Node3D

class_name Outlet

@export var outlet_id:int

@onready var case := $case
@onready var plug := $plug
@onready var wiring := $wiring
@onready var outlet_ui := $CanvasLayer/outlet_game
@onready var wire1 := $CanvasLayer/outlet_game/MarginContainer/VBoxContainer/Control/wire1
@onready var wire2 := $CanvasLayer/outlet_game/MarginContainer/VBoxContainer/Control2/wire2


var outlet = {"is_case_removed":false,"is_unplugged":false,"is_fixed":false}

func _ready() -> void:
	outlet_ui.hide()

func _process(_delta: float) -> void:
	if outlet_ui.visible:
		Global.mouse_mode = 1
	if !wire1.visible and !wire2.visible:
		outlet_ui.hide()

func remove_case():
	if Global.active_tool != 0:
		if Global.score > 5:
			Global.score -= 5
		Global.notification = "Ow! Use a screwdriver."
		await get_tree().create_timer(2.0).timeout
		Global.notification = ""
		return
	if outlet["is_case_removed"]:
		if outlet["is_unplugged"]:
			Global.notification = "fix plug first"
			await get_tree().create_timer(2.0).timeout
			Global.notification = ""
			return
		outlet["is_case_removed"] = false
		case.position = Vector3(0,1.331,.08)
		case.rotation = Vector3(0,0,0)
		print("Case attached on outlet ", outlet_id)
	elif !outlet["is_case_removed"]:
		outlet["is_case_removed"] = true
		case.position = Vector3(-.55,.275,1)
		case.rotation = Vector3(deg_to_rad(90),deg_to_rad(-35),0)
		print("Case removed on outlet ", outlet_id)
	print(Global.score)

func unplug():
	if Global.active_tool != 0:
		if Global.score > 5:
			Global.score -= 5
		Global.notification = "Ow! Use a screwdriver."
		await get_tree().create_timer(2.0).timeout
		Global.notification = ""
		return
	if outlet["is_unplugged"]:
		outlet["is_unplugged"] = false
		plug.position = Vector3(0,0,0)
		plug.rotation = Vector3(0,0,0)
		print("Plug attached on outlet ", outlet_id)
	elif !outlet["is_unplugged"]:
		outlet["is_unplugged"] = true
		plug.position = Vector3(1.591,.25,1.672)
		plug.rotation = Vector3(deg_to_rad(-90),deg_to_rad(35),0)
		print("Plug removed on outlet ", outlet_id)
	print(Global.score)

func fix_wiring():
	if Global.active_tool != 1:
		if Global.score > 5:
			Global.score -= 5
		Global.notification = "Ow! Use a wrench."
		await get_tree().create_timer(2.0).timeout
		Global.notification = ""
		return
	outlet_ui.show()
	if !wire1.visible and !wire2.visible:
		if !outlet["is_fixed"]:
			Global.score += 50
		outlet["is_fixed"] = true
		Global.notification = "Outlet fixed! " + str(outlet_id)
		await get_tree().create_timer(2.0).timeout
		Global.notification = ""
	print(Global.score)

func reset():
	case.position = Vector3(0,1.331,.08)
	case.rotation = Vector3(0,0,0)
	plug.position = Vector3(0,0,0)
	plug.rotation = Vector3(0,0,0)
	outlet["is_case_removed"] = false
	outlet["is_unplugged"] = false
	outlet["is_fixed"] = false
	wire1.show()
	wire2.show()

func _on_wire_1_pressed() -> void:
	wire1.hide() # Replace with function body.

func _on_wire_2_pressed() -> void:
	wire2.hide() # Replace with function body.
