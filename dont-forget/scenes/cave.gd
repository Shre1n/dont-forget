extends Level

@onready var audio_ = $Audio_Stream

func _ready() -> void:
	audio_.play_cave_bg_music()
