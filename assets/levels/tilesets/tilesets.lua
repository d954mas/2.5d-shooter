return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.3.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 1,
  height = 1,
  tilewidth = 64,
  tileheight = 64,
  nextlayerid = 2,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "walls",
      firstgid = 1,
      filename = "walls.tsx",
      tilewidth = 70,
      tileheight = 70,
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
      properties = {
        ["blocked"] = true
      },
      terrains = {},
      tilecount = 36,
      tiles = {
        {
          id = 0,
          image = "../tiles/walls/wall1.png",
          width = 64,
          height = 64
        },
        {
          id = 1,
          image = "../tiles/walls/wall2.png",
          width = 64,
          height = 64
        },
        {
          id = 2,
          image = "../tiles/walls/wall3.png",
          width = 64,
          height = 64
        },
        {
          id = 3,
          image = "../tiles/walls/wall4.png",
          width = 64,
          height = 64
        },
        {
          id = 4,
          image = "../tiles/walls/wall5.png",
          width = 64,
          height = 64
        },
        {
          id = 5,
          image = "../tiles/walls/wall6.png",
          width = 64,
          height = 64
        },
        {
          id = 6,
          image = "../tiles/walls/wall7.png",
          width = 64,
          height = 64
        },
        {
          id = 7,
          image = "../tiles/walls/wall8.png",
          width = 64,
          height = 64
        },
        {
          id = 8,
          image = "../tiles/walls/wall9.png",
          width = 64,
          height = 64
        },
        {
          id = 9,
          image = "../tiles/walls/wall10.png",
          width = 64,
          height = 64
        },
        {
          id = 10,
          image = "../tiles/walls/wall11.png",
          width = 64,
          height = 64
        },
        {
          id = 11,
          image = "../tiles/walls/wall12.png",
          width = 64,
          height = 64
        },
        {
          id = 12,
          image = "../tiles/walls/wall13.png",
          width = 64,
          height = 64
        },
        {
          id = 13,
          image = "../tiles/walls/wall14.png",
          width = 64,
          height = 64
        },
        {
          id = 14,
          image = "../tiles/walls/wall15.png",
          width = 64,
          height = 64
        },
        {
          id = 15,
          image = "../tiles/walls/wall16.png",
          width = 64,
          height = 64
        },
        {
          id = 16,
          image = "../tiles/walls/wall17.png",
          width = 64,
          height = 64
        },
        {
          id = 17,
          image = "../tiles/walls/wall18.png",
          width = 64,
          height = 64
        },
        {
          id = 18,
          image = "../tiles/walls/wall19.png",
          width = 64,
          height = 64
        },
        {
          id = 19,
          image = "../tiles/walls/wall20.png",
          width = 64,
          height = 64
        },
        {
          id = 20,
          image = "../tiles/walls/wall21.png",
          width = 64,
          height = 64
        },
        {
          id = 21,
          image = "../tiles/walls/wall22.png",
          width = 64,
          height = 64
        },
        {
          id = 22,
          image = "../tiles/walls/wall23.png",
          width = 64,
          height = 64
        },
        {
          id = 23,
          image = "../tiles/walls/wall24.png",
          width = 64,
          height = 64
        },
        {
          id = 24,
          image = "../tiles/walls/wall25.png",
          width = 64,
          height = 64
        },
        {
          id = 25,
          properties = {
            ["wall_animation"] = "{\"animation\" : \"wall26\"}"
          },
          image = "../tiles/walls/wall26.png",
          width = 64,
          height = 64
        },
        {
          id = 26,
          image = "../tiles/walls/wall27.png",
          width = 64,
          height = 64
        },
        {
          id = 27,
          image = "../tiles/walls/wall28.png",
          width = 64,
          height = 64
        },
        {
          id = 28,
          image = "../tiles/walls/wall29.png",
          width = 64,
          height = 64
        },
        {
          id = 29,
          image = "../tiles/walls/wall30.png",
          width = 64,
          height = 64
        },
        {
          id = 30,
          image = "../tiles/walls/wall31.png",
          width = 64,
          height = 64
        },
        {
          id = 31,
          image = "../tiles/walls/wall32.png",
          width = 64,
          height = 64
        },
        {
          id = 32,
          image = "../tiles/walls/wall33.png",
          width = 64,
          height = 64
        },
        {
          id = 33,
          image = "../tiles/walls/wall34.png",
          width = 64,
          height = 64
        },
        {
          id = 34,
          properties = {
            ["blocked"] = false,
            ["texture_size"] = 128,
            ["transparent"] = true
          },
          image = "../tiles/walls/wall35.png",
          width = 64,
          height = 64
        },
        {
          id = 35,
          properties = {
            ["texture_size"] = 70
          },
          image = "../tiles/walls/wall36.png",
          width = 64,
          height = 64
        }
      }
    },
    {
      name = "lights",
      firstgid = 37,
      filename = "lights.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "lights-64.png",
      imagewidth = 1024,
      imageheight = 640,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 64,
        height = 64
      },
      properties = {},
      terrains = {},
      tilecount = 160,
      tiles = {
        {
          id = 0,
          properties = {
            ["color"] = "#fffffbfb"
          }
        },
        {
          id = 1,
          properties = {
            ["color"] = "#ffff1b00"
          }
        },
        {
          id = 2,
          properties = {
            ["color"] = "#ffff7800"
          }
        },
        {
          id = 3,
          properties = {
            ["color"] = "#ffffd900"
          }
        },
        {
          id = 4,
          properties = {
            ["color"] = "#ffdfff00"
          }
        },
        {
          id = 5,
          properties = {
            ["color"] = "#ff00ff4c"
          }
        },
        {
          id = 6,
          properties = {
            ["color"] = "#ff00ffe7"
          }
        },
        {
          id = 7,
          properties = {
            ["color"] = "#ff00deff"
          }
        },
        {
          id = 8,
          properties = {
            ["color"] = "#ff007cff"
          }
        },
        {
          id = 9,
          properties = {
            ["color"] = "#ff001eff"
          }
        },
        {
          id = 10,
          properties = {
            ["color"] = "#ff2000ff"
          }
        },
        {
          id = 11,
          properties = {
            ["color"] = "#ff8000ff"
          }
        },
        {
          id = 12,
          properties = {
            ["color"] = "#ffe100ff"
          }
        },
        {
          id = 13,
          properties = {
            ["color"] = "#ffff00df"
          }
        },
        {
          id = 14,
          properties = {
            ["color"] = "#ffff007f"
          }
        },
        {
          id = 15,
          properties = {
            ["color"] = "#ffff0020"
          }
        },
        {
          id = 16,
          properties = {
            ["color"] = "#ffefebeb"
          }
        },
        {
          id = 17,
          properties = {
            ["color"] = "#ffd81700"
          }
        },
        {
          id = 18,
          properties = {
            ["color"] = "#ffd86600"
          }
        },
        {
          id = 19,
          properties = {
            ["color"] = "#ffd8b800"
          }
        },
        {
          id = 20,
          properties = {
            ["color"] = "#ffbdd800"
          }
        },
        {
          id = 21,
          properties = {
            ["color"] = "#ff00d840"
          }
        },
        {
          id = 22,
          properties = {
            ["color"] = "#ff00d8c4"
          }
        },
        {
          id = 23,
          properties = {
            ["color"] = "#ff00bcd8"
          }
        },
        {
          id = 24,
          properties = {
            ["color"] = "#ff0069d8"
          }
        },
        {
          id = 25,
          properties = {
            ["color"] = "#ff0019d8"
          }
        },
        {
          id = 26,
          properties = {
            ["color"] = "#ff1b00d8"
          }
        },
        {
          id = 27,
          properties = {
            ["color"] = "#ff6d00d8"
          }
        },
        {
          id = 28,
          properties = {
            ["color"] = "#ffbf00d8"
          }
        },
        {
          id = 29,
          properties = {
            ["color"] = "#ffd800bd"
          }
        },
        {
          id = 30,
          properties = {
            ["color"] = "#ffd8006c"
          }
        },
        {
          id = 31,
          properties = {
            ["color"] = "#ffd8001b"
          }
        },
        {
          id = 32,
          properties = {
            ["color"] = "#ffd8d5d5"
          }
        },
        {
          id = 33,
          properties = {
            ["color"] = "#ffa01100"
          }
        },
        {
          id = 34,
          properties = {
            ["color"] = "#ffa04b00"
          }
        },
        {
          id = 35,
          properties = {
            ["color"] = "#ffa08700"
          }
        },
        {
          id = 36,
          properties = {
            ["color"] = "#ff8c9f00"
          }
        },
        {
          id = 37,
          properties = {
            ["color"] = "#ff019f2f"
          }
        },
        {
          id = 38,
          properties = {
            ["color"] = "#ff019f90"
          }
        },
        {
          id = 39,
          properties = {
            ["color"] = "#ff018a9f"
          }
        },
        {
          id = 40,
          properties = {
            ["color"] = "#ff014d9f"
          }
        },
        {
          id = 41,
          properties = {
            ["color"] = "#ff01139f"
          }
        },
        {
          id = 42,
          properties = {
            ["color"] = "#ff15009f"
          }
        },
        {
          id = 43,
          properties = {
            ["color"] = "#ff51009f"
          }
        },
        {
          id = 44,
          properties = {
            ["color"] = "#ff8d009f"
          }
        },
        {
          id = 45,
          properties = {
            ["color"] = "#ffa0008b"
          }
        },
        {
          id = 46,
          properties = {
            ["color"] = "#ffa0004f"
          }
        },
        {
          id = 47,
          properties = {
            ["color"] = "#ffa00014"
          }
        },
        {
          id = 48,
          properties = {
            ["color"] = "#ffbebaba"
          }
        },
        {
          id = 49,
          properties = {
            ["color"] = "#ff610a00"
          }
        },
        {
          id = 50,
          properties = {
            ["color"] = "#ff612d00"
          }
        },
        {
          id = 51,
          properties = {
            ["color"] = "#ff615200"
          }
        },
        {
          id = 52,
          properties = {
            ["color"] = "#ff556000"
          }
        },
        {
          id = 53,
          properties = {
            ["color"] = "#ff01601d"
          }
        },
        {
          id = 54,
          properties = {
            ["color"] = "#ff016057"
          }
        },
        {
          id = 55,
          properties = {
            ["color"] = "#ff015460"
          }
        },
        {
          id = 56,
          properties = {
            ["color"] = "#ff012f60"
          }
        },
        {
          id = 57,
          properties = {
            ["color"] = "#ff010b60"
          }
        },
        {
          id = 58,
          properties = {
            ["color"] = "#ff0d0060"
          }
        },
        {
          id = 59,
          properties = {
            ["color"] = "#ff310060"
          }
        },
        {
          id = 60,
          properties = {
            ["color"] = "#ff560060"
          }
        },
        {
          id = 61,
          properties = {
            ["color"] = "#ff610054"
          }
        },
        {
          id = 62,
          properties = {
            ["color"] = "#ff610030"
          }
        },
        {
          id = 63,
          properties = {
            ["color"] = "#ff61000c"
          }
        },
        {
          id = 64,
          properties = {
            ["color"] = "#ff908d8d"
          }
        },
        {
          id = 65,
          properties = {
            ["color"] = "#ff3f0600"
          }
        },
        {
          id = 66,
          properties = {
            ["color"] = "#ff3f1d00"
          }
        },
        {
          id = 67,
          properties = {
            ["color"] = "#ff3f3500"
          }
        },
        {
          id = 68,
          properties = {
            ["color"] = "#ff383e00"
          }
        },
        {
          id = 69,
          properties = {
            ["color"] = "#ff023e13"
          }
        },
        {
          id = 70,
          properties = {
            ["color"] = "#ff023e38"
          }
        },
        {
          id = 71,
          properties = {
            ["color"] = "#ff02363e"
          }
        },
        {
          id = 72,
          properties = {
            ["color"] = "#ff021e3e"
          }
        },
        {
          id = 73,
          properties = {
            ["color"] = "#ff02073e"
          }
        },
        {
          id = 74,
          properties = {
            ["color"] = "#ff09003e"
          }
        },
        {
          id = 75,
          properties = {
            ["color"] = "#ff20003e"
          }
        },
        {
          id = 76,
          properties = {
            ["color"] = "#ff38003e"
          }
        },
        {
          id = 77,
          properties = {
            ["color"] = "#ff3f0036"
          }
        },
        {
          id = 78,
          properties = {
            ["color"] = "#ff3f001f"
          }
        },
        {
          id = 79,
          properties = {
            ["color"] = "#ff3f0008"
          }
        },
        {
          id = 80,
          properties = {
            ["color"] = "#ff716e6e"
          }
        },
        {
          id = 81,
          properties = {
            ["color"] = "#ffff7f7d"
          }
        },
        {
          id = 82,
          properties = {
            ["color"] = "#ffffa17d"
          }
        },
        {
          id = 83,
          properties = {
            ["color"] = "#ffffe17d"
          }
        },
        {
          id = 84,
          properties = {
            ["color"] = "#ffe6ff7d"
          }
        },
        {
          id = 85,
          properties = {
            ["color"] = "#ff7dff8c"
          }
        },
        {
          id = 86,
          properties = {
            ["color"] = "#ff7dffec"
          }
        },
        {
          id = 87,
          properties = {
            ["color"] = "#ff7de5ff"
          }
        },
        {
          id = 88,
          properties = {
            ["color"] = "#ff7da3ff"
          }
        },
        {
          id = 89,
          properties = {
            ["color"] = "#ff7d80ff"
          }
        },
        {
          id = 90,
          properties = {
            ["color"] = "#ff807dff"
          }
        },
        {
          id = 91,
          properties = {
            ["color"] = "#ffa57dff"
          }
        },
        {
          id = 92,
          properties = {
            ["color"] = "#ffe87dff"
          }
        },
        {
          id = 93,
          properties = {
            ["color"] = "#ffff7de6"
          }
        },
        {
          id = 94,
          properties = {
            ["color"] = "#ffff7da4"
          }
        },
        {
          id = 95,
          properties = {
            ["color"] = "#ffff7d80"
          }
        },
        {
          id = 96,
          properties = {
            ["color"] = "#ff52504f"
          }
        },
        {
          id = 97,
          properties = {
            ["color"] = "#ffd86b69"
          }
        },
        {
          id = 98,
          properties = {
            ["color"] = "#ffd88869"
          }
        },
        {
          id = 99,
          properties = {
            ["color"] = "#ffd8bf69"
          }
        },
        {
          id = 100,
          properties = {
            ["color"] = "#ffc3d869"
          }
        },
        {
          id = 101,
          properties = {
            ["color"] = "#ff69d876"
          }
        },
        {
          id = 102,
          properties = {
            ["color"] = "#ff69d8c8"
          }
        },
        {
          id = 103,
          properties = {
            ["color"] = "#ff69c2d8"
          }
        },
        {
          id = 104,
          properties = {
            ["color"] = "#ff698ad8"
          }
        },
        {
          id = 105,
          properties = {
            ["color"] = "#ff696cd8"
          }
        },
        {
          id = 106,
          properties = {
            ["color"] = "#ff6c69d8"
          }
        },
        {
          id = 107,
          properties = {
            ["color"] = "#ff8c69d8"
          }
        },
        {
          id = 108,
          properties = {
            ["color"] = "#ffc469d8"
          }
        },
        {
          id = 109,
          properties = {
            ["color"] = "#ffd869c3"
          }
        },
        {
          id = 110,
          properties = {
            ["color"] = "#ffd8698b"
          }
        },
        {
          id = 111,
          properties = {
            ["color"] = "#ffd8696c"
          }
        },
        {
          id = 112,
          properties = {
            ["color"] = "#ff353333"
          }
        },
        {
          id = 113,
          properties = {
            ["color"] = "#ffa04e4c"
          }
        },
        {
          id = 114,
          properties = {
            ["color"] = "#ffa0644c"
          }
        },
        {
          id = 115,
          properties = {
            ["color"] = "#ffa08d4c"
          }
        },
        {
          id = 116,
          properties = {
            ["color"] = "#ff909f4b"
          }
        },
        {
          id = 117,
          properties = {
            ["color"] = "#ff4c9f56"
          }
        },
        {
          id = 118,
          properties = {
            ["color"] = "#ff4c9f93"
          }
        },
        {
          id = 119,
          properties = {
            ["color"] = "#ff4c8f9f"
          }
        },
        {
          id = 120,
          properties = {
            ["color"] = "#ff4c659f"
          }
        },
        {
          id = 121,
          properties = {
            ["color"] = "#ff4c4e9f"
          }
        },
        {
          id = 122,
          properties = {
            ["color"] = "#ff4e4b9f"
          }
        },
        {
          id = 123,
          properties = {
            ["color"] = "#ff674b9f"
          }
        },
        {
          id = 124,
          properties = {
            ["color"] = "#ff914b9f"
          }
        },
        {
          id = 125,
          properties = {
            ["color"] = "#ffa04c90"
          }
        },
        {
          id = 126,
          properties = {
            ["color"] = "#ffa04c66"
          }
        },
        {
          id = 127,
          properties = {
            ["color"] = "#ffa04c4f"
          }
        },
        {
          id = 128,
          properties = {
            ["color"] = "#ff1c1a1a"
          }
        },
        {
          id = 129,
          properties = {
            ["color"] = "#ff612e2b"
          }
        },
        {
          id = 130,
          properties = {
            ["color"] = "#ff613c2b"
          }
        },
        {
          id = 131,
          properties = {
            ["color"] = "#ff61552b"
          }
        },
        {
          id = 132,
          properties = {
            ["color"] = "#ff57602b"
          }
        },
        {
          id = 133,
          properties = {
            ["color"] = "#ff2b6034"
          }
        },
        {
          id = 134,
          properties = {
            ["color"] = "#ff2b6059"
          }
        },
        {
          id = 135,
          properties = {
            ["color"] = "#ff2b5660"
          }
        },
        {
          id = 136,
          properties = {
            ["color"] = "#ff2b3d60"
          }
        },
        {
          id = 137,
          properties = {
            ["color"] = "#ff2b2e60"
          }
        },
        {
          id = 138,
          properties = {
            ["color"] = "#ff2e2b60"
          }
        },
        {
          id = 139,
          properties = {
            ["color"] = "#ff3e2b60"
          }
        },
        {
          id = 140,
          properties = {
            ["color"] = "#ff582b60"
          }
        },
        {
          id = 141,
          properties = {
            ["color"] = "#ff612b57"
          }
        },
        {
          id = 142,
          properties = {
            ["color"] = "#ff612b3e"
          }
        },
        {
          id = 143,
          properties = {
            ["color"] = "#ff612b2e"
          }
        },
        {
          id = 144,
          properties = {
            ["color"] = "#ff0a0707"
          }
        },
        {
          id = 145,
          properties = {
            ["color"] = "#ff3f1e1c"
          }
        },
        {
          id = 146,
          properties = {
            ["color"] = "#ff3f281c"
          }
        },
        {
          id = 147,
          properties = {
            ["color"] = "#ff3f381c"
          }
        },
        {
          id = 148,
          properties = {
            ["color"] = "#ff393e1c"
          }
        },
        {
          id = 149,
          properties = {
            ["color"] = "#ff1d3d23"
          }
        },
        {
          id = 150,
          properties = {
            ["color"] = "#ff1d3d39"
          }
        },
        {
          id = 151,
          properties = {
            ["color"] = "#ff1d383d"
          }
        },
        {
          id = 152,
          properties = {
            ["color"] = "#ff1d283d"
          }
        },
        {
          id = 153,
          properties = {
            ["color"] = "#ff1d1f3d"
          }
        },
        {
          id = 154,
          properties = {
            ["color"] = "#ff1f1c3e"
          }
        },
        {
          id = 155,
          properties = {
            ["color"] = "#ff291c3e"
          }
        },
        {
          id = 156,
          properties = {
            ["color"] = "#ff391c3e"
          }
        },
        {
          id = 157,
          properties = {
            ["color"] = "#ff3f1c38"
          }
        },
        {
          id = 158,
          properties = {
            ["color"] = "#ff3f1c29"
          }
        },
        {
          id = 159,
          properties = {
            ["color"] = "#ff3f1c1f"
          }
        }
      }
    },
    {
      name = "objects",
      firstgid = 197,
      filename = "objects.tsx",
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
      properties = {
        ["player"] = true
      },
      terrains = {},
      tilecount = 4,
      tiles = {
        {
          id = 0,
          properties = {
            ["angle"] = 0,
            ["player"] = true
          },
          image = "../tiles/objects/spawn_point_top.png",
          width = 64,
          height = 64
        },
        {
          id = 1,
          properties = {
            ["angle"] = 180,
            ["player"] = true
          },
          image = "../tiles/objects/spawn_point_bottom.png",
          width = 64,
          height = 64
        },
        {
          id = 2,
          properties = {
            ["angle"] = 90,
            ["player"] = true
          },
          image = "../tiles/objects/spawn_point_left.png",
          width = 64,
          height = 64
        },
        {
          id = 3,
          properties = {
            ["angle"] = 270,
            ["player"] = true
          },
          image = "../tiles/objects/spawn_point_right.png",
          width = 64,
          height = 64
        }
      }
    },
    {
      name = "level_objects",
      firstgid = 201,
      filename = "level_objects.tsx",
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
      tilecount = 14,
      tiles = {
        {
          id = 0,
          properties = {
            ["rotation_look_at_player"] = true,
            ["scale"] = 0.5,
            ["sprite_origin_y"] = 32,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/block.png",
          width = 64,
          height = 64
        },
        {
          id = 1,
          properties = {
            ["rotation_look_at_player"] = true,
            ["scale"] = 0.5,
            ["sprite_origin_y"] = 32,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/bot_crystal.png",
          width = 64,
          height = 62
        },
        {
          id = 2,
          properties = {
            ["rotation_look_at_player"] = true,
            ["scale"] = 0.5,
            ["sprite_origin_y"] = 32,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/bot_crystal_2.png",
          width = 46,
          height = 64
        },
        {
          id = 3,
          properties = {
            ["rotation_look_at_player"] = true,
            ["scale"] = 1,
            ["sprite_origin_y"] = 32,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/box.png",
          width = 64,
          height = 64
        },
        {
          id = 4,
          properties = {
            ["position_z"] = 1,
            ["rotation_look_at_player"] = true,
            ["scale"] = 1,
            ["sprite_origin_y"] = -6.5,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/lamp.png",
          width = 25,
          height = 13
        },
        {
          id = 5,
          properties = {
            ["rotation_look_at_player"] = true,
            ["scale"] = 0.5,
            ["sprite_origin_y"] = 32,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/mushroom_1.png",
          width = 53,
          height = 63
        },
        {
          id = 6,
          properties = {
            ["rotation_look_at_player"] = true,
            ["scale"] = 0.5,
            ["sprite_origin_y"] = 30,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/mushroom_2.png",
          width = 56,
          height = 60
        },
        {
          id = 7,
          properties = {
            ["rotation_look_at_player"] = true,
            ["scale"] = 0.5,
            ["sprite_origin_y"] = 12.5,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/skull.png",
          width = 86,
          height = 25
        },
        {
          id = 8,
          properties = {
            ["rotation_look_at_player"] = true,
            ["scale"] = 1,
            ["sprite_origin_y"] = 32,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/table.png",
          width = 64,
          height = 64
        },
        {
          id = 9,
          properties = {
            ["position_z"] = 1,
            ["rotation_look_at_player"] = true,
            ["scale"] = 0.5,
            ["sprite_origin_y"] = -28,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/top_crystal_1.png",
          width = 61,
          height = 56
        },
        {
          id = 10,
          properties = {
            ["position_z"] = 1,
            ["rotation_look_at_player"] = true,
            ["scale"] = 0.5,
            ["sprite_origin_y"] = -28,
            ["texture_size"] = 64
          },
          image = "../tiles/level_objects/top_crystal_2.png",
          width = 64,
          height = 54
        },
        {
          id = 11,
          properties = {
            ["rotation_global"] = true,
            ["tag"] = "cup"
          },
          image = "../tiles/level_objects/cup.png",
          width = 64,
          height = 64
        },
        {
          id = 12,
          properties = {
            ["tag"] = "human"
          },
          image = "../tiles/level_objects/human.png",
          width = 64,
          height = 64
        },
        {
          id = 13,
          properties = {
            ["rotation_global"] = true,
            ["tag"] = "teapot"
          },
          image = "../tiles/level_objects/teapot.png",
          width = 64,
          height = 64
        }
      }
    },
    {
      name = "light_sources",
      firstgid = 215,
      filename = "light_sources.tsx",
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
      tilecount = 1,
      tiles = {
        {
          id = 0,
          properties = {
            ["angle"] = 0,
            ["fov"] = -1,
            ["light"] = true,
            ["light_color"] = "0;0;0.2",
            ["light_distance"] = 1,
            ["light_power"] = 0.5,
            ["light_type"] = "point",
            ["rays"] = -1
          },
          image = "../tiles/light_sources/point.png",
          width = 64,
          height = 64
        }
      }
    },
    {
      name = "pickups",
      firstgid = 216,
      filename = "pickups.tsx",
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
      properties = {
        ["type"] = "pickups"
      },
      terrains = {},
      tilecount = 6,
      tiles = {
        {
          id = 0,
          properties = {
            ["pickup_type"] = "ammo_pistol",
            ["scale"] = 0.5,
            ["sprite_origin_y"] = 16
          },
          image = "../tiles/pickups/pickup_ammo_pistol.png",
          width = 64,
          height = 64
        },
        {
          id = 1,
          properties = {
            ["pickup_type"] = "hp",
            ["scale"] = 0.5,
            ["sprite_origin_y"] = 16
          },
          image = "../tiles/pickups/pickup_hp.png",
          width = 64,
          height = 64
        },
        {
          id = 2,
          properties = {
            ["pickup_key_type"] = "blue",
            ["pickup_type"] = "key",
            ["scale"] = 0.25,
            ["sprite_origin_y"] = 32
          },
          image = "../tiles/pickups/pickup_key_blue.png",
          width = 64,
          height = 64
        },
        {
          id = 3,
          properties = {
            ["pickup_key_type"] = "green",
            ["pickup_type"] = "key",
            ["scale"] = 0.25,
            ["sprite_origin_y"] = 32
          },
          image = "../tiles/pickups/pickup_key_green.png",
          width = 64,
          height = 64
        },
        {
          id = 4,
          properties = {
            ["pickup_key_type"] = "white",
            ["pickup_type"] = "key",
            ["scale"] = 0.25,
            ["sprite_origin_y"] = 32
          },
          image = "../tiles/pickups/pickup_key_white.png",
          width = 64,
          height = 64
        },
        {
          id = 5,
          properties = {
            ["pickup_key_type"] = "yellow",
            ["pickup_type"] = "key",
            ["scale"] = 0.25,
            ["sprite_origin_y"] = 32
          },
          image = "../tiles/pickups/pickup_key_yellow.png",
          width = 64,
          height = 64
        }
      }
    },
    {
      name = "doors",
      firstgid = 222,
      filename = "doors.tsx",
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
      properties = {
        ["door"] = true
      },
      terrains = {},
      tilecount = 5,
      tiles = {
        {
          id = 0,
          image = "../tiles/doors/door1.png",
          width = 64,
          height = 64
        },
        {
          id = 1,
          properties = {
            ["key"] = "blue"
          },
          image = "../tiles/doors/door1_blue.png",
          width = 64,
          height = 64
        },
        {
          id = 2,
          properties = {
            ["key"] = "green"
          },
          image = "../tiles/doors/door1_green.png",
          width = 64,
          height = 64
        },
        {
          id = 3,
          properties = {
            ["key"] = "white"
          },
          image = "../tiles/doors/door1_white.png",
          width = 64,
          height = 64
        },
        {
          id = 4,
          properties = {
            ["key"] = "yellow"
          },
          image = "../tiles/doors/door1_yellow.png",
          width = 64,
          height = 64
        }
      }
    }
  },
  layers = {}
}
