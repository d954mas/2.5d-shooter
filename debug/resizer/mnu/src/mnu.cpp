#define LIB_NAME "mnu"
#define MODULE_NAME LIB_NAME
#define DLIB_LOG_DOMAIN LIB_NAME

// include the Defold SDK
#include <dmsdk/sdk.h>
#include <stdlib.h>

#if defined(DM_PLATFORM_OSX) || defined(DM_PLATFORM_WINDOWS) || defined(DM_PLATFORM_HTML5) || defined(DM_PLATFORM_LINUX)

#ifndef __APPLE__
#define SEA_MENU_IMPLEMENTATION
#endif
#include "sea_menu.h"

static int g_AppMenuCB = LUA_NOREF;
static int g_LastAppMenuResult = 0;
static seam_menu_data* g_CurrentMenu = 0x0;
static seam_menu_data* g_CurrentAppMenu = 0x0;

#define CHECK_CURRENT_MENU() \
{ \
    if (g_CurrentMenu == 0x0) { \
        luaL_error(L, "Missing call to menu.begin()!"); \
    } \
} \

static int Mnu_Begin(lua_State* L)
{
    if (g_CurrentMenu != 0x0) {
        seam_release(g_CurrentMenu);
        g_CurrentMenu = 0x0;
    }
    g_CurrentMenu = seam_begin();
    return 0;
}

static int Mnu_Label(lua_State* L)
{
    CHECK_CURRENT_MENU();

    luaL_checktype(L, 2, LUA_TBOOLEAN);
    seam_item_label(g_CurrentMenu, luaL_checkinteger(L, 1), lua_toboolean(L, 2), (char*)luaL_checkstring(L, 3));
    return 0;
}

static int Mnu_Separator(lua_State* L)
{
    CHECK_CURRENT_MENU();
    seam_item_separator( g_CurrentMenu );
    return 0;
}

static int Mnu_SubBegin(lua_State* L)
{
    CHECK_CURRENT_MENU();
    seam_item_sub_start( g_CurrentMenu, (char*)luaL_checkstring(L, 1) );
    return 0;
}

static int Mnu_SubEnd(lua_State* L)
{
    CHECK_CURRENT_MENU();
    seam_item_sub_end( g_CurrentMenu );
    return 0;
}

static int Mnu_End(lua_State* L)
{
    CHECK_CURRENT_MENU();
    seam_end( g_CurrentMenu );
    return 0;
}

static int Mnu_Show(lua_State* L)
{
    CHECK_CURRENT_MENU();
    lua_pushinteger(L, seam_open_menu( g_CurrentMenu, luaL_checkinteger(L, 1), luaL_checkinteger(L, 2) ));
    seam_release( g_CurrentMenu );
    g_CurrentMenu = 0x0;
    return 1;
}

static void _app_menu_cb(int id)
{
    g_LastAppMenuResult = id;
}

static int Mnu_ShowAppMenu(lua_State* L)
{
    CHECK_CURRENT_MENU();

    if (g_CurrentAppMenu != 0x0) {
        seam_release(g_CurrentAppMenu);
    }

    g_CurrentAppMenu = g_CurrentMenu;
    g_CurrentMenu = 0x0;

    luaL_checktype(L, 1, LUA_TFUNCTION);

    if (g_AppMenuCB != LUA_NOREF)
    {
        luaL_unref(L, LUA_REGISTRYINDEX, g_AppMenuCB);
    }
    lua_pushvalue(L, 1);
    g_AppMenuCB = luaL_ref(L, LUA_REGISTRYINDEX);

    seam_app_menu( g_CurrentAppMenu, _app_menu_cb );
    return 0;
}

// Functions exposed to Lua
static const luaL_reg Module_methods[] =
{
    {"begin", Mnu_Begin},
    {"label", Mnu_Label},
    {"separator", Mnu_Separator},
    {"sub_begin", Mnu_SubBegin},
    {"sub_finish", Mnu_SubEnd},
    {"finish", Mnu_End},
    {"show", Mnu_Show},
    {"show_app_menu", Mnu_ShowAppMenu},
    // {"release", Mnu_Release},
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

static dmExtension::Result AppInitializeMnu(dmExtension::AppParams* params)
{
    return dmExtension::RESULT_OK;
}

static dmExtension::Result InitializeMnu(dmExtension::Params* params)
{
    LuaInit(params->m_L);
    return dmExtension::RESULT_OK;
}

static dmExtension::Result UpdateMnu(dmExtension::Params* params)
{
    lua_State* L = params->m_L;
    int top = lua_gettop(L);
    if (g_LastAppMenuResult != 0 && g_AppMenuCB != LUA_NOREF)
    {
        lua_rawgeti(L, LUA_REGISTRYINDEX, g_AppMenuCB);
        lua_pushinteger(L, g_LastAppMenuResult);
        lua_call(L, 1, 0);
    }
    g_LastAppMenuResult = 0;
    assert(top == lua_gettop(L));
    return dmExtension::RESULT_OK;
}

static dmExtension::Result AppFinalizeMnu(dmExtension::AppParams* params)
{
    return dmExtension::RESULT_OK;
}

static dmExtension::Result FinalizeMnu(dmExtension::Params* params)
{
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(mnu, LIB_NAME, AppInitializeMnu, AppFinalizeMnu, InitializeMnu, UpdateMnu, 0, FinalizeMnu)

#else
static dmExtension::Result InitializeMnu(dmExtension::Params *params)
{
    return dmExtension::RESULT_OK;
}

static dmExtension::Result FinalizeMnu(dmExtension::Params *params)
{
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(mnu, LIB_NAME, 0, 0, InitializeMnu, 0, 0, FinalizeMnu)
#endif