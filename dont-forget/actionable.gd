extends Area2D

@export var dialogue_ressource: DialogueResource
@export var dialogue_start: String = "start_BS"

func action(): 
	DialogueManager.show_example_dialogue_balloon(dialogue_ressource, dialogue_start)
