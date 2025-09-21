extends Node

# todo: добавить сюда новые руны. Можно сделать удобнее с автозаполнением.
static var rune_patterns: Array[RunePattern] = [
	preload("res://resources/runes/test_rune/test_rune.tres"),
	preload("res://resources/runes/speed_rune/speed_rune.tres"),

]

static func get_patterns() -> Array[RunePattern]:
	return rune_patterns


static func find_matching_rune_pattern(input_directions_array: Array[int]) -> RunePattern:
	for rune in rune_patterns:
		if arrays_equal(rune.directions_array, input_directions_array):
			if !rune.is_pattern_known:
				EventBus.reveal_pattern(rune)
			return rune
	return null


static func arrays_equal(arr1: Array[int], arr2: Array[int]) -> bool:
	if arr1.size != arr2.size:
		return false
	for i in range(arr1.size()):
		if arr1[i] != arr2[i]:
			return false
	return true
