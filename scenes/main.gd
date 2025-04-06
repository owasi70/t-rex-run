extends Node


#game variables

const DINO_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)

var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
var Score_Modifier : int = 10
var screen_size : Vector2i 
var ground_height : int
var score : int
var game_running : bool 
var Speed_Modifier : int = 5000

var barrel_scene= preload("res://scenes/barrel.tscn")
var bird_scene = preload("res://scenes/bird.tscn")
var stump_scene = preload("res://scenes/stump.tscn")
var rock_scene = preload("res://scenes/rock.tscn")

var obstacle_type = [stump_scene,barrel_scene,rock_scene]
var bird_height := [200, 390]
var last_obs

func _ready() -> void:
	screen_size = get_window().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	score = 0
	game_running = false
	$Dino.position = DINO_START_POS
	$Camera2D.position = CAM_START_POS
	$Dino.velocity = Vector2i(0, 0)
	$ground.position = Vector2(0, 0)
	$HUD.get_node("StartLabel").show()

func _process(delta):
	if game_running:
		speed = START_SPEED + score / Speed_Modifier
		
		generate_obs()
		
		$Dino.position.x += speed 
		$Camera2D.position.x += speed
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		
		
		score += speed
		show_score()
		
		if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
			$ground.position.x += screen_size.x
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / Score_Modifier)

func generate_obs():
	if obstacle_type.is_empty():
		var obs_type = obstacle_type[randi() % obstacle_type.size()]
		var obs
		obs = obs_type.instantiate()
		var obs_height =obs.get_node("Sprite2D").texture.get_height()
		var obs_scale = obs.get_node("Sprite2D").scale
		var obs_x : int = screen_size.x +score + 100
		var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
		last_obs = obs
		obs.position = Vector2i(obs_x, obs_y)
		add_child(obs)
		obstacle_type.append(obs)
