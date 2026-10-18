extends Node2D
## 主场景管理（任务 #6）：失败界面与重新开始

@onready var _game_over_panel: ColorRect = $UI/GameOverPanel
@onready var _player: CharacterBody2D = $Player

func _ready() -> void:
	# 失败界面默认隐藏
	_game_over_panel.visible = false
	# 玩家生命值归零时显示失败界面
	_player.game_over.connect(_on_player_game_over)
	# 重新开始按钮：重载当前关卡，恢复所有初始状态
	$UI/GameOverPanel/RestartButton.pressed.connect(_on_restart_pressed)

func _on_player_game_over() -> void:
	_game_over_panel.visible = true

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
