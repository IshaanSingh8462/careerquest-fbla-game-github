extends Node3D

class_name Outlet

@export var outlet_id:int

@onready var case := $case
@onready var plug := $plug
@onready var wiring := $wiring
@onready var outlet_ui := $CanvasLayer/outlet_game
@onready var wire1 := $CanvasLayer/outlet_game/MarginContainer/VBoxContainer/wire1
@onready var wire2 := $CanvasLayer/outlet_game/MarginContainer/VBoxContainer/wire2
@onready var wire_full := $CanvasLayer/outlet_game/wire_full
@onready var wire_blue_cut := $CanvasLayer/outlet_game/wire_blue_cut
@onready var wire_red_cut := $CanvasLayer/outlet_game/wire_red_cut
@onready var wire_cut := $CanvasLayer/outlet_game/wire_cut

var outlet = {"is_case_removed":false,"is_unplugged":false,"is_fixed":false}

func _ready() -> void:
	outlet_ui.hide()

func _process(_delta: float) -> void:
	if outlet_ui.visible:
		Global.mouse_mode = 1
	if wire_cut.visible:
		outlet_ui.hide()

func remove_case():
	if Global.active_tool != 0:
		if Global.score > 5:
			Global.score -= 5
		Global.notification = "Ow! Use a screwdriver to disasemble the outlet. -5 points"
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
		case.position = Vector3(-.55,.5,1)
		case.rotation = Vector3(deg_to_rad(90),deg_to_rad(-35),0)
		print("Case removed on outlet ", outlet_id)
	print(Global.score)

func unplug():
	if Global.active_tool != 0:
		if Global.score > 5:
			Global.score -= 5
		Global.notification = "Ow! Use a screwdriver to disasemble the outlet. -5 points"
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
		plug.position = Vector3(1.591,.45,1.672)
		plug.rotation = Vector3(deg_to_rad(-90),deg_to_rad(35),0)
		print("Plug removed on outlet ", outlet_id)
	print(Global.score)

func fix_wiring():
	if outlet["is_fixed"]:
		Global.notification = "Outlet already fixed!"
		await get_tree().create_timer(2.0).timeout
		Global.notification = ""
		return
	if Global.active_tool != 1 and !wire_cut.visible:
		if Global.score > 5:
			Global.score -= 5
		Global.notification = "Ow! Use a plier to access the wires. -5 points"
		await get_tree().create_timer(2.0).timeout
		Global.notification = ""
		return
	outlet_ui.show()
	if wire_cut.visible:
		if Global.active_tool != 2:
			Global.notification = "Ow! Use tape to fix the wire. -5 points"
			await get_tree().create_timer(2.0).timeout
			Global.notification = ""
			return
		if !outlet["is_fixed"]:
			Global.score += 50
		outlet["is_fixed"] = true
		Global.notification = "Outlet fixed! " + str(outlet_id) + " +50 points"
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
	wire_full.show()
	wire_red_cut.hide()
	wire_blue_cut.hide()
	wire_cut.hide()

func _on_wire_1_pressed() -> void:
	wire_full.hide()
	if wire_blue_cut.visible:
		wire_cut.show()
	else:
		wire_red_cut.show()

func _on_wire_2_pressed() -> void:
	wire_full.hide()
	if wire_red_cut.visible:
		wire_cut.show()
	else:
		wire_blue_cut.show() # Replace with function body.
