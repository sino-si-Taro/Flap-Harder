extends Control

func _on_pause_btn_pressed() -> void:
	$Paused.show()
	$NotPaused.hide()
	get_tree().paused = true


func _on_resume_btn_pressed() -> void:
	$Paused.hide()
	$NotPaused.show()
	get_tree().paused = false
