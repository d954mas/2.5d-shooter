# 2.5D Old School shooter made in default

More info: https://forum.defold.com/t/noname-2-5-shooter-open-source

Play:https://d954mas.itch.io/noname-25d-shooter

Features

1)Culling. Draw only visible walls,objects.

2)Cells color. Every cell can have a color. All objects in that cell and near wall will mix their color.

3)Fog. In shader. Can change distance and fog color.

4)Physics.Base colliders for walls and shoots.

5)Camera.Use rendercam.

6)Pathfinding. Micropather,a c++ pathfinding lib.I have a lightweigth map copy in native, for pathfinding. Worked good and fast.

7)Mouse lock.

8)Pause modal. When you unlocked you mouse, game will be paused.

9)Pickups. Pistol ammo and hp.

10)Simple enemy. Simple state machine.It follow player and hit in melee.

11)Weapons.Pistol

12)Level editor. Defold editor is not good for that types of levels. So I used tiled. Level from tiled will saved in lua. Then I convert that lua file to my own format. I need my own format, because I need make some checks and precalculations. 

13)Luacheck. Static code analysis. It help to keep code clean.

14)Tests.Use deftest for that.Now I have few basic tests.For exampe test that check that all levels can be loaded.

15)Transparent cells. For example vines.

16)ECS. Pattern for game logic.The main idea to use entities(bag for components), components(variables,for example position component) and systems(logic).System iterate entites that have some components, and do some work.So instead of having complex logic in one or few scripts. I have dozens of systems.

17)Addaptive fov. Fov changed for differents screen sizes.

18)Weapon bobbing.
