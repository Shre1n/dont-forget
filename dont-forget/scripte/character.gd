class_name Character
extends CharacterBody2D

signal coinsChange(amount)
signal lifeChange(amount)
#Zurück zum Menü
signal going_back
#Zurück zum Dorf
#signal going_back(path)


@export var speed = 400.0
@export var jump_height = -450.0
@export var life = 100
@export var sword: bool = true


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var JumpAvailability : bool
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var JumpTimer : Timer = $Jump_Timer
@export var input_enabled:bool = true
@onready var animation_player = $AnimationPlayer
@onready var game_manager = find_game_manager()
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer

@export var orientation_left = false
@export var attacking = false
@export var alive = true
@export var damage_value: int = 10


func _ready():
	new_spawn_position()
	animation_player.play("idle")
	#game_manager.connect("death", Callable(self, "die"))


func _process(delta):
	if Input.is_action_just_pressed("attack") && sword:
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

		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("left", "right")
		if direction != 0:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	update_animation()
	move_and_slide()

func attack():
	#var overlapping_objects = $Attack_Area.get_overlapping_areas()
	attacking = true
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

func take_damage(damage):
	hit_flash_anim_player.play("hit_flash")
	emit_signal("lifeChange", -damage)

func get_time(value):
	emit_signal("lifeChange", value)

func get_coins(value):
	emit_signal("coinsChange", value)

func new_spawn_position():
	if Global.new_position != null:
		position = Global.new_position

func disable():
	input_enabled = false
	#animation_player.play("idle")

func enable():
	input_enabled = true
	visible = true


func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null


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
