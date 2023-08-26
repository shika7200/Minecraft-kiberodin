extends Spatial

var  cube_size = 1.0
var chunk_size = 64
var noise = OpenSimplexNoise.new()
var gridmap
var mesh_library = MeshLibrary.new()
var world_lowest = -4

func _ready():
	gridmap = get_node("GridMap")
	gridmap.set_cell_size(Vector3(cube_size, cube_size, cube_size))
	
	randomize()
	noise.seed = int(rand_range(0,10000))
	initialize_MeshLib()
	generate_map(2)
	
func initialize_MeshLib():
	var cube_mesh = CubeMesh.new()
	cube_mesh.size =Vector3(cube_size, cube_size, cube_size)
	var collision_shape = BoxShape.new()
	collision_shape.extents = cube_mesh.size
	#ВОТ ЗДЕСЬ ДВЕ СТРОЧКИ СОЗДАНИЯ МАТЕРИАЛА
	
	
	var grass_material = SpatialMaterial.new()
	grass_material.albedo_texture = load("res://src/Assets/grass.png")
	var leaves_material = SpatialMaterial.new()
	leaves_material.albedo_texture = load("res://src/Assets/leaves.png")
	var wood_material = SpatialMaterial.new()
	wood_material.albedo_texture = load("res://src/Assets/wood.png")
	#4 строчки создания кубов с материалом
	
	var grass_mesh = ArrayMesh.new()
	var arrays = cube_mesh.surface_get_arrays(0)
	grass_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	grass_mesh.surface_set_material(0,grass_material)
	
	#ДОбавляем в библотеку!
	mesh_library.create_item(0)
	mesh_library.set_item_mesh(0, grass_mesh)
	mesh_library.set_item_shapes(0, [collision_shape])
	
	
	#добавляем leaves в библиотеку
	var leaves_mesh = ArrayMesh.new()
	leaves_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	leaves_mesh.surface_set_material(0,leaves_material)
	
	#ДОбавляем в библотеку!
	mesh_library.create_item(1)
	mesh_library.set_item_mesh(1, leaves_mesh)
	mesh_library.set_item_shapes(1, [collision_shape])
	
	
	ResourceSaver.save("res://MyMeshLibrary.tres", mesh_library)
	gridmap.set_mesh_library(mesh_library)
	gridmap.set_cell_size(Vector3(1,1,1))
	
func generate_map(size):
	for x in range (-size/2, size/2):
		for y in range (-size/2, size/2):
			generate_chunk(x,y)
			pass
			
func generate_chunk(x,z):
	for i in range(0, chunk_size):
		for j in range(0, chunk_size):
			var height = int(noise.get_noise_2d(x*chunk_size+i, z*chunk_size +j)*128/6)
			gridmap.set_cell_item(x*chunk_size+i,world_lowest -1, z*chunk_size+j,0)
			for y in range(world_lowest, height):
				gridmap.set_cell_item(x*chunk_size+i, y, z*chunk_size+j, 0 )
	
	#коментарии нужно писать обязательно p.s Черт

