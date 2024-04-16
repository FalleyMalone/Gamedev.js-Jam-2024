extends Sprite2D

var can_fire = true
var bullet = preload("res://Scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true) # Replace with function body.

func _physics_process(_delta):
	position.x = lerp(position.x, get_parent().position.x, 1)
	position.y = lerp(position.y, get_parent().position.y+5, 1)
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	if Input.is_action_pressed("Fire") && can_fire:
		var bullet_instance = bullet.instantiate()
		bullet_instance.rotation = rotation
		bullet_instance.global_position = get_global_position()
		get_parent().add_child(bullet_instance)
		can_fire = false
		await get_tree().create_timer(1).timeout
		can_fire = true

# Called every frame. 'delta' is the elapsed time since the previous frame.

