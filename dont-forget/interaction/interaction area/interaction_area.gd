extends Area2D

class_name InteractionArea

@export var action_name: String = "interact"
@export var body_of_character: Character 

var interact: Callable = func():
	pass


func _on_body_entered(body):
	if body.name == 'Character':
		body_of_character = body
		InteractionManager.register_area(self)
		


func _on_body_exited(body):
	if body.name == 'Character':
		body_of_character = null
		InteractionManager.unregister_area(self)
		
