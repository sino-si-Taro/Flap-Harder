extends StaticBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position += Vector2(-2,0)


func _on_detect_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$AnimationPlayer.play("open")
