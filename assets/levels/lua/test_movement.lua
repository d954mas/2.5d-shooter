return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "right-up",
  width = 20,
  height = 20,
  tilewidth = 64,
  tileheight = 64,
  nextlayerid = 8,
  nextobjectid = 6,
  properties = {},
  tilesets = {
    {
      name = "main",
      firstgid = 1,
      filename = "../tilesets/main.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      columns = 0,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      terrains = {},
      tilecount = 34,
      tiles = {
        {
          id = 1,
          image = "../../images/game/walls/wall1.png",
          width = 64,
          height = 64
        },
        {
          id = 2,
          image = "../../images/game/walls/wall2.png",
          width = 64,
          height = 64
        },
        {
          id = 3,
          image = "../../images/game/walls/wall3.png",
          width = 64,
          height = 64
        },
        {
          id = 4,
          image = "../../images/game/walls/wall4.png",
          width = 64,
          height = 64
        },
        {
          id = 5,
          image = "../../images/game/walls/wall5.png",
          width = 64,
          height = 64
        },
        {
          id = 6,
          image = "../../images/game/walls/wall6.png",
          width = 64,
          height = 64
        },
        {
          id = 7,
          image = "../../images/game/walls/wall7.png",
          width = 64,
          height = 64
        },
        {
          id = 8,
          image = "../../images/game/walls/wall8.png",
          width = 64,
          height = 64
        },
        {
          id = 9,
          image = "../../images/game/walls/wall9.png",
          width = 64,
          height = 64
        },
        {
          id = 10,
          image = "../../images/game/walls/wall10.png",
          width = 64,
          height = 64
        },
        {
          id = 11,
          image = "../../images/game/walls/wall11.png",
          width = 64,
          height = 64
        },
        {
          id = 12,
          image = "../../images/game/walls/wall12.png",
          width = 64,
          height = 64
        },
        {
          id = 13,
          image = "../../images/game/walls/wall13.png",
          width = 64,
          height = 64
        },
        {
          id = 14,
          image = "../../images/game/walls/wall14.png",
          width = 64,
          height = 64
        },
        {
          id = 15,
          image = "../../images/game/walls/wall15.png",
          width = 64,
          height = 64
        },
        {
          id = 16,
          image = "../../images/game/walls/wall16.png",
          width = 64,
          height = 64
        },
        {
          id = 17,
          image = "../../images/game/walls/wall17.png",
          width = 64,
          height = 64
        },
        {
          id = 18,
          image = "../../images/game/walls/wall18.png",
          width = 64,
          height = 64
        },
        {
          id = 19,
          image = "../../images/game/walls/wall19.png",
          width = 64,
          height = 64
        },
        {
          id = 20,
          image = "../../images/game/walls/wall20.png",
          width = 64,
          height = 64
        },
        {
          id = 21,
          image = "../../images/game/walls/wall21.png",
          width = 64,
          height = 64
        },
        {
          id = 22,
          image = "../../images/game/walls/wall22.png",
          width = 64,
          height = 64
        },
        {
          id = 23,
          image = "../../images/game/walls/wall23.png",
          width = 64,
          height = 64
        },
        {
          id = 24,
          image = "../../images/game/walls/wall24.png",
          width = 64,
          height = 64
        },
        {
          id = 25,
          image = "../../images/game/walls/wall25.png",
          width = 64,
          height = 64
        },
        {
          id = 26,
          image = "../../images/game/walls/wall26.png",
          width = 64,
          height = 64
        },
        {
          id = 27,
          image = "../../images/game/walls/wall27.png",
          width = 64,
          height = 64
        },
        {
          id = 28,
          image = "../../images/game/walls/wall28.png",
          width = 64,
          height = 64
        },
        {
          id = 29,
          image = "../../images/game/walls/wall29.png",
          width = 64,
          height = 64
        },
        {
          id = 30,
          image = "../../images/game/walls/wall30.png",
          width = 64,
          height = 64
        },
        {
          id = 31,
          image = "../../images/game/walls/wall31.png",
          width = 64,
          height = 64
        },
        {
          id = 32,
          image = "../../images/game/walls/wall32.png",
          width = 64,
          height = 64
        },
        {
          id = 33,
          image = "../../images/game/walls/wall33.png",
          width = 64,
          height = 64
        },
        {
          id = 34,
          image = "../../images/game/walls/wall34.png",
          width = 64,
          height = 64
        }
      }
    },
    {
      name = "objects",
      firstgid = 36,
      filename = "../tilesets/objects.tsx",
      tilewidth = 86,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      columns = 0,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      terrains = {},
      tilecount = 12,
      tiles = {
        {
          id = 1,
          properties = {
            ["spawn_point"] = true
          },
          image = "../tilesets/objects/spawn_point.png",
          width = 64,
          height = 64
        },
        {
          id = 2,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = false,
            ["look_at_player"] = true,
            ["scale"] = 0.5
          },
          image = "../../images/game/objects/block.png",
          width = 64,
          height = 64
        },
        {
          id = 3,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = false,
            ["look_at_player"] = true,
            ["scale"] = 0.5,
            ["size_for_scale"] = 64
          },
          image = "../../images/game/objects/bot_crystal.png",
          width = 64,
          height = 62
        },
        {
          id = 4,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = false,
            ["look_at_player"] = true,
            ["scale"] = 0.5
          },
          image = "../../images/game/objects/bot_crystal_2.png",
          width = 46,
          height = 64
        },
        {
          id = 5,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = true,
            ["look_at_player"] = false,
            ["scale"] = 0.5
          },
          image = "../../images/game/objects/box.png",
          width = 64,
          height = 64
        },
        {
          id = 6,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = false,
            ["look_at_player"] = true,
            ["scale"] = 1,
            ["size_for_scale"] = 64
          },
          image = "../../images/game/objects/lamp.png",
          width = 25,
          height = 13
        },
        {
          id = 7,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = false,
            ["look_at_player"] = true,
            ["scale"] = 0.5,
            ["size_for_scale"] = 64
          },
          image = "../../images/game/objects/mushroom_1.png",
          width = 53,
          height = 63
        },
        {
          id = 8,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = false,
            ["look_at_player"] = true,
            ["scale"] = 0.5,
            ["size_for_scale"] = 64
          },
          image = "../../images/game/objects/mushroom_2.png",
          width = 56,
          height = 60
        },
        {
          id = 9,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = false,
            ["look_at_player"] = true,
            ["scale"] = 0.5,
            ["size_for_scale"] = 64
          },
          image = "../../images/game/objects/skull.png",
          width = 86,
          height = 25
        },
        {
          id = 10,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = false,
            ["look_at_player"] = true,
            ["scale"] = 1
          },
          image = "../../images/game/objects/table.png",
          width = 64,
          height = 64
        },
        {
          id = 11,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = false,
            ["look_at_player"] = true,
            ["scale"] = 0.5,
            ["size_for_scale"] = 64
          },
          image = "../../images/game/objects/top_crystal_1.png",
          width = 61,
          height = 56
        },
        {
          id = 12,
          properties = {
            ["draw"] = true,
            ["global_rotation"] = false,
            ["look_at_player"] = true,
            ["scale"] = 0.5,
            ["size_for_scale"] = 64
          },
          image = "../../images/game/objects/top_crystal_2.png",
          width = 64,
          height = 54
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 2,
      name = "floor",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
      }
    },
    {
      type = "tilelayer",
      id = 6,
      name = "lights",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 7,
      name = "ceil",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      id = 5,
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 1152,
          width = 64,
          height = 64,
          rotation = 0,
          gid = 37,
          visible = true,
          properties = {
            ["spawn_point"] = true
          }
        }
      }
    },
    {
      type = "tilelayer",
      id = 3,
      name = "walls",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 4, 0, 4, 0, 4, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 4, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 5, 5, 0, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 4,
        3, 0, 0, 0, 0, 0, 5, 5, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 4,
        3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 4,
        3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
      }
    }
  }
}
