extends Control

@export var game_manager : Game_Manager
@onready var panel: Panel = $"../Panel"
@onready var panel_set_controls: Panel = $".."
@export var action_items: Array[String]


@onready var button_v_box: VBoxContainer = $ButtonVBoxContainer
@onready var settings_grid_container: GridContainer = %SettingsGridContainer
@onready var main_menu_button: Button = %Main_Button
@onready var return_to_game: Button = $Return_to_game
@onready var quit_button: Button = $Quit_Button
@onready var margin_container: MarginContainer = %MarginContainer

@onready var audio = $"../../../Audio_Stream"

func _on_close_btn_pressed():
	hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_action_remap_items()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_return_to_game_pressed() -> void:
	$"../../..".hide()


func create_action_remap_items() -> void:
	var previous_item: Button = settings_grid_container.get_child(settings_grid_container.get_child_count()-1)
	for index in range(action_items.size()):
		var action = action_items[index]
		var label = Label.new()
		label.text = action
		settings_grid_container.add_child(label)
		
		var button = RemapButton.new()
		button.action = action
		button.focus_neighbor_top = previous_item.get_path()
		previous_item.focus_neighbor_bottom = button.get_path()
		
		if index == action_items.size()-1:
			main_menu_button.focus_neighbor_top = button.get_path()
			button.focus_neighbor_bottom = main_menu_button.get_path()
		previous_item = button
		settings_grid_container.add_child(button)


func _on_input_type_button_item_selected(index: int) -> void:
	pass
