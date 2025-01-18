extends Node2D

@onready var animation_player = $AnimationPlayer
@export var visible_: VisibleOnScreenEnabler2D

func _ready():
	animation_player.connect("animation_finished", self._on_animation_finished)

func take_damage(damage, pierce, knockback, position, falle):
	animation_player.play("damage")

func _on_animation_finished(anim_name):
	if anim_name == "damage":
		animation_player.play("idle")


func _on_dummy_visible_screen_entered() -> void:
	self.visible = true
	animation_player.play("idle")


func _on_dummy_visible_screen_exited() -> void:
	self.visible = false
	animation_player.stop()
