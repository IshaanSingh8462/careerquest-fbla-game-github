extends Node3D

class_name Outlet

@export var outlet_id:int

@onready var case := $case
@onready var plug := $plug
@onready var wiring := $wiring

var outlet = {"is_case_removed":false,"is_unplugged":false,"is_fixed":false}

func remove_case():
	if Global.active_tool != 0:
		print("use a screwdriver")
		return
	if outlet["is_case_removed"]:
		if outlet["is_unplugged"]:
			print("fix plug first")
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

func unplug():
	if Global.active_tool != 0:
		print("use a screwdriver")
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

func fix_wiring():
	if Global.active_tool != 0:
		print("use a screwdriver")
		return
	outlet["is_fixed"] = true
	print("Outlet fixed! ", outlet_id)

func reset():
	case.position = Vector3(0,1.331,.08)
	case.rotation = Vector3(0,0,0)
	plug.position = Vector3(0,0,0)
	plug.rotation = Vector3(0,0,0)
	outlet["is_case_removed"] = false
	outlet["is_unplugged"] = false
	outlet["is_fixed"] = false
	
