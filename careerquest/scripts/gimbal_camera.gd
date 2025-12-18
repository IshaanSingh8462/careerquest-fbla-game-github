extends Node3D

var ROTATION_SPEED = PI/2

@onready var inner := $inner
@onready var ray := $"../ray"
@onready var camera := $inner/camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Global.is_elec:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_input(delta)
		inner.rotation.x = clamp(inner.rotation.x, -.67, .67)
		rotation.y = clamp(rotation.y, -.67, .67)
		var mouse_pos = get_viewport().get_mouse_position()
		var space_state = get_world_3d().direct_space_state
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_direction = camera.project_ray_normal(mouse_pos) # Normalized direction
		var ray_length = 100.0 # Or however far you want the ray to go	
		var ray_end = ray_origin + ray_direction * ray_length
		
		# Perform the raycast
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		# If you need to hit Areas: query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		
		if result:
			print("Hit something at: ", result.position)
		else:
			# print("Nothing hit")
			print("nope")

func get_input(delta):
	#rotate outer gimbal around y-axis
	var y_rot = 0
	if Input.is_action_pressed("right"):
		y_rot += 1
	if Input.is_action_pressed("left"):
		y_rot -= 1
	rotate_object_local(Vector3.UP, y_rot * ROTATION_SPEED * delta)
	
	#rotate inner gimbal around x-axis
	var x_rot = 0
	if Input.is_action_pressed("backward"):
		x_rot += 1
	if Input.is_action_pressed("forward"):
		x_rot -= 1
	inner.rotate_object_local(Vector3.RIGHT, x_rot * ROTATION_SPEED * delta)
