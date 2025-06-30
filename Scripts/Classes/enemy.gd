class_name Enemy extends Entity

var build_cooldown: float = 8.0
var expand_cooldown: float = 4.0

var time_since_build: float = 0.0
var time_since_expand: float = 0.0

func _ready():
	super()
	self.is_expanding = true

func _process(delta: float):
	if Global.game_state != Global.GAME_STATE.GAME:
		return
	
	process_entity(delta)
	
	time_since_build += delta
	time_since_expand += delta
	
	if time_since_build >= build_cooldown:
		_ai_process_build_logic()
		time_since_build = 0.0
	
	if is_expanding and time_since_expand >= expand_cooldown:
		expand()
		time_since_expand = 0.0
