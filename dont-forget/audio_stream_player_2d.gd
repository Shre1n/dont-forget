class_name Audio_Stream extends AudioStreamPlayer2D

var audio: AudioStreamPlayer2D = self

var user_prefs: UserPreferences

@export var bg_music: AudioStream

## All MC Sounds

## All NPC Sounds

## All Enemy Sounds

## All Objects

@export var button_sound: AudioStream

func _ready():
	user_prefs = UserPreferences.load_or_create()
	set_volume_based_on_preferences()

	
func set_volume_based_on_preferences():
	var volume_db = user_prefs.volume_to_db()
	audio.volume_db = volume_db
	print("Lautstärke aus dB gesetzt: ", volume_db)

func play_village_bg_music():
	stop_music()
	play_audio(bg_music)
	audio.bus = &"Village"
	
func play_cave_bg_music():
	stop_music()
	play_audio(bg_music)
	audio.bus = &"Cave"

func play_turorial_bg_music():
	stop_music()
	play_audio(bg_music)
	audio.bus = &"tutorial"
	
func button_audio():
	play_audio(button_sound)
	
func stop_music():
	audio.stop()  # Stoppt die aktuell abgespielte Musik

func change_music(new_music: AudioStream):
	stop_music()
	play_audio(new_music)

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream
	audio.stream_paused = false
	audio.play()
