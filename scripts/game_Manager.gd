extends Node

# 🎯 CURRENT SCORE
var score: int = 0

# 🏆 BEST SCORE (saved)
var best_score: int = 0

# 🔄 GAME STATES
var rotated_45 := false
var rotated_90 := false
var rotated_180 := false
var gravity := true

# 💾 SAVE FILE PATH
const SAVE_PATH = "user://save_game.dat"


# 📂 LOAD SAVE FILE
func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		best_score = file.get_var() # 📥 load best score


# 💾 SAVE GAME
func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(best_score) # 📤 save best score
