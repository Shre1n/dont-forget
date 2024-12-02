extends "res://Templates/Enemy_Template/enemy_template.gd"

@export var fly_speed: float = 150.0  # Custom flying speed
@export var fly_height: float = 50.0  # The height the flying enemy moves up and down
@export var fly_range: float = 200.0  # The horizontal range of movement
@export var hit_flash_time: float = 0.2  # Duration of the hit flash

@onready var hit_flash: AnimationPlayer = $HitFlashPlayer

var original_position: Vector2

func _ready():
	super()._ready()
	original_position = global_position

func _physics_process(delta):
	var offset = sin(global_position.x / fly_range) * fly_height
	velocity.x = fly_speed
	velocity.y = offset
	super.handle_knockback(delta)
	move_and_slide()

func take_damage(damage: int):
	hit_flash.play("hit_flash")
	super.take_damage(damage)
