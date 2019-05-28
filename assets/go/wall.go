embedded_components {
  id: "south"
  type: "sprite"
  data: "tile_set: \"/assets/images/walls.atlas\"\n"
  "default_animation: \"wall_s\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 32.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "north"
  type: "sprite"
  data: "tile_set: \"/assets/images/walls.atlas\"\n"
  "default_animation: \"wall_n\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: -32.0
  }
  rotation {
    x: 0.0
    y: 1.0
    z: 0.0
    w: 6.123234E-17
  }
}
embedded_components {
  id: "east"
  type: "sprite"
  data: "tile_set: \"/assets/images/walls.atlas\"\n"
  "default_animation: \"wall_e\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 32.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.70710677
    z: 0.0
    w: 0.70710677
  }
}
embedded_components {
  id: "west"
  type: "sprite"
  data: "tile_set: \"/assets/images/walls.atlas\"\n"
  "default_animation: \"wall_w\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: -32.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.70710677
    z: 0.0
    w: 0.70710677
  }
}
