extends Control


func _on_server_pressed() -> void:
	NetworkManager.start_server()
	GameState.is_game_active = true
	self.hide()

func _on_client_pressed() -> void:
	NetworkManager.start_client()
	GameState.is_game_active = true
	self.hide()
