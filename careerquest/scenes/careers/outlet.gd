extends Node3D

@export var outlet_id: int = 0

@onready var case := $case
@onready var plug := $plug
@onready var wiring := $wiring

func remove_case():
	if Global.active_tool != 0:
		print("use a screwdriver")
		return
	if Global.outlet["is_case_removed"]:
		Global.outlet["is_case_removed"] = false
		case.position = Vector3(0,1.331,.08)
		case.rotation = Vector3(0,0,0)
		print("Case attached on outlet ", outlet_id)
	elif !Global.outlet["is_case_removed"]:
		Global.outlet["is_case_removed"] = true
		case.position = Vector3(-.55,.275,1)
		case.rotation = Vector3(deg_to_rad(90),deg_to_rad(-35),0)
		print("Case removed on outlet ", outlet_id)

func unplug():
	if Global.active_tool != 0:
		print("use a screwdriver")
		return
	if Global.outlet["is_unplugged"]:
		Global.outlet["is_unplugged"] = false
		plug.position = Vector3(0,0,0)
		plug.rotation = Vector3(0,0,0)
		print("Plug attached on outlet ", outlet_id)
	elif !Global.outlet["is_unplugged"]:
		Global.outlet["is_unplugged"] = true
		plug.position = Vector3(1.591,.25,1.672)
		plug.rotation = Vector3(deg_to_rad(-90),deg_to_rad(35),0)
		print("Plug removed on outlet ", outlet_id)

func fix_wiring():
	if Global.active_tool != 0:
		print("use a screwdriver")
		return
	Global.outlet["is_fixed"] = true
	print("Outlet fixed! ", outlet_id)
	Global.elec_job_comp["outlet"] = true

func reset():
	pass
