extends Level


@onready var houseAnim = $"Environment/Homes/Home 1"
@onready var houseAnim2 = $"Environment/Homes/Home 2"
@onready var houseAnim3 = $"Environment/Homes/Home 3"
@onready var houseAnim4 = $"Environment/Homes/Home 4"
@onready var houseAnim5 = $"Environment/Homes/Home 5"
@onready var houseAnim6 = $"Environment/Homes/Home 6"

@onready var left_bug = $Environment/bugs/Bugs2

@onready var audio_play = $Audio_Stream


# Called when the node enters the scene tree for the first time.
func _ready():
	houseAnim.play("default")
	houseAnim2.play("default")
	houseAnim3.play("default")
	houseAnim4.play("default")
	houseAnim5.play("default")
	houseAnim6.play("default")
	audio_play.play_village_bg_music()

	left_bug.get_node("AnimatedSprite2D").flip_h
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
## If signal cutszene from cave with saving of brother is finished than render Cutscene_End with transition
## Position???
##


func _on_sound_off_body_entered(body: Node2D) -> void:
	audio_play.delete_audio()
