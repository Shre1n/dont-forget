extends Node2D


var bag_coins = 0
@onready var character = $"../Character"
		
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var anim_Sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "on_pick_up")


func on_pick_up():
	character.get_coins(bag_coins)
	queue_free()


func set_coins(value):
	bag_coins = value
	
func get_coins():
	return bag_coins

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animationPlayer.play("idle")
