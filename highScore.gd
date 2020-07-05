extends Label

func _ready():
	set_text('HIGH SCORE: ' + str(game.high_score))

func reload():
	set_text('HIGH SCORE: ' + str(game.high_score))
