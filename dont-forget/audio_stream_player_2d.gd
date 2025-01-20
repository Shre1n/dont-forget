class_name AudioManager extends AudioStreamPlayer2D

var audio: AudioStreamPlayer2D = self

var user_prefs: UserPreferences

@export var bg_music: AudioStream

## All MC Sounds

@export var mc_dash_sound: AudioStream
@export var mc_hit_sound: AudioStream
@export var mc_jump_sound: AudioStream
@export var mc_is_hit_sound: AudioStream
@export var mc_walk: AudioStream

## All NPC Sounds

@export var eule_sound: AudioStream
@export var kaefer_sound: AudioStream
@export var lucky_pete_frog: AudioStream
@export var lucky_pete_money: AudioStream
@export var maulwurf: AudioStream

## All Enemy Sounds

## Fly
@export var fly_sound: AudioStream
@export var fly_hit_sound: AudioStream

## Hide
@export var hide_death_sound: AudioStream
@export var hide_damage: AudioStream

## Slime
@export var slime_move: AudioStream
@export var slime_death: AudioStream

## Drexus

@export var drexus_hit: AudioStream
@export var drexus_jump: AudioStream
@export var drexus_scream: AudioStream
@export var drexus_step: AudioStream
@export var drexus_armor: AudioStream

## All Objects



@export var button_sound: AudioStream
@export var bag_sound: AudioStream
@export var break_box_sound: AudioStream
@export var coins_sound: AudioStream
@export var Cutscene_book_sound: AudioStream
@export var drumstick_sound: AudioStream
@export var gong_sound: AudioStream
@export var kristall_sound: AudioStream
@export var leaves_sound: AudioStream
@export var popUp_sound: AudioStream
@export var ringe_sound: AudioStream
@export var spawner_sound: AudioStream
@export var teleporter_sound: AudioStream
@export var trap_sound: AudioStream
@export var uhr_sound: AudioStream

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
	
	
#func mc_dash_audio():
	#play_audio(mc_dash_sound)
#
#func mc_hit_audio():
	#play_audio(mc_hit_sound)
#
#func mc_jump_audio():
	#play_audio(mc_jump_sound)
#
#func mc_is_hit_audio():
	#play_audio(mc_is_hit_sound)
#
#func mc_walk_audio():
	#play_audio(mc_walk)
#
## All NPC Sounds
#func eule_audio():
	#play_audio(eule_sound)
#
#func kaefer_audio():
	#play_audio(kaefer_sound)
#
#func lucky_pete_frog_audio():
	#play_audio(lucky_pete_frog)
#
#func lucky_pete_money_audio():
	#play_audio(lucky_pete_money)
#
#func maulwurf_audio():
	#play_audio(maulwurf)
#
## All Enemy Sounds
#
## Fly
#func fly_audio():
	#play_audio(fly_sound)
#
#func fly_hit_audio():
	#play_audio(fly_hit_sound)
#
## Hide
#func hide_death_audio():
	#play_audio(hide_death_sound)
#
#func hide_damage_audio():
	#play_audio(hide_damage)
#
## Slime
#func slime_move_audio():
	#play_audio(slime_move)
#
#func slime_death_audio():
	#play_audio(slime_death)
#
## Drexus
#func drexus_hit_audio():
	#play_audio(drexus_hit)
#
#func drexus_jump_audio():
	#play_audio(drexus_jump)
#
#func drexus_scream_audio():
	#play_audio(drexus_scream)
#
#func drexus_step_audio():
	#play_audio(drexus_step)
#
#func drexus_armor_audio():
	#play_audio(drexus_armor)
#
## All Objects
#func button_audio():
	#play_audio(button_sound)
#
#func bag_audio():
	#play_audio(bag_sound)
#
#func break_box_audio():
	#play_audio(break_box_sound)
#
#func coins_audio():
	#play_audio(coins_sound)
#
#func Cutscene_book_audio():
	#play_audio(Cutscene_book_sound)
#
#func drumstick_audio():
	#play_audio(drumstick_sound)
#
#func gong_audio():
	#play_audio(gong_sound)
#
#func kristall_audio():
	#play_audio(kristall_sound)
#
#func leaves_audio():
	#play_audio(leaves_sound)
#
#func popUp_audio():
	#play_audio(popUp_sound)
#
#func ringe_audio():
	#play_audio(ringe_sound)
#
#func spawner_audio():
	#play_audio(spawner_sound)
#
#func teleporter_audio():
	#play_audio(teleporter_sound)
#
#func trap_audio():
	#play_audio(trap_sound)
#
#func uhr_audio():
	#play_audio(uhr_sound)
	
func stop_music():
	self.stop()  # Stoppt die aktuell abgespielte Musik
	
func delete_audio():
	self.queue_free()

func change_music(new_music: AudioStream):
	stop_music()
	play_audio(new_music)

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream
	audio.stream_paused = false
	audio.play()
