/* sea_menu.h - v0.2 - public domain cross platform menu api
                       no warranty implied; use at your own risk
                       implementation by Sven Andersson, @andsve

    Do this:
      #define SEA_MENU_IMPLEMENTATION
    before you include this file in *one* C, C++ or Obj-C file to create the implementation.

    // i.e. it should look like this:
    #include ...
    #include ...
    #include ...
    #define SEA_MENU_IMPLEMENTATION
    #include "sea_menu.h"

    QUICK NOTES:
      The ideas behind this header lib is inspired by the great stb_* lib collection
      by Sean T. Barrett.

License:
    This software is in the public domain. Where that dedication is not
    recognized, you are granted a perpetual, irrevocable license to copy
    and modify this file however you want.

*/

#ifndef SEAM_INCLUDE_SEA_MENU_H
#define SEAM_INCLUDE_SEA_MENU_H

#if defined (__cplusplus)
extern "C" {
#endif


#ifdef SEA_MENU_STATIC
#define SEAMDEF static
#else
#define SEAMDEF extern
#endif


#if defined(_WIN32)
#define SEA_PLATFORM_WIN
#elif defined(__APPLE__)
#define SEA_PLATFORM_OSX
#endif

typedef enum
{
  SEAM_LABEL       = 0,
  SEAM_SEPARATOR   = 1,
  SEAM_GROUP_BEGIN = 2,
  SEAM_GROUP_END   = 3,
} SEAM_ITEMS;

typedef void (*seam_menu_cb)(int id);

typedef struct seam__menu_item seam__menu_item;

struct seam__menu_item
{
  seam__menu_item() {
    type = SEAM_LABEL;
    label = 0x0;
    id = 0;
    enabled = 0;
    next = 0x0;
  }
  SEAM_ITEMS type;
  char* label;
  int id;
  int enabled;
  struct seam__menu_item* next;
};

typedef struct
{
  struct seam__menu_item* first;
  struct seam__menu_item* last;
} seam_menu_data;


SEAMDEF seam_menu_data* seam_begin();
SEAMDEF void seam_item_label( seam_menu_data*, int, int, char* );
SEAMDEF void seam_item_separator( seam_menu_data* );
SEAMDEF void seam_item_sub_start( seam_menu_data*, char* );
SEAMDEF void seam_item_sub_end( seam_menu_data* );
SEAMDEF void seam_end( seam_menu_data* );
SEAMDEF void seam_app_menu( seam_menu_data* menu, seam_menu_cb );
SEAMDEF int seam_open_menu( seam_menu_data* menu, int, int );
SEAMDEF void seam_release( seam_menu_data* );


#ifdef __cplusplus
}
#endif

//
//
////   end header file   /////////////////////////////////////////////////////
#endif // SEAM_INCLUDE_SEA_MENU_H

#ifdef SEA_MENU_IMPLEMENTATION

#if defined(SEA_PLATFORM_WIN)
#include <windows.h>
#elif defined(SEA_PLATFORM_OSX)
#import <AppKit/AppKit.h>
#endif

SEAMDEF seam_menu_data* seam_begin()
{
  seam_menu_data* menu = (seam_menu_data*)malloc( sizeof(seam_menu_data) );
  menu->first = NULL;
  menu->last = NULL;
  return menu;
}

static void seam__insert_item( seam_menu_data* menu, seam__menu_item* item )
{
  if ( menu->first != NULL )
  {
    menu->last->next = item;
    menu->last = item;
  } else {
    menu->first = item;
    menu->last  = item;
  }
}

SEAMDEF void seam_item_label( seam_menu_data* menu, int id, int enabled, char* label )
{
  seam__menu_item zitem;// = {0};
  seam__menu_item* item = (seam__menu_item*)malloc( sizeof(seam__menu_item) );
  *item = zitem;
  item->type = SEAM_LABEL;
  item->enabled = enabled;
  size_t label_len = strlen( label );
  item->label = (char*)malloc( sizeof(char) * label_len + 1 );
  strncpy( item->label, label, label_len );
  item->label[label_len] = 0;
  item->id = id;
  item->next = NULL;

  seam__insert_item( menu, item );
}

SEAMDEF void seam_item_separator( seam_menu_data* menu )
{
  seam__menu_item zitem;// = {0};
  seam__menu_item* item = (seam__menu_item*)malloc( sizeof(seam__menu_item) );
  *item = zitem;
  item->type = SEAM_SEPARATOR;
  item->enabled = 1;
  seam__insert_item( menu, item );
}

SEAMDEF void seam_item_sub_start( seam_menu_data* menu, char* label )
{
  seam__menu_item zitem;// = {0};
  seam__menu_item* item = (seam__menu_item*)malloc( sizeof(seam__menu_item) );
  *item = zitem;
  item->type = SEAM_GROUP_BEGIN;
  item->enabled = 1;
  size_t label_len = strlen( label );
  item->label = (char*)malloc( sizeof(char) * label_len + 1 );
  strncpy( item->label, label, label_len );
  item->label[label_len] = 0;
  seam__insert_item( menu, item );
}

SEAMDEF void seam_item_sub_end( seam_menu_data* menu )
{
  seam__menu_item zitem;// = {0};
  seam__menu_item* item = (seam__menu_item*)malloc( sizeof(seam__menu_item) );
  *item = zitem;
  item->type = SEAM_GROUP_END;
  item->enabled = 1;
  seam__insert_item( menu, item );
}

SEAMDEF void seam_end( seam_menu_data* menu )
{

}


typedef struct seam__menu_item seam__menu_item;

struct seam__stack_item {
#if defined(SEA_PLATFORM_WIN)
  HMENU native_pointer;
#elif defined(SEA_PLATFORM_OSX)
  id native_pointer;
#endif
  struct seam__stack_item *next;
};

typedef struct
{
  struct seam__stack_item* top;
} seam__walk_stack;


#if defined(SEA_PLATFORM_OSX)

static seam_menu_cb seam__appmenu_callback;

@interface SEAMenuDelegate :  NSObject <NSMenuDelegate>

@end

@implementation SEAMenuDelegate

  - (void)menuDidClose:(NSMenu *)menu
  {

    NSMenu* selected_menu = menu;
    NSMenuItem* selected_item = [selected_menu highlightedItem];
    while (true)
    {
      if ([selected_item hasSubmenu])
      {
        selected_menu = [selected_item submenu];
        selected_item = [selected_menu highlightedItem];
      } else {
        if (seam__appmenu_callback) {
          seam__appmenu_callback([selected_item tag]);
        }
        break;
      }
    }

  }

@end

static SEAMenuDelegate* seam__appmenu_delegate;


#endif


#if defined(SEA_PLATFORM_WIN)
static HMENU _seam_create_menu( seam_menu_data* menu, int x, int y )
#elif defined(SEA_PLATFORM_OSX)
static id _seam_create_menu( seam_menu_data* menu, int x, int y )
#else
static int _seam_create_menu( seam_menu_data* menu, int x, int y )
#endif
{
  seam__walk_stack walk_stack;
  seam__menu_item* item = menu->first;

  // setup steps
#if defined(SEA_PLATFORM_WIN)

  HMENU native_menu = CreatePopupMenu();

#elif defined(SEA_PLATFORM_OSX)

  id native_menu = [[[NSMenu alloc] initWithTitle:@"File"] autorelease];
  // id native_menu = [[NSMenu new] autorelease];
  [native_menu setAutoenablesItems:NO];
#else
  int native_menu = 0;
#endif


  walk_stack.top = (struct seam__stack_item*)malloc( sizeof(struct seam__stack_item) );
  walk_stack.top->next = NULL;
#if defined(SEA_PLATFORM_WIN)
  walk_stack.top->native_pointer = native_menu;
#elif defined(SEA_PLATFORM_OSX)
  walk_stack.top->native_pointer = native_menu;
#endif

  while (item)
  {
    switch (item->type)
    {
      case SEAM_LABEL: {
#if defined(SEA_PLATFORM_WIN)
        UINT flags = MF_STRING;
        if (!item->enabled)
          flags |= MF_GRAYED;
        AppendMenu(walk_stack.top->native_pointer, flags, item->id, item->label);
#elif defined(SEA_PLATFORM_OSX)
        id menu_item = [[[NSMenuItem alloc] initWithTitle:[NSString stringWithUTF8String:item->label] action:NULL keyEquivalent:@""] autorelease];
        [menu_item setTag:item->id];
        [walk_stack.top->native_pointer addItem:menu_item];

        [menu_item setEnabled:item->enabled];

        /*
        NOTE: use this to get a smaller size of items
        */
        // NSDictionary *attributes = [NSDictionary dictionaryWithObject:[NSFont menuFontOfSize: [NSFont smallSystemFontSize]] forKey:NSFontAttributeName];
        // NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:[menu_item title] attributes:attributes];
        // [menu_item setAttributedTitle:attributedTitle];
#endif
      } break;
      case SEAM_SEPARATOR: {
#if defined(SEA_PLATFORM_WIN)
        AppendMenu(walk_stack.top->native_pointer, MF_SEPARATOR, 0, NULL);
#elif defined(SEA_PLATFORM_OSX)
        id menu_item = [NSMenuItem separatorItem];
        [walk_stack.top->native_pointer addItem:menu_item];
        [menu_item setEnabled:item->enabled];

        // NSDictionary *attributes = [NSDictionary dictionaryWithObject:[NSFont menuFontOfSize: [NSFont smallSystemFontSize]] forKey:NSFontAttributeName];
        // NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:[menu_item title] attributes:attributes];
        // [menu_item setAttributedTitle:attributedTitle];
#endif
      } break;
      case SEAM_GROUP_BEGIN: {
        struct seam__stack_item* subitem = (struct seam__stack_item*)malloc( sizeof(struct seam__stack_item) );
        subitem->next = walk_stack.top;
        walk_stack.top = subitem;

#if defined(SEA_PLATFORM_WIN)
        UINT flags = MF_POPUP;
        HMENU subMenu = CreatePopupMenu();
        subitem->native_pointer = subMenu;

        if (!item->enabled)
          flags |= MF_GRAYED;

        AppendMenu(walk_stack.top->next->native_pointer, flags, (UINT)subMenu, item->label);

#elif defined(SEA_PLATFORM_OSX)

        id subMenu = [[NSMenu new] initWithTitle:[NSString stringWithUTF8String:item->label]];
        subitem->native_pointer = subMenu;
        [subMenu setAutoenablesItems:NO];

        id menu_item = [[[NSMenuItem alloc] initWithTitle:[NSString stringWithUTF8String:item->label] action:NULL keyEquivalent:@""] autorelease];
        [walk_stack.top->next->native_pointer addItem:menu_item];
        [menu_item setTag:-1];
        [menu_item setSubmenu:subMenu];

        [menu_item setEnabled:item->enabled];

        // NSDictionary *attributes = [NSDictionary dictionaryWithObject:[NSFont menuFontOfSize: [NSFont smallSystemFontSize]] forKey:NSFontAttributeName];
        // NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:[menu_item title] attributes:attributes];
        // [menu_item setAttributedTitle:attributedTitle];
#endif
      } break;
      case SEAM_GROUP_END: {
        if (walk_stack.top)
        {
          struct seam__stack_item* subitem = walk_stack.top;
          walk_stack.top = walk_stack.top->next;
          free(subitem);
          subitem = (seam__stack_item*)0xdeadbeef;
        }
      } break;
    }
    item = item->next;
  }

  // unwind stack
  while (walk_stack.top)
  {
    struct seam__stack_item* item = walk_stack.top;
    walk_stack.top = item->next;
    free( item );
  }

  return native_menu;
}

SEAMDEF int seam_open_menu( seam_menu_data* menu, int x, int y )
{
#if defined(SEA_PLATFORM_WIN)
  HMENU native_menu = _seam_create_menu( menu, x, y );
#elif defined(SEA_PLATFORM_OSX)
  id native_menu = _seam_create_menu( menu, x, y );
#endif
  int ret = -1;

#if defined(SEA_PLATFORM_WIN)

  HWND hWnd = GetActiveWindow();
  POINT point;
  point.x = x;
  point.y = y;
  ClientToScreen(hWnd, &point);

  ret = TrackPopupMenu(native_menu, TPM_RIGHTBUTTON | TPM_NONOTIFY | TPM_RETURNCMD | TPM_VERPOSANIMATION, point.x, point.y, 0, hWnd, NULL);
  DestroyMenu(native_menu);

#elif defined(SEA_PLATFORM_OSX)

  NSWindow* window = [NSApp keyWindow];
  NSView *view = [window contentView];

  NSMenu *popMenu = [native_menu copy];
  NSRect frame = [view frame];
  frame.origin.x = x;
  frame.origin.y = y;

  NSPoint point;
  point.x = frame.origin.x;
  point.y = frame.size.height - frame.origin.y;

  [popMenu popUpMenuPositioningItem:nil atLocation:point inView:view];

  NSMenu* selected_menu = popMenu;
  NSMenuItem* selected_item = [selected_menu highlightedItem];
  while (true)
  {
    if ([selected_item hasSubmenu])
    {
      selected_menu = [selected_item submenu];
      selected_item = [selected_menu highlightedItem];
    } else {
      ret = [selected_item tag];
      break;
    }
  }

#endif

  return ret;
}

SEAMDEF void seam_app_menu( seam_menu_data* menu, seam_menu_cb callback )
{
#if defined(SEA_PLATFORM_WIN)
  HMENU native_menu = _seam_create_menu( menu, 0, 0 );
#elif defined(SEA_PLATFORM_OSX)
  id native_menu = _seam_create_menu( menu, 0, 0 );
  // id native_menu2 = _seam_create_menu( menu, 0, 0 );
#endif
  int ret = -1;

#if defined(SEA_PLATFORM_WIN)

//#error "Not seam_app_menu implemented on Windows"
  // ret = TrackPopupMenu(native_menu, TPM_RIGHTBUTTON | TPM_NONOTIFY | TPM_RETURNCMD | TPM_VERPOSANIMATION, point.x, point.y, 0, hWnd, NULL);
  // DestroyMenu(native_menu);

#elif defined(SEA_PLATFORM_OSX)

  seam__appmenu_delegate = [[SEAMenuDelegate alloc] init];
  seam__appmenu_callback = callback;

  id appMenu = [native_menu copy];
  [appMenu setDelegate: seam__appmenu_delegate];

  for (id sub in [appMenu itemArray])
  {
    if ([sub hasSubmenu]) {
      [[sub submenu] setDelegate: seam__appmenu_delegate];
    }
  }

  [NSApp setMainMenu:appMenu];

#endif

}


SEAMDEF void seam_release( seam_menu_data* menu )
{
  seam__menu_item* item = menu->first;

  while (item)
  {
    seam__menu_item* next = item->next;
    switch (item->type)
    {
      case SEAM_SEPARATOR:{} break;
      case SEAM_GROUP_END:{} break;
      case SEAM_GROUP_BEGIN:
      case SEAM_LABEL: {
        free( item->label );
      } break;
    }

    free( item );
    item = next;
  }

  free( menu );
}

#endif // SEA_MENU_IMPLEMENTATION
