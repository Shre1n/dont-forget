class_name Character
extends CharacterBody2D

# Signale
signal coinsChange(amount)
signal lifeChange(amount)
signal going_back  # Zurück zum Menü
# signal going_back(path)  # Zurück zum Dorf

# --- Export-Variablen ---
# Unendlich erhöhbar
@export var damage_stat = 10
@export var crit_dmg_stat = 10  # Schadenserhöhung bei Krits (Prozent)
@export var res_stat = 0

# Bis 3500 erhöhbar
@export var speed_stat = 250
@export var jump_stat = 250
@export var imunity_stat = 0
@export var attack_speed_stat = 250
@export var extra_weight_stat = 0

# Bis 1000 erhöhbar
@export var cooldown_stat = 250
@export var pierce_stat = 0  # Durchschlagskraft (Prozent)
@export var crit_stat = 0  # Kritische Trefferchance (0–1000 = 0–100%)
@export var knockback_stat = 1  # Knockback-Stärke
@export var knockback_res_stat = 0 # Knockback-Resistenz

# Noch fehlende Stats
# @export var dash_cooldown_stat = 1
# @export var dash_speed_stat = 1

@export var sword: bool = true
@export var input_enabled: bool = true
@export var orientation_left = false
@export var attacking = false
@export var can_attack = true
@export var alive = true

@export var cooldown_duration: float = 1.0
@export var max_attack_speed = 6.0
@export var min_attack_speed = 2.0
@export var knockback_speed: float = 300.0
@export var knockback_duration: float = 0.2

# --- Lokale Variablen ---
var min_damage_stat = 1
var min_speed_stat = 20
var min_res_stat = 0
var min_pierce_stat = 0
var min_crit_stat = 0
var min_crit_dmg_stat = 1
var min_knockback_stat = 0
var min_knockback_res_stat = 0
var min_cooldown_stat = 0
var min_attack_speed_stat = 1
var min_jump_stat = 35
var min_dash_cooldown_stat = 0
var min_dash_speed_stat = 2

var speed = max(20, speed_stat * 10)
var jump_height = max(35, -(jump_stat * 10))
var max_resistenz = 70
var resistenz = res_stat
var imunity = calculate_stats_to_value(imunity_stat, 0.0, 1.0, 0, 0.99, 3500.0)
var knockback_res = (1 - (knockback_res_stat / 1000))
var knockback_power = calculate_stats_to_value(knockback_stat, 0.0, 1.0, 0, 3000, 3500.0)
var cooldown_reduction = (1 - (cooldown_stat / 1000))
var attack_speed = calculate_stats_to_value(attack_speed_stat, 0.0, 3.5, min_attack_speed, max_attack_speed)
var cooldown: float = 0.0
var cooldown_duration_base: float = 1.6 / attack_speed
var all_stats = damage_stat + crit_dmg_stat + res_stat + speed_stat + jump_stat + imunity_stat + attack_speed_stat + cooldown_stat + pierce_stat + crit_stat + knockback_stat + knockback_res_stat
var extra_weight = calculate_stats_to_value(extra_weight_stat, 0.0, 3.5, 0, 10)
var weight = min(49, all_stats / 1000) + extra_weight

var is_knocked_back: bool = false
var knockback_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_speed_new

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var JumpAvailability: bool

# --- Onready-Variablen ---
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var JumpTimer: Timer = $Jump_Timer
@onready var animation_player = $AnimationPlayer
@onready var game_manager = find_game_manager()
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer
@onready var weapon = $Attack_Area

# --- Funktionen ---

func _ready():
	new_spawn_position()
	animation_player.play("idle")
	game_manager.connect("death", Callable(self, "die"))
	
	var min_speed = 100
	var max_speed = 2000 #max speed pro 1000 Stats
	var max_step_speed = 3.5
	speed = calculate_stats_to_value(speed_stat, 0.0 , max_step_speed, min_speed, max_speed)
	var min_jump = 350
	var max_jump = 900 #pro 1000 Stats
	var max_step_jump = 3.5
	jump_height = -calculate_stats_to_value(jump_stat, 0.0, max_step_jump, min_jump, max_jump)
	resistenz = res_stat #fester Wert
	imunity = calculate_stats_to_value(imunity_stat, 0.0, 1.0, 0, 0.99, 3500.0)
	knockback_res = (1 - (knockback_res_stat/1000))
	cooldown_reduction = (1 - (cooldown_stat/1000))
	all_stats = damage_stat + crit_dmg_stat + res_stat + speed_stat + jump_stat + imunity_stat + attack_speed_stat + cooldown_stat + pierce_stat + crit_stat + knockback_stat + knockback_res_stat
	extra_weight = calculate_stats_to_value(extra_weight_stat, 0.0, 3.5, 0, 100)
	weight = min(490, all_stats / 100) + extra_weight
	
	weapon.damage = max(1, damage_stat)
	weapon.pierce_multi = pierce_stat
	weapon.crit_chance = crit_stat
	weapon.crit_multi = max(1, crit_dmg_stat)
	weapon.knockback = knockback_power


func _process(delta):
	if cooldown > 0:
		cooldown -= delta
	if Input.is_action_just_pressed("attack") && sword && cooldown <= 0:
		attack()
		update_animation()

func _physics_process(delta):
	if alive:
		if !attacking:
			var test = Input.get_axis("left", "right")
			#if Input.is_action_just_pressed("left") and !orientation_left:
			if test < 0 and !orientation_left:
				$".".scale.x = abs($".".scale.x) * -1
				orientation_left = true
			if test > 0 and orientation_left:
				$".".scale.x = abs($".".scale.x) * -1
				orientation_left = false

	if is_on_floor():
		JumpAvailability = true
	else:
		if JumpAvailability and JumpTimer.is_stopped():
			JumpTimer.start()
		elif JumpTimer.is_stopped():
			velocity += get_gravity() * delta

	if alive:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and JumpAvailability:
			velocity.y = jump_height
			JumpAvailability = false
			
		if is_knocked_back:
			handle_knockback(delta)
		else:
			# Get the input direction and handle the movement/deceleration.
			var direction = Input.get_axis("left", "right")
			if direction != 0:
				velocity.x = direction * speed
			else:
				if !JumpAvailability:
					velocity.x = move_toward(velocity.x, 0, speed * delta)
				else:
					velocity.x = move_toward(velocity.x, 0, speed)
	update_animation()
	move_and_slide()

func handle_knockback(delta):
	knockback_timer -= delta
	if knockback_timer <= 0 or knockback_res == 0:
		is_knocked_back = false
		# Behalte die letzte Geschwindigkeit bei
		#velocity.x = knockback_direction.x * knockback_speed_new
		velocity = velocity.move_toward(Vector2.ZERO, knockback_speed_new * delta)
	else:
		# Wende Knockback-Effekte an
		#knockback_speed_new = lerp(knockback_speed_new, 0.0, 0.05)
		velocity = knockback_direction * knockback_speed_new

func knockback(knockback, damage_position):
	var direction = (position - damage_position).normalized()
	knockback_direction = direction
	# Knockback wird durch Widerstand und Gewicht reduziert
	knockback_speed_new = knockback #- weight
	# Knockback-Dauer skaliert mit Stärke
	knockback_timer = 0.2 #max(0.1, knockback_duration * effective_knockback)  #knockback_power
	is_knocked_back = true

func take_damage(damage, pierce, knockback, knockback_power_in, damage_position, falle):
	var effective_damage = ceil((max(0, damage - resistenz) + pierce) * imunity)
	var knockback_effect = knockback_power_in * knockback_res
	if (knockback_effect) > weight:
		knockback(knockback_effect, damage_position)
	if effective_damage > 0:
		hit_flash_anim_player.play("hit_flash")
		emit_signal("lifeChange", -effective_damage)

func attack():
	attacking = true
	cooldown = cooldown_duration_base + cooldown_duration * cooldown_reduction
	animation_player.speed_scale = attack_speed
	animation_player.play("fight")

func update_animation():
	if alive:
		if !attacking:
			if velocity.x != 0:
				animation_player.play("walk")
			else:
				animation_player.play("idle")

			if velocity.y < 0:
				animation_player.play("jump")
			if velocity.y > 0:
				animation_player.play("idle") #später fall

func _on_jump_timer_timeout():
	JumpAvailability = false

func die():
	velocity = Vector2.ZERO
	alive = false
	animation_player.play("death")
	await (animation_player.animation_finished)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		#Zum Menu zurück
		emit_signal("going_back")
		#Zum Village zurück
		#var path = "res://scenes/village.tscn"
		#emit_signal("going_back", path)

func new_spawn_position():
	if Global.new_position != null:
		position = Global.new_position

func disable():
	input_enabled = false
	#animation_player.play("idle")

func enable():
	input_enabled = true
	visible = true

func get_time(value):
	emit_signal("lifeChange", value)

func get_coins(value):
	emit_signal("coinsChange", value)

func calculate_stats_to_value(stat: int, span_start: float, span_end: float, min_value: float, max_value: float, divider: float = 1000.0) -> float:
	var stat_factor = clamp(stat / divider, span_start, span_end)
	return lerp(min_value, max_value, stat_factor)

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null
