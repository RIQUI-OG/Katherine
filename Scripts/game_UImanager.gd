extends Control

@onready var panel_game = $PanelGame
@onready var panel_inventory = $PanelInventory
@onready var panel_settings = $PanelSettings
@export var is_paused : bool = false
@export var panel_stamina = Control
@export var compass = TextureRect

func _ready():
     panel_game.visible = true
     panel_inventory.visible = false
     is_paused = false

func _process(_delta: float):
     if Input.is_action_just_pressed("on_menu"):
          show_menu_inventory()
     
func show_menu_inventory():
     is_paused = true
     panel_game.visible = false
     panel_stamina.visible = false
     compass.visible = false
     panel_inventory.visible = true
     
func hide_menu_inventory():
     is_paused = false
     panel_game.visible = true
     panel_stamina.visible = true
     compass.visible = true
     panel_inventory.visible = false
     
func _on_button_return_pressed() -> void:
     hide_menu_inventory()
     set_mouse_location()
     
func _on_quit_settings_pressed() -> void:
     panel_settings.visible = false

func _on_button_settings_pressed() -> void:
     panel_settings.visible = true
     
func set_mouse_location():
     Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_button_exit_pressed() -> void:
     is_paused = false
     var back_to_main = "res://Escenas/MainMenu.tscn"
     get_tree().change_scene_to_file(back_to_main)
