class_name Attack_Area
extends Area2D

@export var damage := 10
@export var enemy := true

func _init():
	collision_layer = 2
	collision_mask = 0
