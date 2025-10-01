# res://PauseMenu.gd
extends Control

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	$VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _input(event):
	if event.is_action_pressed("pause_game"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		get_tree().paused = true
		visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_resume_pressed():
	toggle_pause()

func _on_restart_pressed():
	get_tree().paused = false
	GameManager.reset()  # เปลี่ยนจาก GameState เป็น GameManager
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
