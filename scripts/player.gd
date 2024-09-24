class_name Player extends CharacterBody3D

const SENSITIVITY = 0.07

const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.04
var bob_time = 0.0

const BASE_FOV = 80.0
const FOV_CHANGE = 0.5

var cam_accel = 40

@onready var head = $Head
@onready var camera : Camera3D = $Head/Camera3D

@export var WEAPON_CONTROLLER : WeaponController

func _ready():
	Global.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	return pos;

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	# Head bob
	bob_time += delta * velocity.length() * float(is_on_floor())
	head.transform.origin = headbob(bob_time) + Vector3.UP * 0.8
	
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors. THANK YOU GARBAJ!
	if Engine.get_frames_per_second() > Engine.physics_ticks_per_second:
		camera.set_as_top_level(true)
		camera.global_transform.origin = camera.global_transform.origin.lerp(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_top_level(false)
		camera.global_transform = head.global_transform
	
	Global.debug.add_property("Weapon", WEAPON_CONTROLLER.WEAPON_TYPE.name, 3)

func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += Vector3(0, -16.0, 0) * delta
		# can also do get_gravity() but its weird

func update_input(delta: float, speed: float, acceleration: float, deceleration: float) -> void:
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * acceleration)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * acceleration)
		else:
			velocity.x = lerp(velocity.x, 0.0, delta * deceleration)
			velocity.z = lerp(velocity.z, 0.0, delta * deceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * deceleration)
		velocity.z = lerp(velocity.z, 0.0, delta * deceleration)

func update_velocity() -> void:
	move_and_slide()

func update_fov(delta: float, speed: float) -> void:
	var velocity_clamped = clamp(velocity.length(), 0.5, speed * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
