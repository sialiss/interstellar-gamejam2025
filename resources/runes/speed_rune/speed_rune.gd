extends RunePattern
class_name SpeedRune

func execute(player: Player) -> void:
	#print_debug("some logic in " + rune_name)
	var old_speed = player.speed
	var old_run = player.run_speed
	player.speed = 20
	player.run_speed = 25
	var timer = Timer.new()
	timer.wait_time = 15
	timer.one_shot = true
	timer.timeout.connect(func():
		player.speed = old_speed
		player.run_speed = old_run
		timer.queue_free()
	)
	player.add_child(timer)
	timer.start()
