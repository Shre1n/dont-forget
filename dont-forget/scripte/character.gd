class_name Character
extends CharacterBody2D

# Signale
signal coinsChange(amount)
signal lifeChange(amount)
signal resetCoins
signal getCoins
signal add_bag(bag_instance)
signal going_back(path)  # Zurück zum Dorf

@onready var audio = $Audio_Stream

@onready var audio_player = $Audio_Stream
@export var dash_audio: AudioStream
@export var hit_audio: AudioStream
@export var jump_audio: AudioStream
@export var mc_hit_audio: AudioStream
@export var walk_audio: AudioStream

@export_category("Einstellungen")
@export var test_on: bool = false
@export var sword: bool = true
# --- Export-Variablen ---
# Bis 3500 erhöhbar
@export_subgroup("Stats")
@export var damage_stat = 10
@export var crit_dmg_stat = 10  # Schadenserhöhung bei Krits (Prozent)
@export var res_stat = 0
@export var speed_stat = 250
@export var jump_stat = 250
@export var imunity_stat = 0
@export var attack_speed_stat = 250
@export var extra_weight_stat = 0
@export var cooldown_stat = 100
@export var pierce_stat = 0  # Durchschlagskraft (Prozent)
@export var crit_stat = 0  # Kritische Trefferchance (0–1000 = 0–100%)
@export var knockback_stat = 50  # Knockback-Stärke
@export var knockback_res_stat = 0 # Knockback-Resistenz
@export var dash_cooldown_stat = 0
@export var dash_speed_stat = 0

@export_subgroup("Camera")
@export var camera_limit_left = -10000000
@export var camera_limit_top = -10000000
@export var camera_limit_right = 10000000
@export var camera_limit_bottom = 10000000

@export_subgroup("Game_Setups")
@export var input_enabled: bool = true
@export var orientation_left: bool = false
@export var attacking: bool = false
@export var can_attack: bool = true
@export var alive: bool = true

@export_subgroup("Balancing")
@export var dash_price: float = 30.0
@export var dashtime: float = 0.2
@export var cooldown_duration: float = 0.7
@export var dash_cooldown_duration: float = 5.0
@export var dash_duration: float = 0.2
@export var dash_cooldown_duration_base: float = 0.1
@export var knockback_duration: float = 0.2
@export var post_knockback_duration: float = 0.6  # Dauer der Nach-Knockback-Phase

var damage
var speed
var jump_height
var resistenz
var imunity
var knockback_res
var cooldown_reduction
var attack_speed
var cooldown_duration_base: float
var all_stats 
var extra_weight 
var weight
var dash_speed
var dash_cooldown_reduction

var current_dash_speed = 1
var dashing = false

@export var coins = 0

var start_position: Vector2


var cooldown: float = 0.0
var dash_cooldown: float = 0.0


var is_knocked_back: bool = false
var knockback_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_speed: float = 300.0
var knockback_speed_new
var knockback_wait
var post_knockback_timer = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var JumpAvailability: bool

var open = false

# --- Onready-Variablen ---
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var JumpTimer: Timer = $Jump_Timer
@onready var animation_player = $AnimationPlayer
@onready var game_manager = find_game_manager()
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer
@onready var weapon = $Attack_Area
@onready var camera = $Camera2D
@onready var dash_timer = $Dash_Timer
@onready var stats_popup = $Camera2D/CanvasLayer/stats_popup

# --- Funktionen ---

func _ready():
	#coins = Global.coins
	new_spawn_position()
	hit_flash_anim_player.play("RESET")
	camera.limit_left = camera_limit_left
	camera.limit_top = camera_limit_top
	camera.limit_right = camera_limit_right
	camera.limit_bottom = camera_limit_bottom
	dash_timer.wait_time = dashtime
	animation_player.play("idle")
	start_position = position
	game_manager.connect("death", Callable(self, "die"))
	if test_on:
		update_status()
	else:
		get_stats()

func get_stats():
	damage_stat = game_manager.damage_stat
	crit_dmg_stat = game_manager.crit_dmg_stat
	res_stat = game_manager.res_stat
	speed_stat = game_manager.speed_stat
	jump_stat = game_manager.jump_stat
	imunity_stat = game_manager.imunity_stat
	attack_speed_stat = game_manager.attack_speed_stat
	cooldown_stat = game_manager.cooldown_stat
	pierce_stat = game_manager.pierce_stat
	crit_stat = game_manager.crit_stat
	knockback_stat = game_manager.knockback_stat
	knockback_res_stat = game_manager.knockback_res_stat
	dash_cooldown_stat = game_manager.dash_cooldown_stat
	dash_speed_stat = game_manager.dash_speed_stat
	extra_weight_stat = game_manager.extra_weight_stat
	update_status()

func adjust_stats(changes: Array) -> void:
	var min_stats = 0
	var max_stats = 3500
	# Example: changes = [{"stat": "damage_stat", "amount": 10}, {"stat": "speed_stat", "amount": -5}]
	for change in changes:
		var stat_name = change.get("stat", "")
		var amount = change.get("amount", 0)
		if stat_name in self:
			var new_value = self.get(stat_name) + amount
			# Optional: Min-/Max-Grenzen berücksichtigen
			match stat_name:
				"damage_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"speed_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"jump_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"res_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"imunity_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"crit_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"crit_dmg_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"pierce_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"knockback_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"knockback_res_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"cooldown_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"attack_speed_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"extra_weight_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"dash_cooldown_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"dash_speed_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				"extra_weight_stat":
					new_value = clamp(new_value, min_stats, max_stats)
				# Hier einfach neue hinzufügen, falls nötig
			self.set(stat_name, new_value)
	save_stats()

func save_stats():
	game_manager.damage_stat = damage_stat
	game_manager.crit_dmg_stat = crit_dmg_stat
	game_manager.res_stat = res_stat
	game_manager.speed_stat = speed_stat
	game_manager.jump_stat = jump_stat
	game_manager.imunity_stat = imunity_stat
	game_manager.attack_speed_stat = attack_speed_stat
	game_manager.cooldown_stat = cooldown_stat
	game_manager.pierce_stat = pierce_stat
	game_manager.crit_stat = crit_stat
	game_manager.knockback_stat = knockback_stat
	game_manager.knockback_res_stat = knockback_res_stat
	game_manager.dash_cooldown_stat = dash_cooldown_stat
	game_manager.dash_speed_stat = dash_speed_stat
	game_manager.extra_weight_stat = extra_weight_stat
	update_status()

func update_status():
	damage = calculate_stats_to_value(damage_stat, 0.0, 1.0, 0.0, 3500.0, 3500.0)
	speed = calculate_stats_to_value(speed_stat, 0.0 , 1.0, 200, 3500, 3500.0) #6000
	jump_height = -calculate_stats_to_value(jump_stat, 0.0, 1.0, 450, 1500, 3500.0) #2500
	resistenz = calculate_stats_to_value(res_stat, 0.0, 1.0, 0.0, 7000.0, 3500.0)#res_stat #fester Wert
	imunity = calculate_stats_to_value(imunity_stat, 0.0, 1.0, 1, 0.01, 3500.0)
	knockback_res = calculate_stats_to_value(knockback_res_stat, 0.0, 1.0, 1, 0.01, 3500.0) #(1 - (knockback_res_stat/1000))
	cooldown_reduction = calculate_stats_to_value(cooldown_stat, 0.0, 1.0, 1, 0.0, 3500.0) #(1 - (cooldown_stat/1000))
	attack_speed = calculate_stats_to_value(attack_speed_stat, 0.0, 1.0, 2.0, 14.0, 3500.0)
	cooldown_duration_base = 1.6 / attack_speed
	all_stats = damage_stat + crit_dmg_stat + res_stat + speed_stat + jump_stat + imunity_stat + attack_speed_stat + cooldown_stat + pierce_stat + crit_stat + knockback_stat + knockback_res_stat + dash_cooldown_stat + dash_speed_stat
	extra_weight = calculate_stats_to_value(extra_weight_stat, 0.0, 3.5, 0, 100, 3500.0)
	weight = min(490, all_stats / 100) + extra_weight
	dash_cooldown_reduction = calculate_stats_to_value(dash_cooldown_stat, 0.0, 1.0, 1, 0.0, 3500.0)
	dash_speed = calculate_stats_to_value(dash_speed_stat, 0.0 , 1.0, 3.0, 6.0, 3500.0)

	weapon.damage = max(1, damage_stat)
	weapon.pierce_multi = pierce_stat
	weapon.crit_chance = crit_stat
	weapon.crit_multi = max(1, crit_dmg_stat)
	weapon.knockback = knockback_stat
	stats_popup.update_bars()

func _process(delta):
	if cooldown > 0:
		cooldown -= delta
	if dash_cooldown > 0:
		dash_cooldown -= delta
	if Input.is_action_just_pressed("attack") && sword && cooldown <= 0:
		attack()
		update_animation()
	elif Input.is_action_just_pressed("dash") && dash_cooldown <= 0 && Input.get_axis("left", "right"):
		dash()
	if Input.is_action_just_pressed("inventar"):
		open = !open
		stats_popup.visible = open

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
			#velocity += get_gravity() * delta
			var normalized_weight = 1+ pow(weight / 590, 2)  # Quadrat: Verstärkt Effekt
			velocity += get_gravity() * normalized_weight * delta

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
				velocity.x = (direction * speed) * current_dash_speed
			else:
				if !JumpAvailability:
					velocity.x = move_toward(velocity.x, 0, speed * delta)
				else:
					velocity.x = move_toward(velocity.x, 0, speed)
	update_animation()
	move_and_slide()

func handle_knockback(delta):
	if knockback_timer > 0:
		# Wende Knockback an
		knockback_timer -= delta
		velocity = knockback_direction * knockback_speed_new
	elif post_knockback_timer > 0:
		# Reduziere Geschwindigkeit nach Knockback
		post_knockback_timer -= delta
		velocity = velocity.move_toward(Vector2.ZERO, knockback_speed_new * delta)
		var direction = Input.get_axis("left", "right")
		if  velocity.length() < 10 or dashing: #(direction == -1 and velocity.x > 0) or (direction == 1 and velocity.x < 0): #velocity.x < 10 or velocity.x < direction.x:  # Geschwindigkeitsschwelle für Ende der Nach-Knockback-Phase
			velocity = Vector2.ZERO
			post_knockback_timer = 0
			is_knocked_back = false
	else:
		# Knockback abgeschlossen
		is_knocked_back = false

func knockback(knockback, damage_position):
	var direction = (position - damage_position).normalized()
	knockback_direction = direction
	knockback_speed_new = knockback
	knockback_timer = 0.2
	post_knockback_timer = post_knockback_duration
	is_knocked_back = true

func take_damage(damage, pierce, knockback_power_in, damage_position, falle):
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
	if Input.is_action_pressed("up"):
		animation_player.play("attack_up")
	else:
		animation_player.play("fight")

func dash():
	audio_player.play_audio(dash_audio)
	dashing = true
	get_time(-dash_price)
	dash_cooldown = dash_cooldown_duration_base + dash_cooldown_duration * dash_cooldown_reduction # +dashtime
	current_dash_speed = dash_speed
	var col1a = 1 +16
	collision_mask = col1a
	var col2a = 0
	$CollisionShape2D2/Damage_Area.collision_mask = col2a
	var col3a = 0
	collision_layer = col3a
	dash_timer.start()

func _on_dash_timer_timeout():
	dashing = false
	current_dash_speed = 1
	var col1b = 1 + 8 + 16 +128
	collision_mask = col1b
	var col2b = 2
	$CollisionShape2D2/Damage_Area.collision_mask = col2b
	var col3b = 32
	collision_layer = col3b

func update_animation():
	if alive:
		if !attacking:
			if is_on_floor():
				if velocity.x != 0:
					animation_player.play("walk")
				else:
					animation_player.play("idle")
			else:
				if velocity.y < 0:
					animation_player.play("jump")
				if velocity.y > 0:
					animation_player.play("fall") #später fall

func _on_jump_timer_timeout():
	JumpAvailability = false

func die():
	drop_bag()
	velocity = Vector2.ZERO
	alive = false
	var col2a = 0
	$CollisionShape2D2/Damage_Area.collision_mask = col2a
	Global.price_multi = 1
	#Global.coins = 0
	animation_player.play("death")
	#await (animation_player.animation_finished)

func drop_bag():
	var bag_scene = preload("res://assets/drops/bag_drop/bag.tscn")
	_add_new_bag(bag_scene)

func _add_new_bag(bag_scene):
	emit_signal("resetCoins")
	#emit_signal("add_bag", bag_scene)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death" and !alive:
		alive = false

		#Zum Village zurück
		emit_signal("going_back")
		#Zum Village zurück
		#var path = "res://scenes/Village.tscn"
		#emit_signal("going_back", path)

func new_spawn_position():
	if Global.new_position != null:
		position = Global.new_position
		Global.new_position = null

func disable():
	input_enabled = false
	#animation_player.play("idle")

func enable():
	input_enabled = true
	visible = true

func get_time(value):
	emit_signal("lifeChange", value)


func get_coins(value):
	coins += value
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
