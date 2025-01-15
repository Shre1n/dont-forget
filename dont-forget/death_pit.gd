extends Area2D

@export_category("Einstellungen")
@export var new_pos: Vector2
@export var falle: bool = true
@export var damage: float = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Character":
		body.position = new_pos
		if falle:
			body.get_time(-damage)
