extends CharacterBody2D
## 玩家基础移动（GitHub 任务 #1）
## 完成标准：
##   1. 上下左右都能正常移动
##   2. 松开按键后玩家停止
##   3. 斜向移动速度不会更快（Input.get_vector 会自动归一化对角方向）
## 玩家生命值（GitHub 任务 #4）：
##   - 初始 3，碰到敌人扣 1
##   - body_entered 只在接触开始时触发一次，不会瞬间掉光
##   - 分开后再次接触会继续扣血

## 移动速度（像素/秒）
const SPEED := 200.0
## 玩家生命值（初始 3）
var health := 3

func _ready() -> void:
	# 只有「开始接触」时触发一次，持续贴住不会重复扣血
	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	# Input.get_vector 返回归一化方向向量：
	# - 单方向长度为 1（例如只按右键 -> (1, 0)）
	# - 斜向（如右上）长度仍为 1，不会更快
	# - 松开所有按键 -> (0, 0)，玩家即停止
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy") and health > 0:
		health -= 1
		print("玩家生命值：", health, "/3")
		if health == 0:
			print("生命值归零")
