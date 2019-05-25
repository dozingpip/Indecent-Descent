extends Node

var score = 0
var lvlGen
var num_floor = 0

func game_over():
	pass

func _ready():
	lvlGen = $LevelGenerator

# warning-ignore:unused_argument
func _process(delta):
	if ($Player.get_translation().y - lvlGen.top_y) < -(lvlGen.wall_height *2):
		lvlGen.queue_Delete_One_Add_One()
	num_floor = 2 + (floor(-$Player.get_translation().y / lvlGen.wall_height))
	get_node("ui/floor").set_text("Floor " + str(num_floor))

func _on_Player_add_point():
	print("player got a point")
	score += 1
	get_node("ui/score").set_text("Score: " + str(score))