std = "lua51"
files['.luacheckrc'].global = false
unused_args = false
cache = true
jobs = 4
--remove some imported libs
exclude_files = {
	"richtext/**",
	"gooey/**",
	"libs/rx.lua",
	"libs/log.lua",
	"libs/ecs.lua",
}

read_globals = {
  "sys",
  "go",
  "gui",
  "label",
  "render",
  "crash",
  "sprite",
  "sound",
  "tilemap",
  "spine",
  "particlefx",
  "physics",
  "factory",
  "collectionfactory",
  "iac",
  "msg",
  "vmath",
  "url",
  "http",
  "image",
  "json",
  "zlib",
  "iap",
  "push",
  "facebook",
  "hash",
  "hash_to_hex",
  "pprint",
  "window",
  "unityads",
  "socket",
  "defreview",
  "resource",
  "buffer",
  "appsflyer",
  "timer",
  "model",
  "profiler",
  "defos",
  "mnu"
}

globals = {
  "init",
  "final",
  "update",
  "on_input",
  "on_message",
  "on_reload",
  "__dm_script_instance__"
}
