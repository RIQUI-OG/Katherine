extends Control

@onready var descripcion_label : Label = $PanelGame/PanelGame/HBoxContainer/box2/Label_descrip
@onready var bt_practica: Button = $PanelGame/PanelDown/HBoxContainer/Bt_Practice
@onready var bt_easy: Button = $PanelGame/PanelDown/HBoxContainer/Bt_Easy
@onready var bt_normal: Button = $PanelGame/PanelDown/HBoxContainer/Bt_Normal
@onready var bt_hard: Button = $PanelGame/PanelDown/HBoxContainer/Bt_Hard
var dificultades = {}
@onready var anim_credits: AnimationPlayer = $PanelInfo/PanelCredits/box/Anim_credits
@onready var paneles = [
	 $PanelGame,
	 $PanelSettings,
	 $PanelInfo,
	 $PanelExit
]

@onready var panel_credits = $PanelInfo/PanelCredits

func _ready():
	 ocultar_paneles()
	 panel_credits.visible = false
	 cargar_dificultades()
	 
	 bt_practica.pressed.connect(func(): descripcion_visible("Practica"))
	 bt_easy.pressed.connect(func(): descripcion_visible("Facil"))
	 bt_normal.pressed.connect(func(): descripcion_visible("Normal"))
	 bt_hard.pressed.connect(func(): descripcion_visible("Dificil"))
	 
func ocultar_paneles():
	 for panel in paneles:
		  panel.visible = false
		  
func mostrar_panel(panel_mostrar: Panel):
	 ocultar_paneles()
	 panel_mostrar.visible = true

func _on_button_quit_pressed() -> void:
	 get_tree().quit()
	 
func _on_button_settings_pressed() -> void:
	 mostrar_panel($PanelSettings)

func _on_settings_hide_button_pressed() -> void:
	 ocultar_paneles()
	 
func _on_button_game_pressed() -> void:
	 mostrar_panel($PanelGame)

func _on_hide_panel_button_pressed() -> void:
	 ocultar_paneles()

func _on_button_info_pressed() -> void:
	 mostrar_panel($PanelInfo)

func _on_hide_info_button_pressed() -> void:
	 ocultar_paneles()

func _on_button_next_pressed() -> void:
	 panel_credits.visible = true
	 anim_credits.play("show_credits")

func _on_button_back_pressed() -> void:
	 panel_credits.visible = false
	 
func cargar_dificultades():
	 var file_path = "res://Assets/Import/Descripciones/descripciones_dificultades_katherine.json"
	 var file = FileAccess.open(file_path, FileAccess.READ)
	 if file:
		  var json_text = file.get_as_text()
		  var data = JSON.parse_string(json_text)
		  if typeof(data) == TYPE_DICTIONARY:
			   dificultades = data
		  else :
			   print("Error con los datos, el JSON no es válido")
	 else:
		  print("Error con el archivo JSON")
	 
func descripcion_visible(_nombre_dificultad: String):
	 if dificultades.has(_nombre_dificultad):
		  descripcion_label.text = dificultades[_nombre_dificultad]
		  #pass
		  
