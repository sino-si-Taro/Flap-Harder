extends StaticBody2D

var fired : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("warning")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if fired:
		position += Vector2(-6,0)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "warning":
		$Warning.hide()
		$Bullet.show()
		fired = true
