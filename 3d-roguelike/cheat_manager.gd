extends Node

var cheat_code = "cyrene"
var enuma_code = "enkidu"  # <--- NEW
var current_input = ""

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var char_typed = char(event.unicode).to_lower()
		if char_typed != "":
			current_input += char_typed
			if current_input.length() > 20:
				current_input = current_input.substr(current_input.length() - 20, 20)
			
			if current_input.ends_with(cheat_code):
				current_input = ""
				trigger_event()
			elif current_input.ends_with(enuma_code): # <--- NEW
				current_input = ""
				trigger_enuma()

func trigger_event():
	print("CHEAT ACTIVATED: METEOR RAIN")
	var game_manager = get_tree().current_scene.get_node_or_null("GameManager")
	if game_manager:
		game_manager.start_meteor_cutscene()

# --- NEW FUNCTION ---
func trigger_enuma():
	print("EA, OPEN!")
	var player = get_tree().current_scene.get_node_or_null("Player")
	if player and player.has_method("fire_enuma_elish"):
		player.fire_enuma_elish()
