class_name Drop extends RigidBody2D

signal lifeChange(amount)

@export var time = true #wenn fales steht es für Gold
@export var value = 1 #random noch einbauen?
@export var time_course = 5 #10?

var player_body

@onready var sprite = $AnimatedSprite2D
@onready var animation = $AnimationPlayer
@onready var timer = $Timer

@onready var audio_gold = $gold
@onready var audio_time = $time


func _ready():
	if time:
		animation.play("Time")
	else:
		animation.play("Gold")
		
func _process(delta: float) -> void:
	if linear_velocity.x > 0:
		if time:
			audio_gold.play()
		else:
			audio_time.play()

func _on_area_2d_body_entered(body):
	if body.name == "Character":
		player_body = body
		if time:
			collect_time(value*time_course)
		else:
			collect_coin(value)

func collect_coin(value):
	player_body.get_coins(value)
	_on_timer_timeout()

func collect_time(value):
	player_body.get_time(value)
	_on_timer_timeout()


func _on_timer_timeout() -> void:
	queue_free()
