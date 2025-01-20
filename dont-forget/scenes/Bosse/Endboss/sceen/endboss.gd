extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hitFlashPlayer: AnimationPlayer = $HitFlashPlayer
@onready var combo_timer: Timer = $ComboTimer
@onready var hit_area: Area2D = $i_will_hit_area
@onready var weapon: Area2D =  $AttackArea
@onready var special_timer = $Special_Attack_Timer

@export var attacking = false
@export var alive = true
@export var damaged: bool = false
@export var attack_range: float = 150.0  # Angriffsreichweite

@onready var Bg_Musik = $BG_Musik
@onready var scream = $Drexus_Sound

var knockback_speed: float = 300.0
@export var knockback_duration: float = 0.2
var is_knocked_back: bool = false
var knockback_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO

var knockback_speed_new : float
var post_knockback_timer = 0.0
var post_knockback_duration = 0.6  # Dauer der Nach-Knockback-Phase

@export var life_stat = 1000
@export var damage_stat = 1000
@export var crit_dmg_stat = 1000
@export var res_stat = 0
@export var speed_stat = 1000
@export var imunity_stat = 0
@export var pierce_stat = 1000  # Durchschlagskraft (Extra Schaden)
@export var crit_stat = 1000  # Kritische Trefferchance (0–1000 = 0–100%)
@export var knockback_stat = 1000  # Knockback-Stärke
@export var knockback_res_stat = 1000 # Knockback-Resistenz

var life
var damage
var speed
var resistenz
var imunity
var knockback_res
var all_stats 
var weight

var elite = true
var mini_boss = false

var combo_phase: int = 0
var phase: int = 1  # Boss starting Phase
var orientation_left: bool = true
@export var character: Character = null
var character_chase: bool = false
var direction: int = 0
@export var bomb = false
@export var contact = false

signal boss_defeated(boss_name: String)
signal boss_engaged(boss_name: String)

@export var max_health: int = 100
var current_health: int = max_health

var drop := preload("res://scenes/drop.tscn")
var current_Itemholder

var combo2_attack = false
var direction_to_character
var player_head = false

@export var phase2Test = false

func _ready():
	Bg_Musik.play()
	update_status()
	animationPlayer.play("idle")
	$"Detection Area".monitoring = true
	if phase2Test:
		take_damage(5001, 0, 0, 0, false)

func update_status():
	max_health = calculate_stats_to_value(life_stat, 0.0, 1.0, 0.0, 3500.0, 3500.0)
	if elite:
		max_health = max_health * 10
	elif mini_boss:
		max_health = max_health * 100
	current_health = max_health
	speed = calculate_stats_to_value(speed_stat, 0.0 , 1.0, 20.0, 600.0, 3500.0) 
	resistenz = calculate_stats_to_value(res_stat, 0.0, 1.0, 0.0, 7000.0, 3500.0)
	imunity = calculate_stats_to_value(imunity_stat, 0.0, 1.0, 1, 0.01, 3500.0)
	knockback_res = calculate_stats_to_value(knockback_res_stat, 0.0, 1.0, 1, 0.01, 3500.0)
	all_stats = life_stat + damage_stat + crit_dmg_stat + res_stat + speed_stat + imunity_stat + pierce_stat + crit_stat + knockback_stat + knockback_res_stat
	weight = min(490, all_stats / 100)
	
	if weapon:
		weapon.damage = max(1, damage_stat)
		weapon.pierce_multi = pierce_stat
		weapon.crit_chance = crit_stat
		weapon.crit_multi = max(1, crit_dmg_stat)
		weapon.knockback = knockback_stat
	#else:
		#print("No weapon")

func calculate_stats_to_value(stat: int, span_start: float, span_end: float, min_value: float, max_value: float, divider: float = 1000.0) -> float:
	var stat_factor = clamp(stat / divider, span_start, span_end)
	return lerp(min_value, max_value, stat_factor)

func _physics_process(delta):
	#print(character)
	#print(character.position)
	#print(velocity)
	
	#print("attacking: ",attacking)
	#print("Bomb: ",bomb)
	#print("contact: ",contact)
	#print("is_knocked_back: ",is_knocked_back)
	#print("alive: ",alive)
	#print("phase: ",phase)
	#print("Health: ",current_health)
	#print("player_head: ",player_head)
	
	if alive:
		apply_gravity(delta)
		#print("attacking: ",attacking)
		if !attacking:
			#print("test")
			if is_knocked_back and !bomb:
				handle_knockback(delta)
			#elif is_on_floor() and bomb:
				#bomb = false
				#$Damage_Area.monitoring = true
				#animationPlayer.play("idle")
				#$Special_Attack_Timer.start()
			elif bomb:
				#print("bombe")
				move_in_direction()
			elif !contact:
				#print("fangen")
				chase_character()
		move_and_slide()
		update_animation()

func handle_knockback(delta):
	if knockback_timer > 0:
		# Wende Knockback an
		knockback_timer -= delta
		velocity.x = knockback_direction.x * knockback_speed_new
	elif post_knockback_timer > 0:
		# Reduziere Geschwindigkeit nach Knockback
		post_knockback_timer -= delta
		velocity = velocity.move_toward(Vector2.ZERO, knockback_speed_new * delta)
		if velocity.length() < 10:  # Geschwindigkeitsschwelle für Ende der Nach-Knockback-Phase
			velocity = Vector2.ZERO
			post_knockback_timer = 0
			is_knocked_back = false
	else:
		# Knockback abgeschlossen
		is_knocked_back = false

func take_damage(damage, pierce, knockback_power_in, damage_position, falle):
	var effective_damage = ceil((max(1, damage - resistenz) + pierce) * imunity)
	var knockback_effect = knockback_power_in * knockback_res
	current_health -= effective_damage
	damaged = true
	hitFlashPlayer.play("hit_flash")
	#print("life: ",current_health)
	if current_health <= max_health / 2 and phase == 1:
		start_phase_2()
	if current_health <= 0:
		die()
	if (knockback_effect) > weight:
		knockback(knockback_effect, damage_position)

func knockback(knockback, damage_position):
	if character:
		knockback_direction.x = direction_calcX((global_position - character.global_position).normalized())
		knockback_speed_new = knockback
		knockback_timer = 0.2
		post_knockback_timer = post_knockback_duration
		is_knocked_back = true

func start_phase_2():
	phase = 2
	special_timer.start()
	#print("Boss entered Phase 2")

func update_animation():
	if !alive or damaged or bomb:
		#print("fuck yes noooooo!")
		#print("alive: ",alive)
		#print("damaged: ",damaged)
		#print("bomb: ",bomb)
		return
		
	if attacking:
		#print("fuuuuuck")
		return
	
	if velocity.x == 0:
		#print("du hurensohn")
		#print(velocity.x)
		animationPlayer.play("idle")
	elif velocity.x != 0:
		#print("ich hasse dich")
		#print(velocity.x)
		flip_sprite(character)
		animationPlayer.play("run")

func flip_sprite(body: Character):
	# Calculate the player's relative position to the enemy
	var relative_position = body.global_position.x - global_position.x

	# If the player is on the right and the enemy is facing left, flip to the right
	if relative_position < 0 and orientation_left:
		$".".scale.x *= -1
		orientation_left = false
	# If the player is on the left and the enemy is facing right, flip to the left
	elif relative_position > 0 and !orientation_left:
		$".".scale.x *= -1
		orientation_left = true

func apply_gravity(delta):
	if !is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta * 2
	elif bomb and is_on_floor_only() and velocity.y == 0 :#and !player_head:
		print("boden")
		#print("applay gravity bommmmmbbbbbeeeee")
		bomb = false
		#velocity.y = 0
		$Damage_Area.monitoring = true
		$Attack_Area.monitorable = false
		$playerhead.monitoring = false
		animationPlayer.play("idle")
		$Special_Attack_Timer.start()
	#elif !bomb:
		#velocity.y = 0

func attack():
	if phase == 1:
		#print("fucking cunt, attttttack")
		$Attack_Timer.start()
		#perform_attack()
	elif phase == 2:
		perform_phase_2_attack()

func perform_attack():
	flip_sprite(character)
	attacking = true
	animationPlayer.play("attack")

func perform_phase_2_attack():
	if is_on_floor() and combo_phase == 0:
		var random_action = randi() % 2
		if random_action != 0:
			#print("lol you idiot, fuuuuuk")
			perform_combo_attack()
		else:
			#print("im a nice little cunt")
			perform_combo2_attack()

func perform_combo_attack():
	#combo_phase = 0
	if combo_phase == 0:
		#print("Boss starts combo attack (left-right-left).")
		flip_sprite(character)
		combo_phase = 1
		perform_attack()
	elif combo_phase == 1:
		combo_phase = 2
		perform_attack()
	elif combo_phase == 2:
		combo_phase = 0
		perform_attack()
		$Attack_Timer.start()
		return
	combo_timer.start()

func perform_combo2_attack():
	#combo_phase = 0
	if combo_phase == 0:
		combo2_attack = true
		#print("Boss starts combo attack (left-right-left).")
		flip_sprite(character)
		combo_phase = 1
		perform_attack()
	elif combo_phase == 1:
		combo_phase = 2
		if orientation_left:
			$".".scale.x *= -1
			orientation_left = false
		elif !orientation_left:
			$".".scale.x *= -1
			orientation_left = true
		attacking = true
		animationPlayer.play("attack")
	elif combo_phase == 2:
		combo_phase = 0
		combo2_attack = false
		if orientation_left:
			$".".scale.x *= -1
			orientation_left = false
		elif !orientation_left:
			$".".scale.x *= -1
			orientation_left = true
		attacking = true
		animationPlayer.play("attack")
		$Attack_Timer.start()
		return
	combo_timer.start()


func perform_bomb_attack():
	bomb = true
	attacking = false
	player_head = false
	#var direction_to_character = (character.global_position - global_position).normalized()
	direction_to_character = Vector2(character.global_position.x - global_position.x, 0).normalized()
	direction = direction_calcX(direction_to_character)
	flip_sprite(character)
	#position = Vector2(0,0)
	#print(velocity)
	#print("faaaatttt bitch juuuummmp, fuuuuuuuuuuuuck yooooou")
	animationPlayer.play("bombe")
	velocity.y = -4000


func move_in_direction():
	if abs(global_position.x - direction_to_character.x) < 1:
		velocity.x = 0
		return
	# Move the enemy based on the direction (left, right, or idle)
	velocity.x = direction * speed * 2 #oder höher looooool

func die():
	alive = false
	animationPlayer.play("dead")
	emit_signal("boss_defeated")

	

#func _on_detection_area_body_entered(body: Node2D) -> void:
	#if body is Character:
		##print("how dare you")
		#animationPlayer.play("run")
		##character = body

func chase_character():
	if character and alive:
		var direction_to_character = (character.global_position - global_position).normalized()
		direction = direction_calcX(direction_to_character)
		velocity.x = direction * speed

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

func _on_combo_timer_timeout():
	if combo2_attack:
		perform_combo2_attack()
	else:
		perform_combo_attack()

func _on_special_attack_timer_timeout():
	perform_bomb_attack()

func _on_i_will_hit_area_body_entered(body):
	if body is Character and alive:
		#print("fuuuckkking goooo bitch")
		#print("ist er schon drin")
		contact = true
		attack()

func _on_i_will_hit_area_body_exited(body):
	if body is Character:
		#print("exit")
		contact = false
		$Attack_Timer.stop()

func _on_attack_timer_timeout():
	if !attacking and !bomb and alive:
		#print("oh noooooooo im tooo stupid")
		perform_attack()
	if contact and alive:
		$Attack_Timer.start()

func _on_playerhead_body_entered(body):
	if body is Character and alive:
		player_head = true
		perform_bomb_attack()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dead": 
		queue_free()
	
