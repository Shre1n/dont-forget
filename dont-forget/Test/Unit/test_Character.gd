extends GutTest

#Change to Actual Szene 
var Character = load("res://scripte/character.gd");
var Slime = load("res://slime.gd");
var Item = load("res://item.gd");
var Drop = load("res://drop.gd");

var _character;
var _slime;
var _item;
var _drop;

# Instanziate Nodes before each test
func before_each():
	_character = Player.new();
	
# Run following Code after each test
func after_each(): 
	# Prevent Orphan Node Leaks for no Memory Leaks in Game
	_character.free();  # Charakter freigeben
	_slime.free();  # Gegner freigeben
	_item.free();  # Item freigeben
	
# Test Character taken Damage
func test_take_damage():
	_character.hp = 100;
	var result = _character.take_damage(10);
	
	assert_eq(_character.hp, 90 , "HP should be 90");

# Test if Chracter dies after Time runs out
func test_character_loses_time_and_dies():
	_character.life_time = 1.0
	_character.max_time = 10.0
	var animated_sprite = AnimatedSprite2D.new()
	_character.add_child(animated_sprite)
	_character.animated_sprite = animated_sprite
	
	_character.animated_sprite.play("idle")
	
	await get_tree().create_timer(1.1).timeout
	_character._on_life_timer_timeout()
	
	assert_eq(_character.life_time, 0.0, "Timer should be 0 after running out")
	assert_true(_character.is_dead())

# Test boundary for Character Health to not be Zero
func test_taken_damage_not_below_zero():
	_character.hp = 5;
	_character.take_damage(10);
	
	assert_eq(_character.hp, 0, "HP should be 0");
	assert_true(_character.is_dead(), "Character should be dead");
	

# Test if Character dies if he has 0 HP
func test_attack_deals_damage():
	_character.hp = 0;
	_character.check_death();
	assert_true(_character.is_dead(), "Character should be dead at 0 HP")

# Test Characters Healing ability to add HP
func test_heal():
	_character.hp = 50;
	_character.max_hp = 100;
	_character.heal(30);
	
	assert_eq(_character.hp, 80, "HP should be 80 after healing 30");
	

# Test Characters healing boundary to not be greater than 100
func test_heal_not_above_max():
	_character.hp = 90;
	_character.max_hp = 100;
	_character.heal(20);
	
	assert_eq(_character.hp, 100, "HP should not exeed max HP");
	
	
	
# Attack and Enemy Section
func test_slime_damage():
	_slime.hp = 100;
	_character.attack(_slime);
	
	assert_eq(_slime.hp, 90, "Enemy HP should be 90 after attack if damage is 10");


# Test if Character can Attack the Enemy if he is in range
func test_attack_within_range():
	var enemy = Slime.new();
	enemy.hp = 100;
	enemy.position = Vector2(30,0);
	
	_character.position = Vector2(0,0);
	_character.attack(enemy);
	
	assert_eq(enemy.hp, 90, "Enemy HP should be reduced to 90 when within range");
	
	
# Test if Character can not hit an Enemy if he is not in range
func test_attack_outside_range():
	var enemy = Slime.new();
	enemy.hp = 100;
	enemy.position = Vector2(100,0);
	_character.position = Vector2(0,0);
	_character.attack(enemy);
	
	assert_eq(enemy.hp, 100, "Enemy HP should remain the same when outside range");
	
	
# Test if Character can pick up an Item and is in Inventory
func test_pick_up_item():
	var item = Item.new();
	_character.pick_up(item);
	
	assert_true(_character.inventory.has(item), "Item should be in inventory after picking up");
	

# Test if Character can move
func test_move_character():
	var start_position = _character.position;
	_character.move(Vector2(10,0)); # Character moves 10 Pixels to the right
	assert_eq(_character.position, start_position + Vector2(10,0), "Character should move to the right by 10");
	
	
	
# Stats Tests of Character

# Test the Dashcooldown from the Character to not Perform 2 Dashes Imidiatly after each other -> he has to wait the set cooldown
func test_set_dash_cooldown():
	_character.dash_cooldown = 5.0;
	
	assert_eq(_character.dash_cooldown, 5.0, "Dash cooldown should be 5.0 seconds");
	
	_character.perform_dash();
	var can_dash = _character.can_perform_dash();
	assert_false(can_dash, "Character should not be able to dash immediately after first dash");
	
	await wait_seconds(5.0);
	can_dash = _character.can_perform_dash();
	assert_true(can_dash, "Character should be acble to dash again after cooldown");
	
# Test if Characters moves after Dash in the right direction
func test_set_dash_range():
	_character.dash_range = 50;
	assert_eq(_character.dash_range, 50, "Dash range should be 50px");
	
	var start_position = _character.position();
	_character.perform_dash();
	
	assert_eq(_character.position, start_position + Vector2(50,0), "Character should move 50px in dash direction");
	
	
	
# Stats Tests for Enemy

# Tests the Attack probability for the slime
func test_feint_attack_probability():
	_slime.feint_attack_probability = 0.5;
	
	var feints = 0;
	for i in range(100):
		if _slime.should_feint_attack():
			feints += 1;
	
	assert_eq(feints > 40 && feints < 60, "Feint attacks should be approximately 50%");
	
	
# Test the fear multiplier for the slime
func test_fear_multiplier_effect():
	_slime.fear_multiplier = 2.0;
	
	var original_flee_duration = _slime.flee_direction;
	_slime.apply_fear();
	
	assert_eq(_slime.flee_duration, original_flee_duration * _slime.fear_multiplier, "Flee duration should be scaled by fear multiplier");
	

# Test if Character defeated Slime and is in range of drops (gold)
func test_gold_drop_within_pickup_range():
	_slime.gold_drop = 20;
	_character.position = Vector2(50, 50);
	_slime.position = Vector2(52, 50) ;

	_slime.drop_gold(_character);

	assert_eq(_character.gold, 20, "Character should receive 20 gold if within pickup range");

	_character.position = Vector2(100, 100);
	_slime.drop_gold(_character);
	assert_eq(_character.gold, 20, "Character should not receive additional gold when out of range");
	
# Test if Character defeated Slime and is in range of drops (gold)
func test_time_drop_within_pickup_range():
	_slime.time_drop = 5;
	_slime.hp = 10;
	_character.attack(_slime);
	
	assert_eq(_slime.hp, 0 , "Slimes hp should be 0");
	
	_character.position = Vector2(50, 50);
	_slime.position = Vector2(52, 50);
	
	_slime.drop_time(_character);

	assert_eq(_character.time, 5, "Character should receive 5 seconds if within pickup range");

	_character.position = Vector2(100, 100);
	_slime.drop_time(_character);
	assert_eq(_character.time, 5, "Character should not receive additional time when out of range");
