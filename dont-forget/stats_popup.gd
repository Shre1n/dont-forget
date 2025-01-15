extends Control



@export var player : Character
# Called when the node enters the scene tree for the first time.
func _ready():
	update_bars()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_stats_display(object, value):
	#var percentage = value / 3500
	object.value = value


func update_bars():
	update_stats_display($Panel/VBoxContainer/GridContainer/damage, player.damage_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/crit_damage, player.crit_dmg_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/pierce, player.pierce_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/resistence, player.res_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/imunity, player.imunity_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/cooldown, player.cooldown_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/attack_speed, player.attack_speed_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/speed, player.speed_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/jump_hight, player.jump_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/crit_chance, player.crit_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/knockback, player.knockback_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/knockback_res, player.knockback_res_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/extra_weight, player.extra_weight_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/dash_cooldown, player.dash_cooldown_stat)
	update_stats_display($Panel/VBoxContainer/GridContainer/dash_speed, player.dash_speed_stat)
