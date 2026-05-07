extends Node2D

signal player_collision

# 🧱 SCENES
@export var wall_scene : PackedScene = preload("res://scenes/wall.tscn")
@export var bullet_scene : PackedScene

# 🎬 COMPONENTS
@export var mysterious_noise : AudioStreamPlayer2D
@export var anim : AnimationPlayer
@export var reset_timer : Timer

# ⚙️ SETTINGS
@export var spawn_count: int = 5
@export var spawn_spacing: int = 200
@export var spawn_y_range: Vector2 = Vector2(-60, 60)

# 📦 TRACK OBJECTS
var walls: Array = []
var bullets: Array = []


func _ready() -> void:
	# 📂 load saved score
	GameManager.load_game()

	# 🏆 show best score
	$CanvasLayer/BestScore.text = "Best: " + str(GameManager.best_score)

	# 🧱 spawn starting walls
	for i in range(spawn_count):
		spawn_wall()


func _process(_delta: float) -> void:
	if GameManager.score >= 5 and not GameManager.rotated_45:
		mysterious_noise.play()
		GameManager.rotated_45 = true
		anim.play("warning")

	elif GameManager.score >= 10 and not GameManager.rotated_90:
		mysterious_noise.play()
		GameManager.rotated_90 = true
		anim.play("warning")

	elif GameManager.score >= 15 and not GameManager.rotated_180:
		mysterious_noise.play()
		GameManager.rotated_180 = true
		anim.play("warning")

	if GameManager.score >= 20: anim.play("RESET")

# 🧱 SPAWN WALL
func spawn_wall() -> void:
	var wall_instance = wall_scene.instantiate()

	# 🎲 random Y
	var random_y = randf_range(spawn_y_range.x, spawn_y_range.y)

	# ➡️ position based on last wall
	var spawn_x = 450
	if walls.size() > 0:
		var last_wall = walls[walls.size() - 1]
		spawn_x = last_wall.position.x + spawn_spacing

	wall_instance.position = Vector2(spawn_x, random_y)

	add_child(wall_instance)
	walls.append(wall_instance)

# 🔫 SPAWN BULLET
func spawn_bullet() -> void:
	if bullet_scene == null:
		return
	
	var bullet = bullet_scene.instantiate()

	var spawn_x = 350
	var random_y = randf_range(spawn_y_range.x, spawn_y_range.y)

	bullet.position = Vector2(spawn_x, random_y)

	add_child(bullet)
	bullets.append(bullet) # 📌 track bullets

# ⏱️ RANDOM BULLET SPAWNER
func _on_timer_timeout() -> void:
	# 🎲 only spawn bullets after score 20
	if randi() % 2 == 0 and GameManager.score >= 20:
		spawn_bullet()

# 🧹 CLEANUP (walls & bullets)
func _on_resetter_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls"):
		walls.erase(body)
		body.call_deferred("queue_free")
		call_deferred("spawn_wall") # ♻️ replace wall

	elif body.is_in_group("Bullets"):
		bullets.erase(body)
		body.call_deferred("queue_free") # ❌ no respawn

# 🎯 SCORE SYSTEM
func _on_detect_area_entered(area: Area2D) -> void:
	if area.name == "PointArea":
		GameManager.score += 1

		# 🏆 check best score
		if GameManager.score > GameManager.best_score:
			GameManager.best_score = GameManager.score
			GameManager.save_game() # 💾 save instantly

		# 🖥️ update UI
		$CanvasLayer/Score.text = "Score: " + str(GameManager.score)
		$CanvasLayer/BestScore.text = "Best: " + str(GameManager.best_score)

# 💀 PLAYER COLLISION
func _on_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls") or body.is_in_group("Bullets"):

		# 🔄 reset game state
		GameManager.score = 0
		GameManager.rotated_45 = false
		GameManager.rotated_90 = false
		GameManager.rotated_180  = false

		emit_signal("player_collision")
		reset_timer.start()

# 🎬 ANIMATION EVENTS
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "warning":
		if GameManager.score >= 15:
			anim.play("rotate180")
		elif GameManager.score >= 10:
			anim.play("rotate90")
		else:
			anim.play("rotate45")

		GameManager.gravity = false

# 🔄 RESTART GAME
func _on_reset_timer_timeout() -> void:
	GameManager.score = 0
	get_tree().call_deferred("reload_current_scene")
