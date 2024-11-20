class_name Damage_Area
extends Area2D

@export var enemy := true

func _init():
	collision_layer = 0
	collision_mask = 2

func _ready():
	connect("area_entered", self._on_area_entered)


func _on_area_entered(hitbox: Attack_Area):
	if hitbox == null:
		return
	if enemy == hitbox.enemy:
		return
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
