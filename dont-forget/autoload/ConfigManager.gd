extends Node

var enemy_types: Array = []
var config_loaded: bool = false
signal config_ready

const API_KEY = "37392788-5fa3-4aa3-aea9-608d7d1835e1"
const BASE_URL = "http://localhost:3000/api/godot"

@onready var http := HTTPRequest.new()

func _ready():
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	load_enemy_config()

func load_enemy_config():
	var url = BASE_URL + "/active-enemies"
	var headers = ["x-api-key: %s" % API_KEY]
	http.request(url, headers)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json_string = body.get_string_from_utf8()
		print("📦 Antwort vom Server:")
		print(json_string)

		var parsed = JSON.parse_string(json_string)

		if typeof(parsed) == TYPE_ARRAY:
			enemy_types = parsed
			config_loaded = true

			if enemy_types.size() > 0:
				print("✅ Enemy Config erfolgreich geladen!")
			else:
				print("⚠️ Antwort war leer – keine Gegner aktiv")

			print(enemy_types)
			emit_signal("config_ready")
		else:
			print("❌ Fehler beim Parsen der JSON-Antwort.")
	else:
		print("❌ Server hat Fehler zurückgegeben: ", response_code)
