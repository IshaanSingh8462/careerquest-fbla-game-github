extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Example: Fading out over 2 seconds
func fade_out_music(stream_player: AudioStreamPlayer):
	var tween = create_tween()
	# Interpolate volume_db from current to -80 (silent)
	tween.tween_property(stream_player, "volume_db", -80.0, 3.0)
	# Connect signal to stop music when finished
	tween.finished.connect(stream_player.stop)
	# Optional: Reset volume to 0 for future playback
	tween.finished.connect(func(): stream_player.volume_db = 0.0)
	stream_paused = true

# In AudioManager.gd
func play_music(stream_player: AudioStreamPlayer):
	volume_db = 0.0
	stream_player.stream_paused = false
	stream_player.play()
