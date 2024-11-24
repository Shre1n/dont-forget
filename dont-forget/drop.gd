class_name Drop extends RigidBody2D

signal lifeChange(amount)

@export var time = true #wenn fales steht es für Gold
@export var value = 1 #random noch einbauen?
@export var time_course = 5 #10?

var player_body

@onready var sprite = $AnimatedSprite2D
@onready var animation = $AnimationPlayer

func _ready():
	if time:
		animation.play("Time")
	else:
		animation.play("Gold")

func _on_area_2d_body_entered(body):
	if body.name == "Character":
		player_body = body
		if time:
			collect_time(value*time_course)
		else:
			collect_coin(value)

func collect_coin(value):
	player_body.get_coins(value)
	queue_free()

func collect_time(value):
	player_body.get_time(value)
	queue_free()
