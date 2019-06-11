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
  nextlayerid = 6,
  nextobjectid = 23,
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
      tilecount = 4,
      tiles = {
        {
          id = 1,
          image = "../tilesets/main/wall1.png",
          width = 64,
          height = 64
        },
        {
          id = 2,
          image = "../tilesets/main/wall2.png",
          width = 64,
          height = 64
        },
        {
          id = 3,
          image = "../tilesets/main/wall3.png",
          width = 64,
          height = 64
        },
        {
          id = 4,
          image = "../tilesets/main/wall4.png",
          width = 64,
          height = 64
        }
      }
    },
    {
      name = "objects",
      firstgid = 6,
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
            ["draw"] = true
          },
          image = "../tilesets/objects/block.png",
          width = 64,
          height = 64
        },
        {
          id = 3,
          properties = {
            ["draw"] = true
          },
          image = "../tilesets/objects/bot_crystal.png",
          width = 64,
          height = 62
        },
        {
          id = 4,
          properties = {
            ["draw"] = true
          },
          image = "../tilesets/objects/bot_crystal_2.png",
          width = 46,
          height = 64
        },
        {
          id = 5,
          properties = {
            ["draw"] = true
          },
          image = "../tilesets/objects/box.png",
          width = 64,
          height = 64
        },
        {
          id = 6,
          properties = {
            ["draw"] = true
          },
          image = "../tilesets/objects/lamp.png",
          width = 25,
          height = 13
        },
        {
          id = 7,
          properties = {
            ["draw"] = true
          },
          image = "../tilesets/objects/mushroom_1.png",
          width = 53,
          height = 63
        },
        {
          id = 8,
          properties = {
            ["draw"] = true
          },
          image = "../tilesets/objects/mushroom_2.png",
          width = 56,
          height = 60
        },
        {
          id = 9,
          properties = {
            ["draw"] = true
          },
          image = "../tilesets/objects/skull.png",
          width = 86,
          height = 25
        },
        {
          id = 10,
          properties = {
            ["draw"] = true
          },
          image = "../tilesets/objects/table.png",
          width = 64,
          height = 64
        },
        {
          id = 11,
          properties = {
            ["draw"] = true
          },
          image = "../tilesets/objects/top_crystal_1.png",
          width = 61,
          height = 56
        },
        {
          id = 12,
          properties = {
            ["draw"] = true
          },
          image = "../tilesets/objects/top_crystal_2.png",
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
          gid = 7,
          visible = true,
          properties = {
            ["spawn_point"] = true
          }
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 960,
          width = 64,
          height = 64,
          rotation = 0,
          gid = 8,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 960,
          width = 64,
          height = 62,
          rotation = 0,
          gid = 9,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 384,
          y = 960,
          width = 46,
          height = 64,
          rotation = 0,
          gid = 10,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 832,
          width = 25,
          height = 13,
          rotation = 0,
          gid = 12,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 832,
          width = 53,
          height = 63,
          rotation = 0,
          gid = 13,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 384,
          y = 832,
          width = 56,
          height = 60,
          rotation = 0,
          gid = 14,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 512,
          y = 832,
          width = 86,
          height = 25,
          rotation = 0,
          gid = 15,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "rectangle",
          x = 512,
          y = 960,
          width = 64,
          height = 64,
          rotation = 0,
          gid = 16,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 704,
          width = 64,
          height = 64,
          rotation = 0,
          gid = 11,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 704,
          width = 64,
          height = 54,
          rotation = 0,
          gid = 18,
          visible = true,
          properties = {}
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
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
        2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
      }
    }
  }
}
