extends Node3D

var falling := false
var fall_velocity := 0.0

# เตรียมตัวแปรสำหรับ Timer และตำแหน่งเริ่มต้น
@onready var reset_timer = $Timer # อ้างอิงถึง Node Timer ที่เราสร้าง
var initial_position: Vector3

# ฟังก์ชัน _ready จะทำงานแค่ครั้งเดียวตอนเริ่มเกม
func _ready():
	# จำตำแหน่งเริ่มต้นของกับดักไว้
	initial_position = position

func _physics_process(delta):
	# ทำให้สเกลกลับมาเป็นปกติ (โค้ดส่วนนี้ยังเหมือนเดิม)
	scale = scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	if falling:
		# ถ้ากำลังตก ให้คำนวณความเร็วและตำแหน่งใหม่
		fall_velocity += 15.0 * delta
		position.y -= fall_velocity * delta
	else:
		# ถ้าไม่ได้ตก ให้ความเร็วเป็นศูนย์
		fall_velocity = 0.0
	
	# --- ลบบรรทัด queue_free() ทิ้งไป ---
	# if position.y < -10:
	#	  queue_free()

# ฟังก์ชันนี้จะทำงานเมื่อผู้เล่นมาเหยียบ
func _on_body_entered(_body):
	# เช็กว่ายังไม่ได้ตกอยู่ ถึงจะทำงาน
	if not falling:
		# เริ่มตก
		falling = true
		
		# เล่นอนิเมชันยืด-หด
		scale = Vector3(1.25, 1, 1.25)
		
		# **สั่งให้ Timer เริ่มนับเวลา 4 วินาที**
		reset_timer.start()

# ฟังก์ชันนี้จะถูกเรียกโดยอัตโนมัติเมื่อ Timer นับครบ 4 วินาที
func _on_timer_timeout():
	# รีเซ็ตสถานะทุกอย่างให้กลับไปเป็นเหมือนเดิม
	falling = false
	position = initial_position # ย้ายกลับไปที่ตำแหน่งเริ่มต้น
	print("Platform has been reset!") # ใช้สำหรับทดสอบ ดูข้อความในหน้าต่าง Output
