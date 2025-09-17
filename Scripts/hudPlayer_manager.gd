extends Control

#Variables para usar en la brújula
@onready var compass_image: TextureRect = $Compass
#Otras referencias para su uso
@onready var player: CharacterBody3D
@onready var camera: Camera3D

#Configuración que se publicará prox.
@export var smooth_rotation: bool = true
@export var rotation_speed: float = 5.0

func _ready():
	 #Buscar estos nodos
	 player = get_tree().get_first_node_in_group("player")
	 camera = get_tree().get_first_node_in_group("camera")
	 
	 #Verificar que se encontraron
	 if not player:
		  print("Error: No se encontró el nodo Player. Tiene que estar en el grupo player")
	 if not camera:
		  print("Error: No se encontró el nodo Camera3D. Debe estar en el grupo camera")
	 
	 #Brújula centralizada
	 if compass_image:
		  compass_image.pivot_offset = compass_image.size / 2

func _process(delta):
	 if player and compass_image:
		  update_compass_rotation(delta)

func update_compass_rotation(delta):
	 #Adquerir la dirección de la cámara
	 var player_forward: Vector3
	 
	 #if player:
		  #player_forward = -player.global_transform.basis.z
	 if camera:
		  player_forward = -camera.global_transform.basis.z
	 else:
		  return
	 
	 #Calcular el ángulo en radianes basado en las coordenadas X y Z. Z negativo es hacia adelante por defecto
	 var angle_radians = atan2(player_forward.x, player_forward.z)
	 
	 #Conversión a grados
	 var angle_degrees = rad_to_deg(angle_radians)
	 
	 # La brújula debe apuntar en dirección opuesta al jugador
	 #(cuando el jugador mira al norte, la aguja debe apuntar al norte)
	 var compass_rotation = -angle_degrees
	 
	 if smooth_rotation:
		  #Rotación suave usando interpolación
		  var current_rotation = compass_image.rotation_degrees
		  var target_rotation = compass_rotation
		  
		  #Manejar el wrap around de 360 grados
		  var diff = target_rotation - current_rotation
		  if diff > 180:
			   diff -= 360
		  elif diff < -180:
			   diff += 360
		  
		  compass_image.rotation_degrees = current_rotation + diff * rotation_speed * delta
	 else:
		  #Rotación instantánea
		  compass_image.rotation_degrees = compass_rotation

#Función alternativa si quieres usar coordenadas específicas
func update_compass_with_coordinates(delta):
	 if player and compass_image:
		  #Obtener las coordenadas del jugador
		  var player_position = player.global_position
		  
		  # Calcular la dirección basada en las coordenadas del mundo
		  # Puedes ajustar esto según tu sistema de coordenadas
		  var world_direction = Vector2(player_position.x, player_position.z)
		  
		  # Normalizar la dirección
		  if world_direction.length() > 0:
			   world_direction = world_direction.normalized()
		  
		  # Calcular el ángulo
		  var angle_radians = atan2(world_direction.x, world_direction.y)
		  var angle_degrees = rad_to_deg(angle_radians)
		  
		  # Aplicar rotación
		  if smooth_rotation:
			   var current_rotation = compass_image.rotation_degrees
			   var target_rotation = angle_degrees
			   
			   var diff = target_rotation - current_rotation
			   if diff > 180:
					diff -= 360
			   elif diff < -180:
					diff += 360
			   
			   compass_image.rotation_degrees = current_rotation + diff * rotation_speed * delta
		  else:
			   compass_image.rotation_degrees = angle_degrees

# Función para mapear direcciones específicas (Norte, Sur, Este, Oeste)
func get_cardinal_direction() -> String:
	 if not player:
		  return "Unknown"
	 
	 var player_forward = -player.global_transform.basis.z
	 var angle = atan2(player_forward.x, player_forward.z)
	 var degrees = rad_to_deg(angle)
	 
	 # Normalizar el ángulo a 0-360
	 if degrees < 0:
		  degrees += 360
	 
	 # Determinar la dirección cardinal
	 if degrees >= 315 or degrees < 45:
		  return "Norte"
	 elif degrees >= 45 and degrees < 135:
		  return "Este"
	 elif degrees >= 135 and degrees < 225:
		  return "Sur"
	 else:
		  return "Oeste"

# Función para obtener el ángulo exacto hacia una dirección específica
func get_angle_to_direction(direction: String) -> float:
	 match direction:
		  "Norte":
			   return 0.0
		  "Este":
			   return 90.0
		  "Sur":
			   return 180.0
		  "Oeste":
			   return 270.0
		  _:
			   return 0.0
