extends CharacterBody2D

@export var speed: float = 100.0  # Laufgeschwindigkeit
@export var idle_time_min: float = 1.0  # Mindestwartezeit im Idle-Zustand
@export var idle_time_max: float = 5.0  # Maximalwartezeit im Idle-Zustand
@export var life: int = 100  # Lebenspunkte
@export var min_gold_drop: int = 1
@export var max_gold_drop: int = 4
@export var min_time_drop: int = 2
@export var max_time_drop: int = 5
@export var knockback_speed: float = 300.0
@export var knockback_duration: float = 0.2
@export var tutorial: bool = false

var drop := preload("res://scenes/drop.tscn")
var current_Itemholder

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_player: AnimationPlayer = $AnimationPlayer
@onready var chase_anim: AnimationPlayer = $Chase_Anim
@onready var direction_timer: Timer = $Direction_Timer

var direction: int = 0  # -1 für links, 1 für rechts, 0 für idle
var orientation_left: bool = false
@export var damaged: bool = false
var alive: bool = true

var character: Character = null
var character_chase: bool = false

var is_knocked_back: bool = false
var knockback_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO

func _ready():
	var gamemanager = find_game_manager()
	current_Itemholder = gamemanager.connect("current_Itemholder", Callable(self, "save_user_location"))
	randomize()
	start_new_behavior()

func _physics_process(delta):
	if !alive:
		velocity = Vector2.ZERO
	elif is_knocked_back:
		handle_knockback(delta)
	elif character_chase:
		chase_character()
	else:
		move_in_direction()
		
	apply_gravity(delta)
	move_and_slide()
	update_animation()

func apply_gravity(delta):
	if !is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	else:
		velocity.y = 0

func handle_knockback(delta):
	knockback_timer -= delta
	if knockback_timer <= 0.0:
		is_knocked_back = false
	else:
		velocity.x = knockback_direction.x * knockback_speed

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

func move_in_direction():
	velocity.x = direction * speed

func start_new_behavior():
	direction = randi() % 3 - 1  # -1 (links), 0 (idle), 1 (rechts)
	direction_timer.wait_time = randf_range(idle_time_min, idle_time_max)
	direction_timer.start()

func _on_direction_timer_timeout():
	start_new_behavior()

func update_animation():
	if !alive:
		return
	if damaged:
		return

	match direction:
		0:
			animated_player.play("idle")
		-1:
			if !orientation_left:
				flip_sprite()
			animated_player.play("walk")
		1:
			if orientation_left:
				flip_sprite()
			animated_player.play("walk")

func flip_sprite():
	$".".scale.x *= -1
	orientation_left = !orientation_left

func _on_detection_area_body_entered(body):
	if body is Character:
		chase_anim.play("chase")
		character = body
		character_chase = true
		direction_timer.stop()

func _on_detection_area_body_exited(body):
	if body is Character and character == body:
		chase_anim.play("lost")
		character = null
		character_chase = false
		start_new_behavior()

func take_damage(damage, pierce, knockback, position, falle):
	life -= damage
	damaged = true
	animated_player.play("hurt")
	if life <= 0:
		die()
	else:
		knockback()

func knockback():
	if character:
		knockback_direction.x = direction_calcX((global_position - character.global_position).normalized())
		is_knocked_back = true
		knockback_timer = knockback_duration

func die():
	alive = false
	animated_player.play("death")

func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "death":
		add_new_drop(global_position)
		queue_free()

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null

func add_new_drop(death_pos):
	var gold_drop = randi_range(min_gold_drop, max_gold_drop)
	var time_drop = randi_range(min_time_drop, max_time_drop)
	instantiate_drop_items(gold_drop, death_pos, false)  # False for gold
	if !tutorial:
		# Drop time items
		instantiate_drop_items(time_drop, death_pos, true)  # True for time


func instantiate_drop_items(drop_count, death_pos, is_time_item):
	for i in range(drop_count):
		var item = drop.instantiate()  # Assuming 'drop' is the base scene for both types
		item.position = death_pos
		
		# Set the type of item (gold or time)
		item.time = is_time_item
		
		# Add item to the scene and group
		current_Itemholder.call_deferred("add_child", item)
		item.add_to_group("items")

func save_user_location(path):
	current_Itemholder = path
