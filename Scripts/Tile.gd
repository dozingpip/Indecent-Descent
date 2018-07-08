tool
extends Spatial

export(String, "normal", "ice", "cracked", "sticky") var tile_type = "normal" setget set_type
var cracking_timer = 0

func set_type(new_value):
	tile_type = new_value
	if (Engine.is_editor_hint()):
		set_material("res://Materials/"+tile_type+"_tile.tres")
		self.add_to_group(tile_type)

func _ready():
	set_material("res://Materials/"+tile_type+"_tile.tres")
	self.add_to_group(tile_type)
	
func set_material(file_name):
	$Cube.set_surface_material(0, load(file_name))