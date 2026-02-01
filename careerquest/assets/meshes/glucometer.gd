extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sketchfab_model/f62be4c7b6b54685a19d6599e28acd17_fbx/RootNode/lcd.hide()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Sketchfab_model/f62be4c7b6b54685a19d6599e28acd17_fbx/RootNode/glass/glass_screen_0/Sprite3D/SubViewport/VBoxContainer/Label.text = str(Global.doc_gluc_text)
