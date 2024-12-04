extends "res://Templates/Enemy_Template/enemy_template.gd"

@export var fly_speed: float = 150.0  # Custom flying speed
@export var fly_height: float = 50.0  # The height the flying enemy moves up and down
@export var fly_range: float = 200.0  # The horizontal range of movement
@export var hit_flash_time: float = 0.2  # Duration of the hit flash
@export var chase_range: float  # Range within which the enemy starts chasing the player
@export var damage_of_fly_enemy: int = 10

@onready var hit: AnimationPlayer = $HitFlashPlayer
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var detection_area_size: CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var hitbox: CollisionShape2D = $DamageArea/CollisionShape2D
var start_position: Vector2

var original_position: Vector2
var player: Character = null
var min_pos: Vector2
var max_pos: Vector2

func _ready():
	super._ready()
	original_position = global_position
	start_position = position
	min_pos = start_position
	max_pos = start_position
	min_pos.x -= 10
	max_pos.x += 10
	min_pos.y -= 10
	max_pos.y += 10
	chase_range = detection_area_size.scale.x*100
	animationPlayer.play("idle")
	# Connect detection area signals
	detection_area.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
	animationPlayer.connect("animation_finished", Callable(self, "_on_dead_animation_finished"))
	
func _physics_process(delta):
	# Custom flying movement
	
	if alive:
		if position.distance_to(start_position) > hitbox.scale.x:
			if start_position.x <= position.x:
				velocity.x = -fly_speed
			else:
				velocity.x = fly_speed  # Constant horizontal speed
			if start_position.y <= position.y:
				velocity.y = -fly_speed
			else:
				velocity.y = fly_speed
		else:
			velocity = Vector2.ZERO

	# If player is within range, start chasing
	if player and global_position.distance_to(player.global_position) <= chase_range:
		chase_player()

	# Call the parent's handle_knockback() to manage knockback behavior
	super.handle_knockback(delta)
	move_and_slide()

func chase_player():
	# Move towards the player
	if player:
		var direction_to_player = (player.global_position - global_position).normalized()
		velocity.x = direction_to_player.x * fly_speed  # Move horizontally towards the player
		velocity.y = direction_to_player.y * fly_speed  # Move vertically towards the player
		flip_sprite(player)

func take_damage(damage: int):
	# Custom damage logic (for example, hit flash effect or other special behavior)
	# Call the parent's take_damage method to handle the core damage logic
	super.take_damage(damage)
	hit.play("hit_flash")
	
	if life <= 0:
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
		player = body  # Set player reference
		chase_player()  # Start chasing the player immediately

func _on_detection_area_body_exited(body):
	# Triggered when the player exits the detection area
	if body is Character and body == player:
		player = null  # Stop chasing the player
		velocity = Vector2.ZERO  # Stop moving when the player leaves the range

func _on_attack_area_body_entered(body):
	if !alive:
		return
	if body is Character:
		body.take_damage(damage_of_fly_enemy)

func _on_damage_area_body_entered(body):
	super._on_damage_area_body_entered(body)
