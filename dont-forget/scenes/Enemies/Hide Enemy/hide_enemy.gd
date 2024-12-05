extends "res://Templates/Enemy_Template/enemy_template.gd"

@export var chase_range: float  # Range within which the enemy starts chasing the player

@export var stats_file: String = "res://gegner/hide.json"


@onready var hit: AnimationPlayer = $HitFlashPlayer
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var detection_area: CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var damage_area: CollisionShape2D = $DamageArea/CollisionShape2D

var start_position: Vector2

var original_position: Vector2
var player: Character = null
var min_pos: Vector2
var max_pos: Vector2

func _ready():
	super._ready()
	load_stats()
	
	chase_range = detection_area.scale.x*100
	animationPlayer.play("idle")
	# Connect detection area signals
	detection_area.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
	animationPlayer.connect("animation_finished", Callable(self, "_on_dead_animation_finished"))

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func chase_player():
	if character:
		var direction_to_character = (character.global_position - global_position).normalized()
		direction = direction_calcX(direction_to_character)
		velocity.x = direction * speed_stat
		flip_sprite(character)

func load_stats():
	super.load_stats_from_file(stats_file)
	

func take_damage(damage, pierce, knockback_power_in, damage_position, falle):
	super.take_damage(damage, pierce, knockback_power_in, damage_position, falle)
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
	if body is Character:
		super.flip_sprite(body)
		animationPlayer.play("run")
		player = body  # Set player reference
		chase_player()  # Start chasing the player immediately

func _on_detection_area_body_exited(body):
	if body is Character and body == player:
		animationPlayer.play_backwards("awake")
		animationPlayer.queue("idle")
		player = null  # Stop chasing the player
		velocity = Vector2.ZERO  # Stop moving when the player leaves the range
