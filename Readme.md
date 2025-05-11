## 🛠️ 2025-04-20 Update (Win)
- 添加BlackOverlay 渐变切入场景
- 添加三步 1.渐变 2.动画（走到中央） 3.dialogic剧情


## 🛠️ 2025-04-20 Update (战斗场景)
- 添加Asset：background，cybertruck
- 添加right&left boundary限制玩家左右行动
- 当score >= 5 -> 显示小箭头，玩家可以向右行走进入下一个场景


## 🛠️ 2025-04-13 Update (Win)
- 添加`GameOver.tscn` restart，quit按钮
- 添加`Win.tscn`
- 当score >= 5 -> 跳转`Win.tscn`

## 🛠️ 2025-04-06 Update (GameOver)
- 链接`GameOver.tscn`和`Game.tscn`
- `GameOver.tscn`添加随机的title


## 🛠️ 2025-04-05 Update (战斗场景)
- 添加Dialogic插件加载剧情
- 添加`GameOver.tscn`

## 🛠️ 2025-04-04 Update (战斗场景)
- Enemy接触player，player死亡
- 记分系统，敌人死亡score+=1
- 鼠标改变投掷方向

## 🛠️ 2025-03-30 Update (战斗场景)
- Tomato接触enemy，enemy死亡

## 🛠️ 2025-03-29 Update (战斗场景)
- Tomato.tscn添加动画fly、explosion，运动速度
- Tomato和collison2d撞击后爆炸
- Enemy.tsc添加动画walk_right、walk_left
- game.gd 从两侧随机生成enemy

## 🛠️ 2025-03-28 Update (战斗场景)
- Game.tscn添加gravity，ground
- 添加投掷类武器（`Scenes/Tomato.tscn`，`Scripts/tomato.gd`)
- 添加敌人（`Scenes/Enemy.tscn`，`Scripts/Enemy.gd`)

## 🛠️ 2025-03-26 Update (战斗场景)
- 添加主战斗场景 (`Scenes/Game.tscn`)  
- 添加玩家角色场景 (`Scenes/player.tscn`,`Scripts/player.gd`)
- 使用免费 sprite 作为占位图进行原型开发
- 映射： A-left， D-right 
- Game.tscn添加camera
- player.tscn添加动画：idle，walk，dead

---
## 🛠️ 2025-05-11 Update (战斗场景)
-多样化的敌人难度，不同的生命值和行走速度 ("Scripts/level_management.gd“， "Scripts/enemy.gd“)
-不同level的敌人出场频率优化

## 🛠️ 2025-05-4 Update (战斗场景)
-添加Level management ("Scripts/level_management.gd")


## 🛠️ 2025-04-16 Update (Options界面)
- 添加双语按钮

## 🛠️ 2025-04-16 Update (Win)
- 废墟界面结构跟战斗界面类似，有ground，背景，玩家可以左右移动。
- 进入界面之后2秒左右会切入dialogic， 跳出旁白内容“那些金色高楼...存在过。“，剧情进行时玩家不可移动。
- 旁白结束后，玩家可以左右移动 (maybe change to end of game)

## 🛠️ 2025-04-13 Update (开始界面)
- 开始页面的互动：start game, exit
- 添加options页面 (`Scenes/options.tscn`)
- options页面可以调节音量，返回到主页面

## 🛠️ 2025-03-29 Update (开始界面)
- 添加游戏开始页面 ('Scenes/main_menu.tscn')
