extends Node2D

var time = 0.0

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
	
func spawn_object():
	#later will be a random object now is just a tree soo to be pillar.
	const PILLAR = preload("res://pillar.tscn")
	var new_object = PILLAR.instantiate()
	#Randomly create's the mob on a point along the path
	%PathFollow2D.progress_ratio = randf()
	new_object.global_position = %PathFollow2D.global_position
	add_child(new_object)

func _on_timer_timeout() -> void:
	#Randomly choose spawn_swarm, spawn_cluster, spawn_boss 
	#later once levels are implemented
	var max_entities = 500
	if(!(len(get_children()) > max_entities)):
		spawn_mob()
		spawn_object()
	else:
		print("More than " + str(max_entities) + " entities")
	time+=($Timer.wait_time)
	

func _on_player_death() -> void:
	%game_over_screen.visible = true
	
func _on_restart_button_button_down() -> void:
	%game_over_screen.visible = false
	get_tree().reload_current_scene()
	
