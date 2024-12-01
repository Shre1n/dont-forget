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
		var damage = calculate_end_damage(hitbox.damage,hitbox.crit_chance,hitbox.crit_multi)
		var pierce = damage * (hitbox.pierce_multi / 1000)
		var knockback = hitbox.knockback
		var knockback_power = calculate_stats_to_value(hitbox.knockback, 0.0, 1.0, 0.0, 5000.0, 3500.0)
		print(knockback_power)
		owner.take_damage(damage, pierce, knockback, knockback_power, hitbox.global_position, false)

func calculate_end_damage(damage,crit_chance,crit_multi):
	var is_crit = randi() % 1000 < crit_chance
	if is_crit:
		damage = damage + damage * (max(1, crit_multi) / 100)
	return damage

func calculate_stats_to_value(stat: int, span_start: float, span_end: float, min_value: float, max_value: float, divider: float = 1000.0) -> float:
	var stat_factor = clamp(stat / divider, span_start, span_end)
	return lerp(min_value, max_value, stat_factor)
