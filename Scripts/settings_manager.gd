extends Control

@onready var slider_volume: HSlider = $Panel/Panel/VBoxContainer/Musica/HBoxContainer/Slider_music
@onready var slider_sfx: HSlider = $Panel/Panel/VBoxContainer/Musica/HBoxContainer2/Slider_sfx
@onready var mute_button = $Panel/Panel/VBoxContainer/Musica/HBoxContainer3/Mute_switch
const CONFIG_PATH:= "user://global_settings_source.cfg"
const SECTION := "Audio"

func _ready():
     #call_deferred("_initialize_slider_loaded")
     print("Volume slider: ", slider_volume)
     print("SFX slider: ", slider_sfx)
     
     load_settings()
     #apply_volume()

#func _initialize_slider_loaded():
     #slider_volume = get_node("Panel/Panel/VBoxContainer/Musica/HBoxContainer/Slider_music")
     #slider_sfx = get_node("Panel/Panel/VBoxContainer/Musica/HBoxContainer2/Slider_sfx")
     
func _on_slider_music_value_changed(value: float) -> void:
     var music_index = AudioServer.get_bus_index("Master")
     AudioServer.set_bus_volume_db(music_index, linear_to_db(value))
     save_settings()

func _on_slider_sfx_value_changed(value: float) -> void:
     var sfx_index = AudioServer.get_bus_index("SFX")
     AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))
     save_settings()

func save_settings():
     var config = ConfigFile.new()
     config.set_value(SECTION, "master", slider_volume.value)
     config.set_value(SECTION, "SFX", slider_sfx.value)
     config.set_value(SECTION, "mute", mute_button.pressed)
     config.save(CONFIG_PATH)
     
func load_settings():
     var config = ConfigFile.new()
     var error = config.load(CONFIG_PATH)
     var volume_value: float
     var sfx_value: float
     
     if error == OK:
          volume_value = float(config.get_value(SECTION, "master", 1.0))
          sfx_value = float(config.get_value(SECTION, "SFX", 1.0))
          config.set_value(SECTION, "mute", false)
          config.save(CONFIG_PATH)
     else:
          volume_value = 1.0
          sfx_value = 1.0
          
     if slider_volume:
          slider_volume.value = volume_value
     if slider_sfx:
          slider_sfx.value = sfx_value
          
     var master_bus = AudioServer.get_bus_index("Master")
     AudioServer.set_bus_volume_db(master_bus, linear_to_db(volume_value))
     var sfx_bus = AudioServer.get_bus_index("SFX")
     AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_value))

func _on_mute_switch_toggled(toggled_on: bool) -> void:
     var master_bus = AudioServer.get_bus_index("Master")
     var sfx_bus = AudioServer.get_bus_index("SFX")
     
     if toggled_on:
          AudioServer.set_bus_mute(master_bus, true)
          AudioServer.set_bus_mute(sfx_bus, true)
     else:
          AudioServer.set_bus_mute(master_bus, false)
          AudioServer.set_bus_mute(sfx_bus, false)
     save_settings()
