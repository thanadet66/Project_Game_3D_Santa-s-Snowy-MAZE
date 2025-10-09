extends Control

func _ready():
	# ใช้ print เช็คว่ามันมาถึง MainMenu จริงมั้ย
	print(">>> MAIN MENU LOADED <<<")

	# เชื่อมปุ่มกับฟังก์ชัน
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	print("Start pressed!") # Debug
	get_tree().change_scene_to_file("res://Scenes/demo_scene.tscn")

func _on_quit_pressed():
	print("Quit pressed!") # Debug
	get_tree().quit()
