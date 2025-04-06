extends CharacterBody2D

const GRAVITY : int = 4200
const JUMP_SPEED: int = -1800

func _ready() -> void:
	Global.player = self
	await get_tree().create_timer(3).timeout
	get_tree().call_group("obstucle", "hide")

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		$RunCol.disabled = false
		if Input.is_action_pressed("ui_accept"):
			velocity.y = JUMP_SPEED
			$jumpsound.play()
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite2D.play("duck")
		else:
			$AnimatedSprite2D.play("run")
			
	else:
		$AnimatedSprite2D.play("jump")
		
	move_and_slide()
	
	
	
