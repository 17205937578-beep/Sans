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

## 正常移动速度（像素/秒）
const SPEED := 200.0
## 碰到敌人后短暂提升到的速度
const BOOST_SPEED := 4000
## 渐增阶段时长（秒）：200 → 250
const BOOST_UP_DURATION := 0.1
## 快速下降阶段时长（秒）：250 → 200
const BOOST_DOWN_DURATION := 20
## 玩家生命值（初始 3）
var health := 3
## 当前移动速度
var _current_speed := SPEED
## 速度状态："" 正常 / "up" 渐增中 / "down" 下降中
var _boost_state := ""
var _boost_timer := 0.0

func _ready() -> void:
	# HurtBox（Area2D）负责检测与敌人的接触：
	# 只有「开始接触」时触发一次，持续贴住不会重复扣血
	$HurtBox.body_entered.connect(_on_body_entered)
	# 游戏开始时显示初始生命值
	print("玩家生命值：", health, "/3")

func _physics_process(delta: float) -> void:
	_update_speed(delta)
	# Input.get_vector 返回归一化方向向量：
	# - 单方向长度为 1（例如只按右键 -> (1, 0)）
	# - 斜向（如右上）长度仍为 1，不会更快
	# - 松开所有按键 -> (0, 0)，玩家即停止
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * _current_speed
	move_and_slide()

func _update_speed(delta: float) -> void:
	# 碰到敌人后的速度曲线：
	# 0~1 秒：从 200 渐增到 250
	# 1~1.3 秒：从 250 快速降回 200
	# 之后恢复正常
	if _boost_state == "up":
		_boost_timer -= delta
		var progress := 1.0 - _boost_timer / BOOST_UP_DURATION
		_current_speed = lerpf(SPEED, BOOST_SPEED, progress)
		if _boost_timer <= 0.0:
			_boost_state = "down"
			_boost_timer = BOOST_DOWN_DURATION
	elif _boost_state == "down":
		_boost_timer -= delta
		var progress := 1.0 - _boost_timer / BOOST_DOWN_DURATION
		_current_speed = lerpf(BOOST_SPEED, SPEED, progress)
		if _boost_timer <= 0.0:
			_boost_state = ""
			_current_speed = SPEED

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		# 只在正常状态触发一次，避免效果叠加
		if _boost_state == "":
			_boost_state = "up"
			_boost_timer = BOOST_UP_DURATION
			print("玩家加速：200 -> 250")
		if health > 0:
			health -= 1
			print("玩家生命值：", health, "/3")
			if health == 0:
				print("生命值归零")
