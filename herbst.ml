type modifier =
  | Mod1 | Mod2  | Mod3 | Mod4 | Mod5
  | Alt  | Super | Control | Shift 

type key = modifier list * string

type mousebutton =
  | Button1 | Button2 | Button3 | Button4 | Button5

type mousekey = modifier list * mousebutton

type attr =
  | Str of string
  | Int of int
  | Color of string

type dir = L | R | U | D

type align =
  | Top     | Bottom
  | Left    | Right
  | Explode | Auto

type mode =
  | On | Off | Toggle

type cmd =
  | Spawn of string
  | Keybind of key * cmd
  | Keyunbind of key option
  | Mousebind of mousekey * action
  | Mouseunbind of mousekey option
  | EmitHook of string
  | Rename of string * string
  | Add of string
  | Use of string
  | Set of string * attr
  | Attr of string * attr
  | Focus of dir
  | Shift of dir
  | Split of align * float option
  | Resize of dir * float
  | Floating of mode
  | Fullscreen of mode
  | Pseudotile of mode
  | Remove
  | Cycle
  | Unlock
  | Quit
and action =
  | Move
  | Resize
  | Zoom
  | Call of cmd
