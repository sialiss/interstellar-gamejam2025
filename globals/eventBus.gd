extends Node

# Сигналы
signal rune_unlocked(rune: RunePattern)
signal rune_name_revealed(rune: RunePattern)
signal rune_pattern_revealed(rune: RunePattern)

# Открытие имени руны
func reveal_name(rune: RunePattern):
	if not rune.is_name_known:
		rune.is_name_known = true
		emit_signal("rune_name_revealed", rune)
		emit_signal("rune_unlocked", rune)

# Открытие изображения (паттерна)
func reveal_pattern(rune: RunePattern):
	if not rune.is_pattern_known:
		rune.is_pattern_known = true
		emit_signal("rune_pattern_revealed", rune)
		emit_signal("rune_unlocked", rune)

# Полное открытие (имя + картинка)
func reveal_all(rune: RunePattern):
	var was_locked = (not rune.is_name_known) or (not rune.is_pattern_known)
	rune.is_name_known = true
	rune.is_pattern_known = true
	if was_locked:
		emit_signal("rune_unlocked", rune)
