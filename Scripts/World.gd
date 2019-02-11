extends Node

var score = 0
var lvlGen
var num_level = 0

func _ready():
	lvlGen = $LevelGenerator

func _process(delta):
	if level_queue.size() >= level_queue_height:
		if ($Player.get_translation().y - lvlGen.top_y) < -(lvlGen.wall_height *2):
			num_level = lvlGen.queue_Delete_One_Add_One()
			get_node("ui/floor").set_text("Floor " + str(num_level))

func _on_Player_add_point():
	print("player got a point")
	score += 1
	get_node("ui/score").set_text("Score: " + str(score))