extends "res://Templates/Enemy_Template/enemy_template.gd"

@export var chase_range: float  # Range within which the enemy starts chasing the player
@export var damage: float = 10


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
	
	chase_range = detection_area.scale.x*100
	animationPlayer.play("idle")
	# Connect detection area signals
	detection_area.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
	animationPlayer.connect("animation_finished", Callable(self, "_on_dead_animation_finished"))

func _physics_process(delta: float) -> void:
	pass

func take_damage(damage: int):
	pass

func _on_animation_player_animation_finished(anim_name: String):
	pass
	

func _on_detection_area_body_entered(body):
	pass

func _on_detection_area_body_exited(body):
	pass

func _on_attack_area_body_entered(body):
	if !alive:
		return
	if body is Character:
		body.take_damage(damage)

func _on_damage_area_body_entered(body):
	super._on_damage_area_body_entered(body)
