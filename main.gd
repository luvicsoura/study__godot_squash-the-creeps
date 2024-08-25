extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	# Create a new finstance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	# We connect the mob to the score label to update the socre upon squashing one.
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_accept') and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()
