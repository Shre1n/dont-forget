extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hitFlashPlayer: AnimationPlayer = $HitFlashPlayer
@onready var boss: AnimatedSprite2D = $Boss

@export var speed: float = 100.0 
@export var attacking = false
@export var alive = true
@export var damaged: bool = false


var orientation_left: bool = false
var character: Character = null
var character_chase: bool = false
var direction: int = 0

signal boss_defeated(boss_name: String)
signal boss_engaged(boss_name: String)

@export var max_health: int = 100
var current_heath: int = max_health

func _ready():
	animationPlayer.play("idle")

func _physics_process(delta):
	apply_gravity(delta)
	if character_chase:
		chase_character()
	move_and_slide()
	update_animation()

func take_damge(damage:int):
	current_heath -= damage
	damaged = true
	hitFlashPlayer.play("hit_flash")
	if current_heath <= 0:
		die()


func update_animation():
	if !alive:
		return
	if damaged:
		return
	print("dehugfurgfz")

	match direction:
		0:
			animationPlayer.play("idle")
			print("hufhufhuw")
		-1:
			if !orientation_left:
				flip_sprite()
				print("frzgfz7fegwueij")
			animationPlayer.play("run")
		1:
			if orientation_left:
				flip_sprite()
				print("eghfzegfuwihfiw")
			animationPlayer.play("run")

func flip_sprite():
	$".".scale.x *= -1
	print("ghezgfdgeu")
	orientation_left = !orientation_left


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


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Character:
		animationPlayer.play("run")
		character = body
		character_chase = true
		
func chase_character():
	if character:
		var direction_to_character = (character.global_position - global_position).normalized()
		direction = direction_calcX(direction_to_character)
		velocity.x = direction * speed


func direction_calcX(newGoal):
	var new_direction
	if newGoal.x > 0:
		new_direction = 1  # Nach rechts
	elif newGoal.x < 0:
		new_direction = -1  # Nach links
	else:
		new_direction = 0  # Stillstand
	return new_direction
