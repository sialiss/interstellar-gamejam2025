extends Node

# todo: добавить сюда новые руны. Можно сделать удобнее с автозаполнением.
static var rune_patterns: Array[RunePattern] = [
	preload("res://resources/runes/test_rune/test_rune.tres"),
	preload("res://resources/runes/time_rune/time_rune.tres"),
	preload("res://resources/runes/fire_rune/fire_rune.tres"),
	preload("res://resources/runes/gigantism_rune/gigantism_rune.tres"),
	preload("res://resources/runes/enchantment_rune/enchantment_rune.tres"),
	preload("res://resources/runes/transformation_rune/transformation_rune.tres")
]

static var max_errors: int = 2 # Все руны должны состоять из n + 1 линий!

static func get_patterns() -> Array[RunePattern]:
	return rune_patterns

static func find_matching_rune_pattern(input_directions_array: Array[int]) -> RunePattern:
	var matched_rune: RunePattern = null
	var min_distance: float = 1000.0
	for rune in rune_patterns:
		var distance: float = calculate_array_distance(rune.directions_array, input_directions_array)
		if distance <= max_errors and distance < min_distance:
			min_distance = distance
			matched_rune = rune
	print(min_distance)
	if matched_rune != null and !matched_rune.is_pattern_known:
		EventBus.reveal_pattern(matched_rune)
		EventBus.trigger("Rune", matched_rune.rune_name)
	return matched_rune


static func calculate_array_distance(arr1: Array[int], arr2: Array[int]) -> float:
	var m: int = arr1.size()
	var n: int = arr2.size()

	var dp = []
	for i in range(m + 1):
		dp.append([])
		for j in range(n + 1):
			dp[i].append(0.0)
	for i in range(m + 1):
		dp[i][0] = i
	for j in range(n + 1):
		dp[0][j] = j

	for i in range(1, m + 1):
		for j in range(1, n + 1):
			var diff: int = abs(arr1[i - 1] - arr2[j - 1])
			if diff == 0:
				dp[i][j] = dp[i - 1][j - 1]
			else:
				var difference_cost: float = 0.25 if diff == 1 else 1.0
				dp[i][j] = min(
					dp[i - 1][j] + 1,
					dp[i][j - 1] + 1,
					dp[i - 1][j - 1] + difference_cost
				)
	var basic_distance = dp[m][n]
	var max_len = max(m, n)
	if max_len > 0:
		var relative_diff = abs(m - n) / float(max_len)
		if relative_diff > 0.2:
			basic_distance += relative_diff
	return basic_distance

static func arrays_equal(arr1: Array[int], arr2: Array[int]) -> bool:
	if arr1.size != arr2.size:
		return false
	for i in range(arr1.size()):
		if arr1[i] != arr2[i]:
			return false
	return true
