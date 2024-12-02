extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hitFlashPlayer: AnimationPlayer = $HitFlashPlayer
@onready var combo_timer: Timer = $ComboTimer

@export var speed: float = 100.0
@export var attacking = false
@export var alive = true
@export var damaged: bool = false
@export var attack_range: float = 150.0  # Angriffsreichweite

var combo_phase: int = 0
var phase: int = 1  # Boss starting Phase
var orientation_left: bool = false
var character: Character = null
var character_chase: bool = false
var direction: int = 0

signal boss_defeated(boss_name: String)
signal boss_engaged(boss_name: String)

@export var max_health: int = 100
var current_health: int = max_health

func _ready():
	animationPlayer.play("idle")

func _physics_process(delta):
	apply_gravity(delta)
	if character_chase:
		chase_character()
	move_and_slide()
	update_animation()

func take_damage(damage: int):
	current_health -= damage
	damaged = true
	hitFlashPlayer.play("hit_flash")
	if current_health <= max_health / 2 and phase == 1:
		start_phase_2()
	if current_health <= 0:
		die()

func start_phase_2():
	phase = 2
	print("Boss entered Phase 2")

func update_animation():
	if !alive or damaged:
		return
		
	if attacking:
		animationPlayer.play("attack")
		print("attack")
		return
		
	if velocity.x == 0:
		animationPlayer.play("idle")
	else:
		if velocity.x < 0:
			if !orientation_left:
				flip_sprite()
			animationPlayer.play("run")
		elif velocity.x > 0:
			if	orientation_left:
				flip_sprite()
			animationPlayer.play("run")

func flip_sprite():
	$".".scale.x *= -1
	orientation_left = !orientation_left

func apply_gravity(delta):
	if !is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	else:
		velocity.y = 0

func on_hit(damage: int = 10):
	take_damage(damage)
	emit_signal("boss_engaged")

func attack():
	print("attack() called")
	if global_position.x < character.global_position.x:
		if orientation_left:
			flip_sprite()
		print("right")
	else:
		if not orientation_left:
			flip_sprite()
		print("left")
	if phase == 1:
		perform_attack()
		print("perform 1")
	elif phase == 2:
		perform_phase_2_attack()

func perform_attack():
	attacking = true
	animationPlayer.play("attack")
	print("Boss performs a basic attack")
	attacking = false

func perform_phase_2_attack():
	var random_action = randi() % 2
	if random_action == 0:
		perform_combo_attack()
	else:
		perform_bomb_attack()

func perform_combo_attack():
	combo_phase = 0
	combo_timer.start()
	print("Boss starts combo attack (left-right-left).")

func perform_bomb_attack():
	# Make the boss jump towards the player
	var direction_to_character = (character.global_position - global_position).normalized()
	
	# Calculate horizontal direction
	direction = direction_calcX(direction_to_character)
	velocity.x = direction * speed
	
	# Determine vertical direction (jumping towards the player)
	var jump_height = character.global_position.y - global_position.y
	print("Jump H: ", jump_height)
	if jump_height > 0:
		# Character is below the boss (boss needs to jump up)
		velocity.y = -1000 # Adjust this value to control the jump strength
		print("Boss jumps up towards player")
	else:
		# Character is above the boss (boss needs to jump down)
		velocity.y = 400  # Adjust this value to control downward velocity
		print("Boss jumps down towards player")
	
	# Play the bomb animation after the jump is initiated
	animationPlayer.play("bombe")
	print("Boss drops bombs towards player!")
	
	if is_on_floor():
		animationPlayer.play("idle")
	# The attack animation should not override the jump or movement logic,
	# so we'll make sure to sync the jump and bomb dropping.



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
		attacking = false
		# Spieler-Distanz prüfen und angreifen, wenn nah genug
		var distance_to_character = character.global_position.distance_to(global_position)
		if distance_to_character <= attack_range and !attacking:
			velocity.x = 0
			attack()

func direction_calcX(new_goal):
	if new_goal.x > 0:
		return 1  # Nach rechts
	elif new_goal.x < 0:
		return -1  # Nach links
	return 0  # Stillstand

func update_orientation():
	# Flips the sprite based on orientation.
	if orientation_left:
		$".".scale.x = abs($".".scale.x) * -1
	else:
		$".".scale.x = abs($".".scale.x)
