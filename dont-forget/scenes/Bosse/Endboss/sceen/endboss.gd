extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hitFlashPlayer: AnimationPlayer = $HitFlashPlayer
@onready var boss: AnimatedSprite2D = $Boss

@export var attacking = false
@export var alive = true
@export var damaged: bool = false

signal boss_defeated(boss_name: String)
signal boss_engaged(boss_name: String)

@export var max_health: int = 100
var current_heath: int = max_health

func _ready():
	interaction_area.interact = Callable(self, "on_hit")
	animationPlayer.play("idle")

func _physics_process(delta):
	apply_gravity(delta)
	move_and_slide()

func take_damge(damage:int):
	current_heath -= damage
	damaged = true
	hitFlashPlayer.play("hit_flash")
	if current_heath <= 0:
		die()
		
		
func apply_gravity(delta):
	if !is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	else:
		velocity.y = 0


func on_hit(damage: int = 10):
	current_heath -= damage
	print("Boss hit! Remain! HP: ", current_heath)
	
	
	emit_signal("boss_engaged")
	
	if current_heath <= 0:
		die()

func attack():
	attacking = true
	animationPlayer.play("attack")
	
	
	

func die():
	alive = false
	emit_signal("boss_defeated")
	animationPlayer.play("dead")
	queue_free()
