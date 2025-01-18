extends Area2D

@export_category("Einstellungen")
@export var new_pos: Vector2
@export var falle: bool = true
@export var damage: float = 30

@onready var on_hit = $on_hit
@onready var on_enter = $on_enter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Character":
		body.position = new_pos
		on_enter.play()
		if falle:
			on_hit.play()
			body.get_time(-damage)
