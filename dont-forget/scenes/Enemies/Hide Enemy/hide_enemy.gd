extends "res://Templates/Enemy_Template/enemy_template.gd"



@export var stats_file: String = "res://gegner/hide.json"


@onready var hit: AnimationPlayer = $HitFlashPlayer
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var detection_area: CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var damage_area: CollisionShape2D = $DamageArea/CollisionShape2D
@onready var attack_area: Area2D =  $AttackArea

var start_position: Vector2

var original_position: Vector2
var player: Character = null
var min_pos: Vector2
var max_pos: Vector2

func _ready():
	super._ready()
	super.set_weapon(attack_area)
	load_stats()
	super.update_status()
	
	animationPlayer.play("idle")
	# Connect detection area signals
	detection_area.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
	animationPlayer.connect("animation_finished", Callable(self, "_on_dead_animation_finished"))

func _physics_process(delta: float) -> void:
	if !alive:
		return
	
	
	if player and !attacking:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < damage_area.scale.x*300:
			start_attack()
		else:
			chase_player()
	apply_gravity(delta)
	move_and_slide()
	
func start_attack():
	animationPlayer.play("attack")
	animationPlayer.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))
	

func start_new_behavior():
	animationPlayer.queue("idle")
	velocity = Vector2.ZERO

func chase_player():
	if player and !attacking:
		var direction_to_character = (player.global_position - global_position).normalized()
		direction = direction_calcX(direction_to_character)
		move_in_direction()
		flip_sprite(player)
		animationPlayer.play("run")

func load_stats():
	super.load_stats_from_file(stats_file)
	

func take_damage(damage, pierce, knockback_power_in, damage_position, falle):
	super.take_damage(damage, pierce, knockback_power_in, damage_position, falle)
	hit.play("hit_flash")
	
	if life <= 0:
		alive = false
		velocity = Vector2.ZERO
		animationPlayer.play("dead")
		animationPlayer.connect("animation_finished", Callable(self, "_on_dead_animation_finished"), CONNECT_ONE_SHOT)

func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "dead":
		animationPlayer.disconnect("animation_finished", Callable(self, "_on_dead_animation_finished"))  # Disconnect the signal to avoid multiple calls
		super.die()
		queue_free()
	if anim_name == "attack":
		attacking = false
		animationPlayer.play("idle")
	

func _on_detection_area_body_entered(body):
	if body is Character:
		super.flip_sprite(body)
		animationPlayer.play("awake")
		player = body  # Set player reference
		chase_player()  # Start chasing the player immediately

func _on_detection_area_body_exited(body):
	if body is Character and body == player and alive:
		animationPlayer.play_backwards("awake")
		start_new_behavior()
		player = null  # Stop chasing the player
		velocity = Vector2.ZERO  # Stop moving when the player leaves the range
