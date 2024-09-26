extends Node
@export var mob_scene : PackedScene
@export var mob_timer_initial_wait: float = 1.5  # Initial wait time (in seconds)
@export var mob_timer_min_wait: float = 0.5      # Minimum wait time to avoid being too fast
@export var mob_timer_reduction: float = 0.05    # Amount to reduce after each mob spawn

@onready var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation
@onready var score_timer: Timer = $ScoreTimer
@onready var start_timer: Timer = $StartTimer
@onready var mob_timer: Timer = $MobTimer
@onready var player: Area2D = $Player
@onready var start_position: Marker2D = $StartPosition
@onready var background_music: AudioStreamPlayer2D = $BackgroundMusic
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

var score = 0

func _ready() -> void:
	randomize()

func new_game():
	score = 0
	$HUD.update_score(score)
	
	get_tree().call_group("Mobs" , "queue_free")
	player.start(start_position.position)
	
	$HUD.show_message("Get ready...")
	start_timer.start()
	await start_timer.timeout
	score_timer.start()
	mob_timer.start()
	background_music.play()

func game_over():
	score_timer.stop()
	mob_timer.stop()
	$HUD.show_game_over()
	background_music.stop()
	death_sound.play()

func _on_mob_timer_timeout() -> void:
	mob_spawn_location.progress_ratio = randf()
	
	var mob = mob_scene.instantiate()
	add_child(mob)
	
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4 , PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(mob.min_speed , mob.max_speed) , 0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Gradually decrease the mob timer's wait time, but don't go below the minimum limit
	mob_timer.wait_time = max(mob_timer.wait_time - mob_timer_reduction, mob_timer_min_wait)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
