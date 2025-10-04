extends Node3D

@onready var anim = $AnimationPlayer
var is_open = false

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	print("ผู้เล่นเข้า:", body.name)
	anim.play("open")
	is_open = true


func _on_body_exited(body):
	print("ผู้เล่นออก:", body.name)
	anim.play("close")
	is_open = false
