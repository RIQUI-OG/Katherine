extends Control

const CONFIG_PATH:= "res://Assets/Resources/global_audio_source.cfg"

var volumenes := {
     "Master": 0.0,
     "Music": 0.0,
     "SFX": 0.0
}

func _ready():
     load_config()
     apply_volume()
     
func set_volume(bus_name: String, value: float):
     volumenes[bus_name] = value
     AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))
     save_config()
     
func linear_to_db(value: float):
     if value <= 0.0:
          return -80.0
     return 20.0 * log(value)/log(10.0)
     
func apply_volume():
     for bus_name in volumenes.keys():
          set_volume(bus_name, volumenes[bus_name])
     
func save_config():
     var cfg = ConfigFile.new()
     for bus_name in volumenes.keys():
          cfg.set_value("audio", bus_name, volumenes[bus_name])
     cfg.save(CONFIG_PATH)
     
func load_config():
     var cfg = ConfigFile.new()
     var error = cfg.load(CONFIG_PATH)
     if error == OK:
          for bus_name in volumenes.keys():
               if cfg.has_section_key("audio", bus_name):
                    volumenes[bus_name] = cfg.get_value("audio", bus_name)


func _on_slider_music_value_changed(value: float) -> void:
     set_volume("Music", value)
     
