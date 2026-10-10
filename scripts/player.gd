extends CharacterBody2D
## 玩家基础移动（GitHub 任务 #1）
## 完成标准：
##   1. 上下左右都能正常移动
##   2. 松开按键后玩家停止
##   3. 斜向移动速度不会更快（Input.get_vector 会自动归一化对角方向）

## 移动速度（像素/秒）
const SPEED := 200.0

func _physics_process(_delta: float) -> void:
	# Input.get_vector 返回归一化方向向量：
	# - 单方向长度为 1（例如只按右键 -> (1, 0)）
	# - 斜向（如右上）长度仍为 1，不会更快
	# - 松开所有按键 -> (0, 0)，玩家即停止
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()
