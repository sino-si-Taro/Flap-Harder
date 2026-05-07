extends CanvasLayer

# 🌍 Preload the World scene
var world = preload("res://scenes/world.tscn")

func _on_button_pressed() -> void:

	# ➕ Add to scene tree
	get_tree().change_scene_to_file("res://scenes/world.tscn")
