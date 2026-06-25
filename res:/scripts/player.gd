extends CharacterBody3D

# Movement
var speed = 10.0
var jump_force = 15.0
var gravity = 9.8
var current_velocity = Vector3.ZERO

# Animation
var is_moving = false
var animation_state = "idle"

# Camera follow
@onready var camera = get_parent().get_node("Camera3D")
var camera_offset = Vector3(0, 2, 0)
var camera_distance = 5.0
var look_angle_v = 0.0
var look_angle_h = 0.0

func _ready():
	# Setup collision
	collision_layer = 2
	collision_mask = 1
	
	# Create player mesh (simple capsule)
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = CapsuleMesh.new()
	mesh_instance.mesh.radius = 0.4
	mesh_instance.mesh.height = 1.8
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.5, 1.0, 1.0)  # Azul
	mesh_instance.material_override = material
	add_child(mesh_instance)
	
	# Create collision shape
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = CapsuleShape3D.new()
	collision_shape.shape.radius = 0.4
	collision_shape.shape.height = 1.8
	add_child(collision_shape)
	
	# Add head
	var head = MeshInstance3D.new()
	head.mesh = SphereMesh.new()
	head.mesh.radius = 0.3
	head.mesh.radial_segments = 8
	head.mesh.rings = 4
	head.position.y = 0.7
	head.material_override = material
	add_child(head)
	
	position = Vector3(0, 2, 0)

func _physics_process(delta):
	handle_input()
	apply_gravity(delta)
	move_character(delta)
	update_camera()

func handle_input():
	var input_dir = Vector3.ZERO
	
	# Controles de teclado (para pruebas en PC)
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.z += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.z -= 1
	
	# Controles virtuales para móvil (si existen)
	if Input.is_action_pressed("ui_select"):  # Saltar
		if is_on_floor():
			current_velocity.y = jump_force
	
	if input_dir != Vector3.ZERO:
		input_dir = input_dir.normalized()
		is_moving = true
		animation_state = "run"
	else:
		is_moving = false
		animation_state = "idle"
	
	# Rotar el personaje hacia la dirección del movimiento
	if input_dir != Vector3.ZERO:
		var target_angle = atan2(input_dir.x, input_dir.z)
		rotation.y = lerp_angle(rotation.y, target_angle, 0.1)
	
	# Aplicar movimiento
	current_velocity.x = input_dir.x * speed
	current_velocity.z = input_dir.z * speed

func apply_gravity(delta):
	if not is_on_floor():
		current_velocity.y -= gravity * delta
	else:
		if current_velocity.y < 0:
			current_velocity.y = -0.1

func move_character(delta):
	velocity = current_velocity
	move_and_slide()

func update_camera():
	if camera:
		# Posición de la cámara detrás del personaje
		var cam_offset = Vector3(0, 2, 4)
		cam_offset = cam_offset.rotated(Vector3.UP, rotation.y)
		camera.position = global_position + cam_offset
		camera.look_at(global_position + Vector3(0, 1, 0), Vector3.UP)

func get_animation_state():
	return animation_state
