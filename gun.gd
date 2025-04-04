extends Area2D

var cooldown = 0.5
var time = 0.0


func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if(enemies_in_range.size() > 0):
		var target = enemies_in_range.front()
		look_at(target.global_position)
	if(time >= cooldown):
		shoot()
		time = 0.0
		
func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = $%shooting_point.global_position
	new_bullet.global_rotation = $%shooting_point.global_rotation
	$%shooting_point.add_child(new_bullet)

	
	
func _on_timer_timeout() -> void:
	time += 0.1
