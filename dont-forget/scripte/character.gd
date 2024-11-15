class_name Player
extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -850.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var JumpAvailability : bool
var animated_sprite : AnimatedSprite2D
@onready var JumpTimer : Timer = $Jump_Timer
@export var input_enabled:bool = true

func _ready():
	new_spawn_position()
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("idle")

func _physics_process(delta):
	if is_on_floor():
		JumpAvailability = true
		if velocity.x == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	else:
		if JumpAvailability and JumpTimer.is_stopped():
			JumpTimer.start()
		elif JumpTimer.is_stopped():
			velocity += get_gravity() * delta
			animated_sprite.play("fall")   # fall animation

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and JumpAvailability:
		velocity.y = JUMP_VELOCITY
		JumpAvailability = false
		animated_sprite.play("jump")   # jump animation
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_jump_timer_timeout():
	JumpAvailability = false

func new_spawn_position():
	if Global.new_position != null:
		position = Global.new_position

func disable():
	input_enabled = false
	#animation_player.play("idle")
	
func enable():
	input_enabled = true
	visible = true
