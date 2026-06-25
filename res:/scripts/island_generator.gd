extends Node3D

# Island generation parameters
var island_size_min = 100
var island_size_max = 300
var island_size = randf_range(island_size_min, island_size_max)
var poly_count = 0
var max_polys = 2500

func _ready():
	generate_island()

func generate_island():
	# Generate terrain
	generate_terrain()
	
	# Generate water features
	generate_river()
	generate_swamp()
	
	# Generate vegetation
	generate_trees()
	generate_bushes()
	generate_plants()
	generate_fruits()
	generate_rocks()
	
	# Generate animals
	generate_animals()
	
	print("Island generated with approximately %d polygons" % poly_count)

func generate_terrain():
	var mesh = ArrayMesh()
	var surface_tool = SurfaceTool()
	
	# Create island base shape (irregular polygon)
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	# Generate random island outline
	var segments = randi_range(8, 16)
	var center = Vector3.ZERO
	var heights = []
	
	for i in range(segments):
		var angle = (TAU / segments) * i
		var radius = randf_range(island_size * 0.3, island_size * 0.5)
		var x = cos(angle) * radius
		var z = sin(angle) * radius
		var height = randf_range(0.5, 3.0)
		heights.append(height)
		vertices.append(Vector3(x, height, z))
	
	# Add center vertex
	vertices.append(Vector3.ZERO)
	var center_idx = vertices.size() - 1
	
	# Create triangles
	surface_tool.set_material(load("res://materials/grass_material.tres") if ResourceLoader.exists("res://materials/grass_material.tres") else null)
	
	for i in range(segments):
		var next_i = (i + 1) % segments
		surface_tool.add_vertex(vertices[i])
		surface_tool.add_vertex(vertices[next_i])
		surface_tool.add_vertex(vertices[center_idx])
		poly_count += 1
	
	# Add sand border
	for i in range(segments):
		var next_i = (i + 1) % segments
		var outer_radius = island_size * 0.55
		var angle = (TAU / segments) * i
		var next_angle = (TAU / segments) * next_i
		
		var x1 = cos(angle) * outer_radius
		var z1 = sin(angle) * outer_radius
		var x2 = cos(next_angle) * outer_radius
		var z2 = sin(next_angle) * outer_radius
		
		surface_tool.add_vertex(Vector3(x1, 0.2, z1))
		surface_tool.add_vertex(Vector3(x2, 0.2, z2))
		surface_tool.add_vertex(vertices[i])
		poly_count += 1
	
	surface_tool.commit(mesh)
	$Terrain/IslandMesh.set_mesh(mesh)

func generate_river():
	var mesh = ArrayMesh()
	var surface_tool = SurfaceTool()
	
	# Create a winding river
	var river_path = []
	var start = Vector3(-island_size * 0.4, 0.5, -island_size * 0.4)
	var segments = randi_range(5, 10)
	var width = 4.0
	
	for i in range(segments):
		var t = float(i) / segments
		var x = lerp(-island_size * 0.4, island_size * 0.3, t)
		var z = lerp(-island_size * 0.4, island_size * 0.4, t) + sin(t * TAU) * 15.0
		river_path.append(Vector3(x, 0.3, z))
	
	# Create river mesh
	for i in range(len(river_path) - 1):
		var p1 = river_path[i]
		var p2 = river_path[i + 1]
		var dir = (p2 - p1).normalized()
		var right = dir.cross(Vector3.UP).normalized() * width
		
		surface_tool.add_vertex(p1 - right)
		surface_tool.add_vertex(p1 + right)
		surface_tool.add_vertex(p2 - right)
		
		surface_tool.add_vertex(p2 - right)
		surface_tool.add_vertex(p1 + right)
		surface_tool.add_vertex(p2 + right)
		
		poly_count += 2
	
	surface_tool.commit(mesh)
	$Water/RiverMesh.set_mesh(mesh)

func generate_swamp():
	var mesh = ArrayMesh()
	var surface_tool = SurfaceTool()
	
	# Create swamp areas
	var swamp_count = randi_range(2, 4)
	
	for s in range(swamp_count):
		var swamp_x = randf_range(-island_size * 0.3, island_size * 0.3)
		var swamp_z = randf_range(-island_size * 0.3, island_size * 0.3)
		var swamp_size = randf_range(15.0, 30.0)
		var swamp_segments = 8
		
		for i in range(swamp_segments):
			var angle = (TAU / swamp_segments) * i
			var next_angle = (TAU / swamp_segments) * (i + 1)
			
			var x1 = swamp_x + cos(angle) * swamp_size
			var z1 = swamp_z + sin(angle) * swamp_size
			var x2 = swamp_x + cos(next_angle) * swamp_size
			var z2 = swamp_z + sin(next_angle) * swamp_size
			
			surface_tool.add_vertex(Vector3(swamp_x, 0.4, swamp_z))
			surface_tool.add_vertex(Vector3(x1, 0.4, z1))
			surface_tool.add_vertex(Vector3(x2, 0.4, z2))
			
			poly_count += 1
	
	surface_tool.commit(mesh)
	$Water/SwampMesh.set_mesh(mesh)

func generate_trees():
	var tree_count = randi_range(15, 25)
	
	for i in range(tree_count):
		if poly_count > max_polys:
			break
		
		var tree_x = randf_range(-island_size * 0.4, island_size * 0.4)
		var tree_z = randf_range(-island_size * 0.4, island_size * 0.4)
		
		# Check if in valid area (not water)
		if abs(tree_x) < 40 or abs(tree_z) < 40:
			continue
		
		create_tree(Vector3(tree_x, 1.0, tree_z))

func create_tree(position: Vector3):
	var tree = Node3D.new()
	tree.position = position
	$Trees.add_child(tree)
	
	# Trunk
	var trunk = MeshInstance3D.new()
	trunk.mesh = CylinderMesh.new()
	trunk.mesh.radius = 0.3
	trunk.mesh.height = 2.0
	trunk.material_override = StandardMaterial3D.new()
	trunk.material_override.albedo_color = Color(0.560784, 0.34902, 0.196078, 1)
	tree.add_child(trunk)
	poly_count += 12
	
	# Foliage (simplified sphere)
	var foliage = MeshInstance3D.new()
	foliage.mesh = SphereMesh.new()
	foliage.mesh.radius = 1.2
	foliage.mesh.radial_segments = 8
	foliage.mesh.rings = 4
	foliage.position.y = 1.5
	foliage.material_override = StandardMaterial3D.new()
	foliage.material_override.albedo_color = Color(0.262745, 0.501961, 0.180392, 1)
	tree.add_child(foliage)
	poly_count += 32
	
	# Collision
	var collision = StaticBody3D.new()
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = CapsuleShape3D.new()
	collision_shape.shape.radius = 0.3
	collision_shape.shape.height = 2.0
	collision.add_child(collision_shape)
	tree.add_child(collision)

func generate_bushes():
	var bush_count = randi_range(10, 20)
	
	for i in range(bush_count):
		if poly_count > max_polys:
			break
		
		var bush_x = randf_range(-island_size * 0.35, island_size * 0.35)
		var bush_z = randf_range(-island_size * 0.35, island_size * 0.35)
		
		create_bush(Vector3(bush_x, 0.5, bush_z))

func create_bush(position: Vector3):
	var bush = MeshInstance3D.new()
	bush.position = position
	bush.mesh = SphereMesh.new()
	bush.mesh.radius = 0.6
	bush.mesh.radial_segments = 6
	bush.mesh.rings = 3
	bush.material_override = StandardMaterial3D.new()
	bush.material_override.albedo_color = Color(0.419608, 0.6, 0.239216, 1)
	$Bushes.add_child(bush)
	poly_count += 18

func generate_plants():
	var plant_count = randi_range(20, 40)
	
	for i in range(plant_count):
		if poly_count > max_polys:
			break
		
		var plant_x = randf_range(-island_size * 0.3, island_size * 0.3)
		var plant_z = randf_range(-island_size * 0.3, island_size * 0.3)
		
		create_plant(Vector3(plant_x, 0.2, plant_z))

func create_plant(position: Vector3):
	var plant = Node3D.new()
	plant.position = position
	$Plants.add_child(plant)
	
	# Simple quad plant
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = ArrayMesh.new()
	var surface_tool = SurfaceTool()
	
	surface_tool.add_vertex(Vector3(-0.3, 0, 0))
	surface_tool.add_vertex(Vector3(0.3, 0, 0))
	surface_tool.add_vertex(Vector3(0, 0.8, 0))
	
	surface_tool.commit(mesh_instance.mesh)
	mesh_instance.material_override = StandardMaterial3D.new()
	mesh_instance.material_override.albedo_color = Color(0.4, 0.7, 0.3, 1)
	mesh_instance.material_override.cull_mode = BaseMaterial3D.CULL_DISABLED
	plant.add_child(mesh_instance)
	poly_count += 1

func generate_fruits():
	var fruit_count = randi_range(10, 15)
	
	for i in range(fruit_count):
		if poly_count > max_polys:
			break
		
		var fruit_x = randf_range(-island_size * 0.2, island_size * 0.2)
		var fruit_z = randf_range(-island_size * 0.2, island_size * 0.2)
		
		create_fruit(Vector3(fruit_x, 1.5, fruit_z))

func create_fruit(position: Vector3):
	var fruit = MeshInstance3D.new()
	fruit.position = position
	fruit.mesh = SphereMesh.new()
	fruit.mesh.radius = 0.15
	fruit.mesh.radial_segments = 6
	fruit.mesh.rings = 3
	fruit.material_override = StandardMaterial3D.new()
	fruit.material_override.albedo_color = Color(0.988235, 0.168627, 0.168627, 1)
	$Fruits.add_child(fruit)
	poly_count += 8

func generate_rocks():
	var rock_count = randi_range(8, 15)
	
	for i in range(rock_count):
		if poly_count > max_polys:
			break
		
		var rock_x = randf_range(-island_size * 0.4, island_size * 0.4)
		var rock_z = randf_range(-island_size * 0.4, island_size * 0.4)
		
		create_rock(Vector3(rock_x, 0.3, rock_z))

func create_rock(position: Vector3):
	var rock = MeshInstance3D.new()
	rock.position = position
	rock.mesh = SphereMesh.new()
	rock.mesh.radius = randf_range(0.3, 0.6)
	rock.mesh.radial_segments = 5
	rock.mesh.rings = 3
	rock.material_override = StandardMaterial3D.new()
	rock.material_override.albedo_color = Color(0.5, 0.5, 0.5, 1)
	$Rocks.add_child(rock)
	poly_count += 8

func generate_animals():
	var animal_count = randi_range(5, 12)
	
	for i in range(animal_count):
		if poly_count > max_polys:
			break
		
		var animal_type = randi_range(0, 3)
		var animal_x = randf_range(-island_size * 0.3, island_size * 0.3)
		var animal_z = randf_range(-island_size * 0.3, island_size * 0.3)
		
		create_animal(Vector3(animal_x, 0.5, animal_z), animal_type)

func create_animal(position: Vector3, type: int):
	var animal = Node3D.new()
	animal.position = position
	$Animals.add_child(animal)
	
	# Body
	var body = MeshInstance3D.new()
	body.mesh = CapsuleMesh.new()
	body.mesh.radius = 0.3
	body.mesh.height = 0.8
	body.material_override = StandardMaterial3D.new()
	
	match type:
		0:  # Cow - brown
			body.material_override.albedo_color = Color(0.6, 0.4, 0.2, 1)
		1:  # Sheep - white
			body.material_override.albedo_color = Color(0.9, 0.9, 0.9, 1)
		2:  # Goat - gray
			body.material_override.albedo_color = Color(0.7, 0.7, 0.7, 1)
	
	animal.add_child(body)
	poly_count += 12
	
	# Head
	var head = MeshInstance3D.new()
	head.mesh = SphereMesh.new()
	head.mesh.radius = 0.2
	head.mesh.radial_segments = 6
	head.mesh.rings = 3
	head.position.y = 0.5
	head.position.z = 0.3
	head.material_override = body.material_override.duplicate()
	animal.add_child(head)
	poly_count += 8
