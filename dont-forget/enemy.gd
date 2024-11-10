# Test Node

extends Node2D


var hp = 100;


func take_damage(amount):
	hp -= amount;
	if hp <= 0:
		die();

func die():
	print("Enemy defeated");
	queue_free();
