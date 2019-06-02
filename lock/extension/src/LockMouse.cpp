// myextension.cpp
// Extension lib defines
#define EXTENSION_NAME LockMouse
#define LIB_NAME "LockMouse"
#define MODULE_NAME "lock_mouse"


// Defold SDK
#define DLIB_LOG_DOMAIN LIB_NAME
#include <dmsdk/sdk.h>

#if defined(DM_PLATFORM_HTML5)

#include <emscripten.h>

static int LockMouse(lua_State* L)
{	
	dmLogWarning("%s:lock mouse2",MODULE_NAME);
    EM_ASM(
		canvas.requestPointerLock = canvas.requestPointerLock ||
			canvas.mozRequestPointerLock ||
			canvas.webkitRequestPointerLock;
		// Ask the browser to lock the pointer
		canvas.onclick = function() {
			canvas.requestPointerLock();
		};
	);
	return 1;
}

static int UnlockMouse(lua_State* L)
{	
	dmLogWarning("%s:unlock mouse",MODULE_NAME);
    EM_ASM(
	 document.exitPointerLock = document.exitPointerLock ||
			   document.mozExitPointerLock ||
			   document.webkitExitPointerLock;
	document.exitPointerLock();
	canvas.onclick = function() {};
  );
	return 1;
}
static int UpdateCursor(lua_State* L){
	return 0;
}

#elif defined(DM_PLATFORM_WINDOWS)
#include <atlbase.h>
#include <atlconv.h>

static int LockMouse(lua_State* L)
{	
	dmLogWarning("%s:lock mouse windows",MODULE_NAME);
	ShowCursor(0);
	return 0;
}

static int UnlockMouse(lua_State* L)
{	
	dmLogWarning("%s:unlock mouse windows",MODULE_NAME);
	ShowCursor(1);
	return 0;
}

static int UpdateCursor(lua_State* L){
	POINT cp;
	GetCursorPos(&cp);
	lua_createtable(L, 2, 0);
    lua_pushnumber(L, 1);
    lua_pushnumber(L, cp.x-100);
    lua_settable(L, -3);
    lua_pushnumber(L, 2);
    lua_pushnumber(L, cp.y-100);
    lua_settable(L, -3);
	SetCursorPos(100,100);
	return 1;
}



#else

static int UpdateCursor(lua_State* L){
	//SetCursorPos(100,100)
	return 0;
}

static int LockMouse(lua_State* L)
{	
	dmLogWarning("%s:lock mouse",MODULE_NAME);
	return 0;
}

static int UnlockMouse(lua_State* L)
{	
	dmLogWarning("%s:unlock mouse",MODULE_NAME);
	return 0;
}

#endif

// Functions exposed to Lua
static const luaL_reg Module_methods[] =
{
    {"lock_mouse", LockMouse},
	{"unlock_mouse", UnlockMouse},
	{"update_cursor", UpdateCursor},
    {0, 0}
};

static void LuaInit(lua_State* L)
{
    int top = lua_gettop(L);

    // Register lua names
    luaL_register(L, MODULE_NAME, Module_methods);

    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

static dmExtension::Result InitializeExtension(dmExtension::Params* params)
{
    // Init Lua
    LuaInit(params->m_L);
    printf("Registered %s Extension\n", MODULE_NAME);
    return dmExtension::RESULT_OK;
}

static dmExtension::Result AppInitializeExtension(dmExtension::AppParams* params)
{
    return dmExtension::RESULT_OK;
}


static dmExtension::Result AppFinalizeExtension(dmExtension::AppParams* params)
{
    return dmExtension::RESULT_OK;
}

static dmExtension::Result FinalizeExtension(dmExtension::Params* params)
{
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, AppInitializeExtension, AppFinalizeExtension, InitializeExtension, 0, 0, FinalizeExtension)