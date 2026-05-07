extends CharacterBody2D

@onready var jump : AudioStreamPlayer2D = $Jump

const FLAP = 200.0
const MAX_FALL_SPEED = 200.0
const GRAVITY = 600.0
var is_dead: bool = false

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:

	velocity.y += GRAVITY * delta

	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

	if Input.is_action_just_pressed("ui_accept"):
		jump.pitch_scale = randf_range(0.9, 1.1)
		jump.play()
		velocity.y = -FLAP
		
	move_and_slide()


func _on_world_player_collision() -> void:
	if is_dead:
		return
	
	is_dead = true
	$CPUParticles2D.emitting = true
	$Sprite2D.hide()
	$PointLight2D.hide()
	$CollisionShape2D.hide()
	$Detect.hide()
	$Death.play()


func _on_button_pressed() -> void:
	jump.pitch_scale = randf_range(0.9, 1.1)
	jump.play()
	velocity.y = -FLAP
