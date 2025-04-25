extends Node2D

var time := 0.0
var level_time := 11
var max_entities := 500
var already_done : bool = false

func _ready() -> void:
	get_tree().paused = false
	#for i in range(5):
		#spawn_mob()

func spawn_mob():
	#In the future this will also create the color of the mob
	#And it's random technique's
	var spawn_type = ["swarm", "mob", "boss", "swarm", "swarm", "mob"]
	spawn_type = spawn_type[randi_range(0,len(spawn_type)-1)]
	if(spawn_type == "mob"):
		var new_mob := preload("res://mob.tscn").instantiate()
		new_mob.set_level(%Player.level-2)
		#Randomly create's the mob on a point along the path
		%PathFollow2D.progress_ratio = randf()
		new_mob.global_position = %PathFollow2D.global_position
		add_child(new_mob)
	elif(spawn_type == "swarm"):
		var new_mob := preload("res://mob.tscn").instantiate()
		new_mob.set_level(%Player.level-3)
		new_mob.scale = Vector2(.75, .75)
		var new_mob1 := preload("res://mob.tscn").instantiate()
		new_mob1.set_level(%Player.level-2)
		new_mob1.scale = Vector2(.75, .75)
		var new_mob2 := preload("res://mob.tscn").instantiate()
		new_mob2.set_level(%Player.level-2)
		new_mob2.scale = Vector2(.75, .75)
		#Randomly create's the mob on a point along the path
		%PathFollow2D.progress_ratio = randf()
		new_mob.global_position = %PathFollow2D.global_position
		%PathFollow2D.progress_ratio = randf()
		new_mob1.global_position = %PathFollow2D.global_position
		%PathFollow2D.progress_ratio = randf()
		new_mob2.global_position = %PathFollow2D.global_position
		add_child(new_mob)
		add_child(new_mob1)
		add_child(new_mob2)
	elif(spawn_type == "boss"):
		var new_mob := preload("res://mob.tscn").instantiate()
		new_mob.set_level(%Player.level-1)
		new_mob.scale = Vector2(1.25, 1.25)
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

func level_up():
	if(int(round(time+1))%level_time == 0):
		%Player.level_up()
		time = 0
		

func _on_timer_timeout() -> void:
	#Randomly choose spawn_swarm, spawn_cluster, spawn_boss 
	#later once levels are implemented
	level_up()
	if(!(len(get_children()) > max_entities)):
		spawn_mob()
		spawn_object()
	else:
		if(len(get_children()) > max_entities*2):
			for i in (range(len(get_children()) - max_entities)):
				kill_most_distant_entity()
		else:
			kill_most_distant_entity()
	time+=($Timer.wait_time)
	
func kill_most_distant_entity()->void:
	get_tree().get_nodes_in_group("entities").front().queue_free()
	
	

func _on_player_death() -> void:
	%game_over_screen.visible = true
	%AudioStreamPlayer.stream_paused = true
	get_tree().call_group("entities", "mute")
	%Timer.stop()
	if(!already_done):
		%game_over_label.text = %game_over_label.text + "Level Reached " + str(%Player.level)
		already_done = true
	
func _on_restart_button_button_down() -> void:
	%game_over_screen.visible = false
	get_tree().reload_current_scene()
	
func _on_player_changed_speed() -> void:
	#print((1+(%Player.calculate_speed())/1000))
	%Path2D.scale = %Path2D.scale*(1+(%Player.calculate_speed())/1000)
