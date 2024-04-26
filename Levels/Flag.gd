extends Area2D
signal end


func _physics_process(_delta):
	set_physics_process(false)

func _on_body_entered(_body):
	print("flag")
	emit_signal("end")
