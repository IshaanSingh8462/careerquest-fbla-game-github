extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$therm_on_bad.hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Sprite3D/SubViewport/Label.text = Global.doc_therm_text
	if int($Sprite3D/SubViewport/Label.text) > 99:
		$therm_on_bad.show()
		$Sketchfab_model.hide()
	else:
		$therm_on_bad.hide()
		$Sketchfab_model.show()
