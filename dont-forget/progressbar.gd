extends ProgressBar

@onready var value_label = $ValueLabel

func _ready():
	update_value_display()

func _on_value_changed(value):
	update_value_display()

func update_value_display():
	if value_label:
		#value_label.text = str(value)  # Zeigt den aktuellen Wert der ProgressBar an
		value_label.text = str(value) + " / " + str(3500)
