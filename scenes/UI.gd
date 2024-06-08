extends PopupPanel

class_name UI

signal play_game
signal quit_game

func pop_up_with_text(txt = null, delay_play_button_enable = false, delay = 0.3):
	if txt:
		$VBoxContainer/Label.text = txt
	$Tween.interpolate_property(self, "position", position * 1.5, position, delay)
	$Tween.interpolate_property(self, "scale", scale * 0, scale, delay)
	$Tween.start()
	popup_centered()
	if delay_play_button_enable:
		disable_play_button(true)
		$Timer.start()


func disable_play_button(disabled = false):
	$VBoxContainer/Buttons/PlayButton.disabled = disabled


func _on_PlayButton_button_down():
	emit_signal("play_game")


func _on_ExitButton_button_down():
	emit_signal("quit_game")
