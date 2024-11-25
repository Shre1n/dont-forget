extends Node2D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")
	animation_player.connect("animation_finished", self._on_animation_finished)

func take_damage(damage):
	animation_player.play("damage")

func _on_animation_finished(anim_name):
	if anim_name == "damage":
		animation_player.play("idle")
