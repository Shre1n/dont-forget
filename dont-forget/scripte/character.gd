class_name Player
extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -450.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var JumpAvailability : bool
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var JumpTimer : Timer = $Jump_Timer


var timer: Timer

func _ready():
	if animated_sprite == null:
		print("Error: AnimatedSprite2D not found!")
	else:
		animated_sprite.play("idle")
	
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.connect("timeout",Callable(self, "_on_life_timer_timeout"))
	add_child(timer)
	timer.start()

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

func _on_life_timer_timeout():
	life_time -= 1.0
	if life_time <= 0:
		die()

func is_dead() -> bool:
	return life_time <= 0

func die():
	animated_sprite.play("death")
	#get_tree().change_scene_to_file("res://scenes/village.tscn")
