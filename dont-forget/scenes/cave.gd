extends Level

@onready var bg_audio_ := $AudioStreamPlayer


func _ready() -> void:
	bg_audio_.play()
