open Prelude
open Herbst

let showMod : modifier -> string = function
  | Mod1  -> "Mod1"  | Mod2    -> "Mod2"    | Mod3  -> "Mod3"
  | Mod4  -> "Mod4"  | Mod5    -> "Mod5"    | Alt   -> "Alt"
  | Super -> "Super" | Control -> "Control" | Shift -> "Shift"

let showMousebutton : mousebutton -> string = function
  | Button1 -> "Button1"
  | Button2 -> "Button2"
  | Button3 -> "Button3"
  | Button4 -> "Button4"
  | Button5 -> "Button5"

let showKey (mods, key) =
  List.map showMod mods
  |> fun xs -> xs @ [key]
  |> String.concat "-"

let showMousekey (mods, mouse) =
  List.map showMod mods
  |> fun xs -> xs @ [showMousebutton mouse]
  |> String.concat "-"

let showAttr : attr -> string = function
  | Str x -> x
  | Int n -> string_of_int n
  | Color c -> Printf.sprintf "'%s'" c

let showDir : dir -> string = function
  | L -> "left" | R -> "right"
  | U -> "up"   | D -> "down"

let showAlign : align -> string = function
  | Top     -> "top"     | Bottom -> "bottom"
  | Left    -> "left"    | Right  -> "right"
  | Explode -> "explode" | Auto   -> "auto"

let showMode : mode -> string = function
  | On     -> "on"
  | Off    -> "off"
  | Toggle -> "toggle"

let rec showCmd : cmd -> string = function
  | Spawn cmdline -> Printf.sprintf "spawn %s" cmdline
  | Keybind (key, cmd) -> Printf.sprintf "keybind %s %s" (showKey key) (showCmd cmd)
  | Keyunbind (Some key) -> Printf.sprintf "keyunbind %s" (showKey key)
  | Keyunbind None -> "keyunbind --all" 
  | Mousebind (mouse, act) -> Printf.sprintf "mousebind %s %s" (showMousekey mouse) (showAction act)
  | Mouseunbind (Some mouse) -> Printf.sprintf "mouseunbind %s" (showMousekey mouse)
  | Mouseunbind None -> "mouseunbind --all" 
  | EmitHook hook -> Printf.sprintf "emit_hook %s" hook
  | Rename (tag1, tag2) -> Printf.sprintf "rename %s %s" tag1 tag2
  | Add tag -> Printf.sprintf "add %s" tag
  | Use tag -> Printf.sprintf "use %s" tag
  | Set (key, value) -> Printf.sprintf "set %s %s" key (showAttr value)
  | Attr (key, value) -> Printf.sprintf "attr %s %s" key (showAttr value)
  | Focus dir -> Printf.sprintf "focus %s" (showDir dir)
  | Shift dir -> Printf.sprintf "shift %s" (showDir dir)
  | Split (align, None) -> Printf.sprintf "split %s" (showAlign align)
  | Split (align, Some frac) -> Printf.sprintf "split %s %f" (showAlign align) frac
  | Resize (dir, delta) -> Printf.sprintf "resize %s %+f" (showDir dir) delta 
  | Floating mode -> Printf.sprintf "floating %s" (showMode mode)
  | Fullscreen mode -> Printf.sprintf "fullscreen %s" (showMode mode)
  | Pseudotile mode -> Printf.sprintf "pseudotile %s" (showMode mode)
  | Remove -> "remove"
  | Unlock -> "unlock"
  | Cycle -> "cycle"
  | Quit -> "quit"
and showAction : action -> string = function
  | Move -> "move" | Resize -> "resize" | Zoom -> "zoom"
  | Call cmd -> Printf.sprintf "call %s" (showCmd cmd)

let client = Printf.sprintf "herbstclient %s"
let hc = showCmd >> client >> Sys.command >> ignore
