class_name Level extends Node2D

@export var level_nr = 1
var bag_scene = preload("res://assets/drops/bag_drop/bag.tscn")
var save_user: save_User

@onready var bg_music = $Background
@onready var audio = $Audio_Stream
@onready var timer = $Timer
@export var character: Character

@export var visibleNotifier: VisibleOnScreenNotifier2D

# Called when the node enters the scene tree for the first time.
func _ready():
	bg_music.play()
	var user_save = save_User.load_save()
	var bag = find_child_bag()
	if bag:
		bag.hide()
		bag.show_interaction(false)
	if user_save && bag:
		if level_nr == user_save.level_nr:
			bag.show()
			bag.show_interaction(true)
			bag.position = user_save.bag_position
			bag.get_child(0).freeze = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func find_child_bag():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Bag":
			return child
	return null


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	self.show()

func _on_timer_timeout() -> void:
	self.hide()
	self.queue_free()


func _on_door_area_entered(area: Area2D) -> void:
	timer.start()
