# ----------------------------------------------------------------------------------- #
# -------------- FEEL FREE TO USE IN ANY PROJECT, COMMERCIAL OR NON-COMMERCIAL ------ #
# ---------------------- 3D PLATFORMER CONTROLLER BY SD STUDIOS --------------------- #
# ---------------------------- ATTRIBUTION NOT REQUIRED ----------------------------- #
# ----------------------------------------------------------------------------------- #

extends CharacterBody3D

# ---------- VARIABLES ---------- #

@export_category("Player Properties")
@export var move_speed : float = 10
@export var jump_force : float = 8
@export var follow_lerp_factor : float = 3
@export var jump_limit : int = 3

@export_group("Game Juice")
@export var jumpStretchSize := Vector3(0.8, 1.2, 0.8)

# Booleans
var is_grounded = false
var can_double_jump = false

# Onready Variables
@onready var model = $santa
# Node Path ที่ถูกต้องตามภาพ: $Santa/RootNode/AnimationPlayer
@onready var animation = $santa/AnimationPlayer 
# %Gimbal ต้องถูกตั้งค่าเป็น Unique Name ใน Scene Tree
@onready var spring_arm = %Gimbal

@onready var particle_trail = $ParticleTrail
@onready var footsteps = $Footsteps

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

# ---------- FUNCTIONS ---------- #

func _process(delta):
	# ตรวจสอบ AnimationPlayer ก่อนเรียกใช้เพื่อป้องกัน Error
	if not is_instance_valid(animation):
		velocity.y -= gravity * delta
		move_and_slide()
		return
	
	player_animations()
	get_input(delta) # get_input จะเรียก move_and_slide()
	
	# Smoothly follow player's position - ต้องมี spring_arm ถึงจะทำงาน
	if is_instance_valid(spring_arm):
		spring_arm.position = lerp(spring_arm.position, position, delta * follow_lerp_factor)
	
	# Player Rotation
	if is_moving():
		var look_direction = Vector2(velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, look_direction.angle(), delta * 12)
	
	# === ตรรกะ Double Jump ที่แก้ไขแล้ว: ===
	if is_on_floor():
		is_grounded = true
		can_double_jump = true
	else:
		is_grounded = false
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			perform_jump()
		elif can_double_jump:
			perform_flip_jump()
			can_double_jump = false
	
	velocity.y -= gravity * delta


func perform_jump():
	# AudioManager.jump_sfx.play() # Un-comment ถ้ามี Audio
	jumpTween()
	animation.play("Armature|Jump") # ชื่อแอนิเมชัน
	velocity.y = jump_force

func perform_flip_jump():
	# AudioManager.jump_sfx.play() # Un-comment ถ้ามี Audio
	animation.play("Armature|Jump", 0.5) 
	velocity.y = jump_force

func is_moving():
	return Vector2(velocity.x, velocity.z).length_squared() > 0.01

func jumpTween():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", jumpStretchSize, 0.1)
	tween.tween_property(self, "scale", Vector3(1,1,1), 0.1)

# Get Player Input
func get_input(_delta):
	var move_direction := Vector3.ZERO
	# อ่านค่า Input ที่ตั้งไว้ใน Project Settings
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.z = Input.get_axis("move_forward", "move_back")
	
	# Move The player Towards Spring Arm/Camera Rotation
	# ส่วนนี้สำคัญ: ถ้าหา SpringArm ไม่เจอ (เป็น null) ตัวละครจะไม่หมุนและไม่ขยับ
	if is_instance_valid(spring_arm):
		move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	
	velocity = Vector3(move_direction.x * move_speed, velocity.y, move_direction.z * move_speed)

	move_and_slide()

# Handle Player Animations
func player_animations():
	particle_trail.emitting = false
	footsteps.stream_paused = true
	
	if is_on_floor():
		if is_moving(): # Checks if player is moving
			animation.play("Armature|Walk", 0.5) # ชื่อแอนิเมชัน
			particle_trail.emitting = true
			footsteps.stream_paused = false
		else:
			animation.play("Armature|Idle", 0.5) # ชื่อแอนิเมชัน
