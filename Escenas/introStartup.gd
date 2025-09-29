extends Control

@export var wait_time =3.0
@onready var main_scene = "res://Escenas/MainMenu.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
       await get_tree().create_timer(wait_time).timeout
       change_scene()

func change_scene():
     get_tree().change_scene_to_file(main_scene)
