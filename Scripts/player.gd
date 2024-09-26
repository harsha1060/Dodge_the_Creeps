extends Area2D

var speed = 400
signal hit
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var screen_size = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	# Handle user inputs
	if Input.is_action_pressed("Move_Up"):
		direction.y -= 1 
	if Input.is_action_pressed("Move_Down"):
		direction.y += 1
	if Input.is_action_pressed("Move_Right"):
		direction.x += 1
	if Input.is_action_pressed("Move_Left"):
		direction.x -= 1
	# Normalize the movement
	if direction.length() > 0:
		direction = direction.normalized()
		position += direction * speed * delta
		if direction.x != 0 : # Horizontal Movement
			animated_sprite.play("Walk")
			animated_sprite.flip_h = direction.x < 0
		if direction.y != 0: # Vertical Movement
			animated_sprite.play("Up")
			animated_sprite.flip_v = direction.y > 0
	else: # Stop the animation if no input from user
		animated_sprite.stop()
	position.x = clamp(position.x , 0 , screen_size.x)
	position.y = clamp(position.y , 0 , screen_size.y)
	
func start(new_position):
	position = new_position
	show()
	collision_shape.disabled = false

func _on_body_entered(_body: Node2D) -> void:
	hide()
	collision_shape.set_deferred("disabled" , true)
	emit_signal("hit")
