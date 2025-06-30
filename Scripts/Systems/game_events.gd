extends Node

signal game_state_changed(new_state: Global.GAME_STATE, old_state: Global.GAME_STATE)
signal map_generated(size: Vector2i)
signal game_over(winner: Entity)

signal player_resources_updated(resources: Array[Resources])
signal player_troops_updated(troops: Array[Troop])
