class_name RevolutionTrigger extends Resource

signal triggered

func trigger():
	triggered.emit()
