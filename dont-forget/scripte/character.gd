class_name Character
extends CharacterBody2D

signal healthChanged(amount)

@export var speed = 400.0
@export var jump_height = -450.0
@export var life = 100

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var JumpAvailability : bool
var animated_sprite : AnimatedSprite2D
@onready var JumpTimer : Timer = $Jump_Timer
@export var input_enabled:bool = true
@onready var animation_player = $AnimationPlayer

@export var orientation_left = false
@export var attacking = false

func _ready():
	new_spawn_position()
	animation_player.play("idle")


func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()
		update_animation()

func _physics_process(delta):
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
	life -= damage
	#if life > 0:
		#emit_signal("healthChanged", life)
	#else:
		#emit_signal("healthChanged", 0)

	#if life <= 0:
		#ResetPlayer()

func new_spawn_position():
	if Global.new_position != null:
		position = Global.new_position

func disable():
	input_enabled = false
	#animation_player.play("idle")

func enable():
	input_enabled = true
	visible = true
