extends Node

func _init():
	randomize()
	pass

var keys = []
var values = []
var weights = []
func append(new_key, new_values, new_weights = null):
	keys.append(new_key)
	values.append(new_values)
	if(new_weights == null):
		new_weights = evenlyDistributeWeights(new_key)
	weights.append(new_weights)

func ContainsKey(key):
	return keys.has(key)

func evenlyDistributeWeights(key):
	var keyIndex = keys.find(key)
	var myValues = values[keyIndex]
	var length = myValues.size()
	var new_weights = []
	for i in range(length):
		new_weights.append(1/length)
	return new_weights

func addNewValueToKey(key, newValue, new_weights = null):
	var keyIndex = keys.find(key)
	values[keyIndex].append(newValue)
	if new_weights == null:
		new_weights = evenlyDistributeWeights(key)

func get_random_map_value(i):
	var keyIndex = keys.find(i)
	var myValues = values[keyIndex]
	var myWeights = weights[keyIndex]
	var randomNum = randf()
	var index = 0
	while index < myWeights.size() - 1:
		if randomNum < myWeights[index]:
			break
		randomNum -= myWeights[index]
		index+=1
	return myValues[index]
