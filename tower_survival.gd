extends Node2D

func _ready() -> void:
	get_tree().paused = false
	for i in range(5):
		spawn_mob()

func spawn_mob():
	#In the future this will also create the color of the mob
	#And it's random technique's
	var new_mob = preload("res://mob.tscn").instantiate()
	#Randomly create's the mob on a point along the path
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_timer_timeout() -> void:
	#Randomly choose spawn_swarm, spawn_cluster, spawn_boss 
	#later once levels are implemented
	spawn_mob()

func _on_player_death() -> void:
	print("Inside death")
	%game_over_screen.visible = true
	
func _on_restart_button_button_down() -> void:
	print("Inside restart button")
	%game_over_screen.visible = false
	get_tree().reload_current_scene()
