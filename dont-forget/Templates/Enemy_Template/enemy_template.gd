extends CharacterBody2D

# General Properties
@export var speed: float = 100.0  # Movement speed
@export var idle_time_min: float = 1.0  # Minimum idle time
@export var idle_time_max: float = 5.0  # Maximum idle time
@export var life: int = 100  # Health points
@export var min_gold_drop: int = 1  # Minimum gold drops
@export var max_gold_drop: int = 4  # Maximum gold drops
@export var min_time_drop: int = 2  # Minimum time drops
@export var max_time_drop: int = 5  # Maximum time drops
@export var knockback_speed: float = 400.0  # Knockback speed
@export var knockback_duration: float = 0.2  # Knockback duration
@export var tutorial: bool = false  # Is the tutorial mode active

var drop := preload("res://scenes/drop.tscn")  # Preload the drop scene
var current_Itemholder  # Reference to the item holder

# Nodes and Signals
@onready var direction_timer: Timer = $Direction_Timer
@onready var detection_area: Area2D = $DetectionArea  # Add your detection area
@onready var attack_area: Area2D = $AttackArea
@onready var damage_area: Area2D = $DamageArea

# Variables for controlling the enemy behavior
var direction: int = 0  # -1 = left, 1 = right, 0 = idle
var orientation_left: bool = false
var damaged: bool = false
var alive: bool = true
var is_knocked_back: bool = false
var knockback_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO
var character: Character = null
var character_chase: bool = false

func _ready():
	# Initialize references and start behavior
	var gamemanager = find_game_manager()
	current_Itemholder = gamemanager.connect("current_Itemholder", Callable(self, "save_user_location"))
	randomize()
	start_new_behavior()
	
	

	# Connect area signals
	detection_area.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
	attack_area.connect("attack_entered", Callable(self, "_on_attack_area_body_entered"))

func _physics_process(delta):
	if !alive:
		velocity = Vector2.ZERO  # Stop movement if not alive
	elif is_knocked_back:
		handle_knockback(delta)
	elif character_chase:
		chase_character()
	else:
		move_in_direction()

	apply_gravity(delta)
	move_and_slide()

func apply_gravity(delta):
	# Apply gravity if not on the floor
	if !is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	else:
		velocity.y = 0  # Reset vertical velocity on the floor

func handle_knockback(delta):
	# Handle knockback movement
	knockback_timer -= delta
	if knockback_timer <= 0.0:
		is_knocked_back = false
	else:
		velocity.x = knockback_direction.x * knockback_speed

func chase_character():
	# Chase the player character
	if character:
		var direction_to_character = (character.global_position - global_position).normalized()
		direction = direction_calcX(direction_to_character)
		velocity.x = direction * speed

func direction_calcX(newGoal):
	# Calculate direction based on the player's position
	if newGoal.x > 0:
		return 1  # Move right
	elif newGoal.x < 0:
		return -1  # Move left
	else:
		return 0  # Idle

func move_in_direction():
	# Move the enemy based on the direction (left, right, or idle)
	velocity.x = direction * speed

func start_new_behavior():
	# Set a new random behavior for the enemy (idle, left, right)
	direction = randi() % 3 - 1  # -1 (left), 0 (idle), 1 (right)
	direction_timer.wait_time = randf_range(idle_time_min, idle_time_max)
	direction_timer.start()

func _on_direction_timer_timeout():
	# Start new behavior after idle time
	start_new_behavior()

#func update_animation():
	## Update animations based on the direction and state
	#if !alive:
		#return
	#if damaged:
		#return
#
	#match direction:
			#
		#-1:
			#if !orientation_left:
				#flip_sprite()  # Flip sprite if moving left
			#
		#1:
			#if orientation_left:
				#flip_sprite()  # Flip sprite if moving right
			

func flip_sprite(body: Character):
	# Calculate the player's relative position to the enemy
	var relative_position = body.global_position.x - global_position.x

	# If the player is on the right and the enemy is facing left, flip to the right
	if relative_position > 0 and orientation_left:
		$".".scale.x *= -1
		orientation_left = false
	# If the player is on the left and the enemy is facing right, flip to the left
	elif relative_position < 0 and !orientation_left:
		$".".scale.x *= -1
		orientation_left = true


func _on_detection_area_body_entered(body):
	# Triggered when the player enters the detection area
	if body is Character:
		character = body
		character_chase = true
		direction_timer.stop()

func _on_detection_area_body_exited(body):
	# Triggered when the player exits the detection area
	if body is Character and character == body:
		print("Body existed")
		character = null
		character_chase = false
		start_new_behavior()

func take_damage(damage: int):
	# Handle taking damage and knockback
	life -= damage
	damaged = true
	if life <= 0:
		die()
	else:
		knockback()

func knockback():
	# Apply knockback effect
	if character:
		knockback_direction.x = direction_calcX((global_position - character.global_position).normalized())
		is_knocked_back = true
		knockback_timer = knockback_duration

func die():
	# Handle the death of the enemy
	alive = false
	add_new_drop(position)

func _on_animation_player_animation_finished(anim_name: String):
	# Check when the death animation is finished to drop items and remove the enemy
	if anim_name == "death":
		add_new_drop(global_position)
		queue_free()

func find_game_manager():
	# Find the game manager in the scene tree
	var root = get_tree().root
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null

func add_new_drop(death_pos):
	# Add drops upon death (gold, time items, etc.)
	var gold_drop = randi_range(min_gold_drop, max_gold_drop)
	var time_drop = randi_range(min_time_drop, max_time_drop)
	instantiate_drop_items(gold_drop, death_pos, false)  # False for gold
	if !tutorial:
		# Drop time items
		instantiate_drop_items(time_drop, death_pos, true)  # True for time

func instantiate_drop_items(drop_count, death_pos, is_time_item):
	# Instantiate and drop items at the enemy's death position
	for i in range(drop_count):
		var item = drop.instantiate()  # Assuming 'drop' is the base scene for both types
		item.position = death_pos
		
		# Set the type of item (gold or time)
		item.time = is_time_item
		
		# Add item to the scene and group
		current_Itemholder.call_deferred("add_child", item)
		item.add_to_group("items")

func save_user_location(path):
	# Save the location of the item holder (optional)
	current_Itemholder = path


func _on_attack_area_body_entered(body):
	if !alive:
		return
	if body is Character and alive:
		body.take_damage(10)
		knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, knockback_speed)


func _on_damage_area_body_entered(body):
	if !alive:
		return
	if body is Character:
		var attack_area = body.get_node_or_null("Attack_Area")
		if attack_area and attack_area.is_in_group("player_attacks") && body.attacking:
			self.take_damage(body.damage_value)
