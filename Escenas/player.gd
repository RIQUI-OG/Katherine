extends CharacterBody3D

@export var speed: float = 5.0
@export var run_speed: float = 9.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002

@export var max_stamina: float = 5.0
@export var stamina_rec_rate: float = 2.0
@export var stamina_drain_rate: float = 4.0
var current_stamina: float
var is_running: bool =  false
var rotation_y := 0.0 
var camera_vertical_rotation := 0.0 
var stamina_cooldown: float = 0.0
var can_run = false

@onready var camera_pivot := $CameraPivot
@onready var camera := $CameraPivot/Camera3D
@onready var stamina_bar : TextureProgressBar = $CanvasHUD/CanvasPlayer/HUD_Player/PanelStamina/TPBar_Stamina

func _ready():
     Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
     current_stamina = max_stamina
     can_run = true

func _input(event):
     if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
          rotation_y -= event.relative.x * mouse_sensitivity
          camera_vertical_rotation = clamp(camera_vertical_rotation - event.relative.y * mouse_sensitivity, -80, 80)

          #Rotación del jugador en Y
          var rot = rotation
          rot.y = deg_to_rad(rotation_y)
          rotation = rot

          #Rotación vertical de la cámara en X
          var cam_rot = camera_pivot.rotation
          cam_rot.x = deg_to_rad(camera_vertical_rotation)
          camera_pivot.rotation = cam_rot

     elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
          Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
     if not is_on_floor():
          velocity.y += get_gravity().y * delta

     if Input.is_action_just_pressed("ui_accept") and is_on_floor():
          velocity.y = jump_velocity

     var input_dir := Input.get_vector("izquierda", "derecha", "adelante", "atras")
     var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

     is_running = Input.is_action_pressed("run") and current_stamina > 0
     #var current_speed = 
     var move_speed: float
     if is_running:
      move_speed = run_speed
      print("corriendo")
     else :
      move_speed = speed

     if direction:
          velocity.x = direction.x * move_speed
          velocity.z = direction.z * move_speed
     else:
          velocity.x = move_toward(velocity.x, 0, speed)
          velocity.z = move_toward(velocity.z, 0, speed)

     move_and_slide()

     var cant_over = false

     if is_running:
      current_stamina= max(current_stamina - stamina_drain_rate * delta, 0.0)
      if current_stamina == 0:
            cant_over = true
            can_run = false
     else:
      if not Input.is_action_pressed("run") and current_stamina == 0 and not cant_over:
            stamina_cooldown += delta
            if stamina_cooldown >= 1.0:
                  cant_over = false
                  can_run = true
                  stamina_cooldown = 0.0
                  
      if can_run:
            current_stamina = min(current_stamina + stamina_rec_rate * delta, max_stamina)
      #current_stamina = min(current_stamina + stamina_rec_rate * delta, max_stamina)
      
     if stamina_bar:
      stamina_bar.value = current_stamina
     
     if Input.is_key_pressed(KEY_E):
          Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
