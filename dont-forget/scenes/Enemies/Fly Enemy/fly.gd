extends "res://Templates/Enemy_Template/enemy_template.gd"


@export var fly_radius_x: float = 100.0
@export var fly_radius_y: float = 100.0
@export var fly_rotation_speed: float = 2.0
@export var fly_speed: float = 150.0  # Custom flying speed
@export var fly_height: float = 50.0  # The height the flying enemy moves up and down
@export var fly_range: float = 200.0  # The horizontal range of movement
@export var hit_flash_time: float = 0.2  # Duration of the hit flash
@export var chase_range: float  # Range within which the enemy starts chasing the player

@export var stats_file: String = "res://gegner/fly.json"

@onready var chase: AnimationPlayer = $Chase
@onready var hit: AnimationPlayer = $HitFlashPlayer
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var detection_area: CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var damage_area: CollisionShape2D = $DamageArea/CollisionShape2D
@onready var child_weapon: Area2D = $AttackArea

var angle: float = 0.0
var start_position: Vector2

var original_position: Vector2
var player: Character = null
var min_pos: Vector2
var max_pos: Vector2

func _ready():
	super._ready()
	super.set_weapon(child_weapon)
	#load_stats()
	
	super.load_stats_from_file(stats_file)
	super.apply_profile_data()
	super.special_load()
	super.update_start_stats()
	super.update_status()
	super.start_new_behavior()
	
	original_position = global_position
	start_position = position
	min_pos = start_position
	max_pos = start_position
	min_pos.x -= 10
	max_pos.x += 10
	min_pos.y -= 10
	max_pos.y += 10
	chase_range = detection_area.scale.x*5
	animationPlayer.play("idle")
	# Connect detection area signals
	detection_area.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
	animationPlayer.connect("animation_finished", Callable(self, "_on_dead_animation_finished"))
	
	
func load_stats():
	super.load_stats_from_file(stats_file)


func _physics_process(delta):
	# Custom flying movement
	
	if alive and not player:
		
		if position == start_position:
			fly_around_origin(delta)
		
		if position.distance_to(start_position) > damage_area.scale.x:
			if start_position.x <= position.x:
				velocity.x = -speed_stat
			else:
				velocity.x = speed_stat  # Constant horizontal speed
			if start_position.y <= position.y:
				velocity.y = -speed_stat
			else:
				velocity.y = speed_stat
		else:
			velocity = Vector2.ZERO

	# If player is within range, start chasing
	if player and global_position.distance_to(player.global_position) >= chase_range:
		chase_player()

	# Call the parent's handle_knockback() to manage knockback behavior
	super.handle_knockback(delta)
	move_and_slide()

func fly_around_origin(delta):
	angle += fly_rotation_speed * delta
	
	global_position.x += cos(angle)* fly_radius_x
	global_position.y += sin(angle) * fly_radius_y

func chase_player():
	# Move towards the player
	if player:
		var direction_to_player = (player.global_position - global_position).normalized()
		velocity.x = direction_to_player.x * fly_speed  # Move horizontally towards the player
		velocity.y = direction_to_player.y * fly_speed  # Move vertically towards the player
		flip_sprite(player)

func take_damage(damage, pierce, knockback_power_in, damage_position, falle):
	# Custom damage logic (for example, hit flash effect or other special behavior)
	# Call the parent's take_damage method to handle the core damage logic
	super.take_damage(damage, pierce, knockback_power_in, damage_position, falle)
	hit.play("hit_flash")
	
	if life <= 0:
		$AttackArea.monitorable = false
		animationPlayer.play("dead")
		animationPlayer.connect("animation_finished", Callable(self, "_on_dead_animation_finished"))

func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "dead":
		animationPlayer.disconnect("animation_finished", Callable(self, "_on_dead_animation_finished"))  # Disconnect the signal to avoid multiple calls
		super.die()
		queue_free()
	

func _on_detection_area_body_entered(body):
	# Triggered when the player enters the detection area
	if body is Character:
		super.flip_sprite(body)
		chase.play("chase")
		player = body  # Set player reference
		chase_player()  # Start chasing the player immediately

func _on_detection_area_body_exited(body):
	# Triggered when the player exits the detection area
	if body is Character and body == player:
		chase.play("lost")
		player = null  # Stop chasing the player
		velocity = Vector2.ZERO  # Stop moving when the player leaves the range
