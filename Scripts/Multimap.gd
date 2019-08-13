extends Node

func _init():
	randomize()

# map is structured as such:
# map = {
# key1 : {values : [], weights : [], total_wieght}
# key2 : {values : [], weights : [], total_weight}
# ...
# }
# maybe should be pairs except for the fact that we sometimes want to wholesale edit all weights,
# and that's more annoying if they're all in separate pairs rather than one list
var map = {}

func new_key(key):
	map[key] = {}
	map[key]["values"] = []
	map[key]["weights"] = []
	map[key]["total_weight"] = 0

# currently no checking to see if total sum of weights is over 100%
func new_value_to_key(key, value, weight = 0, new_weights = null):
	map[key]["values"].append(value)
	map[key]["weights"].append(weight)
	map[key]["total_weight"] += weight
	if map[key]["total_weight"] > 1:
		print("when adding weight of " + weight +" warning total weight became greater than 1")
	if weight == 0 or new_weights or map[key]["total_weight"] > 1:
		readjust_weights(key, new_weights)

func readjust_weights(key, new_weights = null):
	if not new_weights:
		new_weights = evenlyDistributeWeights(key)
	map[key]["weights"] = new_weights

func contains(key):
	return map.has(key)

func evenlyDistributeWeights(key):
	var length = map[key]["values"].size()
	var new_weights = []
# warning-ignore:unused_variable
	for i in range(length):
		new_weights.append(1/length)
	map[key]["total_weight"] = 1
	return new_weights

func get_random_map_value(key):
	var myValues = map[key]["values"]
	var myWeights = map[key]["weights"]
	var randomNum = randf()
	var index = 0
	while index < myWeights.size() - 1:
		if randomNum < myWeights[index]:
			break
		randomNum -= myWeights[index]
		index+=1
	return myValues[index]
