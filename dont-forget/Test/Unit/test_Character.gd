extends GutTest

#Change to Actual Szene 
var Character = load("res://character.gd");
var Enemy = load("res://enemy.gd");
var Item = load("res://item.gd");

var _character;
var _enemy;
var _item;

func before_each():
	_character = Character.new();
	
func after_each(): 
	# Prevent Orphan Node Leaks for no Memory Leaks in Game
	_character.free();  # Charakter freigeben
	_enemy.free();  # Gegner freigeben
	_item.free();  # Item freigeben
	
func test_take_damage():
	_character.hp = 100;
	var result = _character.take_damage(10);
	
	assert_eq(_character.hp, 90 , "HP should be 90");
	
func test_taken_damage_not_below_zero():
	_character.hp = 5;
	_character.take_damage(10);
	
	assert_eq(_character.hp, 0, "HP should be 0");
	assert_true(_character.is_dead(), "Character should be dead");
		

func test_attack_deals_damage():
	_character.hp = 0;
	_character.check_death();
	assert_true(_character.is_dead(), "Character should be dead at 0 HP")

func test_heal():
	_character.hp = 50;
	_character.max_hp = 100;
	_character.heal(30);
	
	assert_eq(_character.hp, 80, "HP should be 80 after healing 30");
	

func test_heal_not_above_max():
	_character.hp = 90;
	_character.max_hp = 100;
	_character.heal(20);
	
	assert_eq(_character.hp, 100, "HP should not exeed max HP");
	
func test_enemy_damage():
	var enemy = Enemy.new(); # Edit this for actual Enemy Node Name 'Character if Enemy is also a Character'
	enemy.hp = 100;
	_character.attack(enemy);
	
	assert_eq(enemy.hp, 90, "Enemy HP should be 90 after attack if damage is 10");
	enemy.free();
	
	
func test_pick_up_item():
	var item = Item.new();
	_character.pick_up(item);
	
	assert_true(_character.inventory.has(item), "Item should be in inventory after picking up");
	

func test_move_character():
	var start_position = _character.position;
	_character.move(Vector2(10,0)); # Character moves 10 Pixels to the right
	assert_eq(_character.position, start_position + Vector2(10,0), "Character should move to the right by 10");
