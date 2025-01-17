extends Node2D

var bag_coins = 0
@onready var character = $"../Character"
		
@onready var interaction_area: InteractionArea =$RigidBody2D/InteractionArea
@onready var animationPlayer: AnimationPlayer = $RigidBody2D/AnimationPlayer
@onready var anim_Sprite: AnimatedSprite2D =$RigidBody2D/AnimatedSprite2D

@export var audio_bag: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "on_pick_up")
	$RigidBody2D.freeze = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animationPlayer.play("idle")


func on_pick_up():
	$RigidBody2D.freeze = false
	character = interaction_area.body_of_character
	character.get_coins(bag_coins)
	#audio_bag.stream
	queue_free()

func show_interaction(hide: bool):
	interaction_area.monitoring = hide

func set_coins(value):
	bag_coins = value
	
func get_coins():
	return bag_coins

	
