# Test Node

extends Node2D

var attack_damage = 10;


var hp = 100;
var max_hp = 100;

func take_damage(amount):
	hp = max(hp - amount, 0);

func is_dead() -> bool:
	return hp == 0;

func check_death() -> bool:
	return hp <= 0;

func heal(amount):
	hp = min(hp + amount, max_hp);


func attack(enemy):
	if is_instance_valid(enemy):
		if position.distance_to(enemy.position) < 50:
			enemy.take_damage(attack_damage)
		else:
			print("Enemy out of range.");
	else:
		print("Enemy does not exist.")
	
