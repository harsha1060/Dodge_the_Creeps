extends CanvasLayer
signal start_game
@onready var button: Button = $Button
@onready var score_label: Label = $ScoreLabel
@onready var message_label: Label = $MessageLabel
@onready var message_timer: Timer = $MessageTimer


func update_score(score):
	score_label.text = str(score)

func show_message(text):
	message_label.text = text
	message_label.show()
	message_timer.start()

func show_game_over():
	show_message("Game Over")
	await message_timer.timeout
	message_label.text = "Dodge the CREEPS"
	message_label.show()
	await get_tree().create_timer(1.0).timeout
	button.show()

func _on_button_pressed() -> void:
	button.hide()
	emit_signal("start_game")

func _on_message_timer_timeout() -> void:
	message_label.hide()
