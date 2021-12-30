open Prelude
open Herbst
open Decode

let modkey = Super
let terminal = "uxterm"
let resizestep = 0.05

let tags = ["etc"; "dev"; "web"]

let keybind (key, cmd) = Keybind (key, cmd)
let mousebind (key, mouse) = Mousebind (key, mouse)

let set (key, value) = Set (key, value)
let attr (key, value) = Attr (key, value)

let keybindings = [
  ([modkey], "Return"), Spawn terminal;
  ([modkey], "r"), Spawn "/usr/bin/dmenu_run";
  ([modkey; Control], "q"), Quit;
  (* basic movement *)

  (* focusing clients *)
  ([modkey], "Left"), Focus L;
  ([modkey], "Right"), Focus R;
  ([modkey], "Down"), Focus D;
  ([modkey], "Up"), Focus U;

  (* moving clients *)
  ([Control], "Left"), Shift L;
  ([Control], "Right"), Shift R;
  ([Control], "Down"), Shift D;
  ([Control], "Up"), Shift U;

  (* resizing frames *)
  ([modkey; Control], "Left"), Resize (L, resizestep);
  ([modkey; Control], "Right"), Resize (R, resizestep);
  ([modkey; Control], "Up"), Resize (U, resizestep);
  ([modkey; Control], "Down"), Resize (D, resizestep);

  (* splitting frames *)
  ([modkey], "u"), Split (Bottom, Some 0.5);
  ([modkey], "o"), Split (Right, Some 0.5);
  ([modkey; Control], "space"), Split (Explode, Some 0.5);

  (* layouting *)
  ([modkey; Shift], "r"), Remove;
  ([modkey], "s"), Floating Toggle;
  ([modkey], "f"), Fullscreen Toggle;
  ([modkey], "p"), Pseudotile Toggle;

  (* focus *)
  ([modkey], "c"), Cycle
]

let mousebindings = [
  ([modkey], Button1), Move;
  ([modkey], Button2), Zoom;
  ([modkey], Button3), Resize
]

let theme = [
  "frame_border_active_color", Color "#222222";
  "frame_border_normal_color", Color "#101010";
  "frame_bg_normal_color",     Color "#565656";
  "frame_bg_active_color",     Color "#345F0C";
  "frame_border_width",        Int 1;
  "always_show_frame",         Int 1;
  "frame_bg_transparent",      Int 1;
  "frame_transparent_width",   Int 5;
  "frame_gap",                 Int 4;
  "window_gap",                Int 0;
  "frame_padding",             Int 0;
  "smart_window_surroundings", Int 0;
  "smart_frame_surroundings",  Int 0;
  "mouse_recenter_gap",        Int 0
]

let attrs = [
  "theme.active.color",          Color "#9FBC00";
  "theme.normal.color",          Color "#454545";
  "theme.urgent.color",          Str "orange";
  "theme.inner_width",           Int 1;
  "theme.inner_color",           Str "black";
  "theme.border_width",          Int 3;
  "theme.floating.border_width", Int 4;
  "theme.floating.outer_width",  Int 1;
  "theme.floating.outer_color",  Str "black";
  "theme.active.inner_color",    Color "#3E4A00";
  "theme.background_color",      Color "#141414"
]

let nth n = ([modkey], string_of_int n)

let () =
  hc (EmitHook "reload");
  hc (Keyunbind None);
  hc (Mouseunbind None);
  List.iter (keybind >> hc) keybindings;
  List.iter (mousebind >> hc) mousebindings;

  match tags with
  | [] -> failwith "No tags!"
  | default :: xs -> begin
    hc (Rename ("default", default));
    hc (Keybind (nth 1, Use default));
    List.iteri (fun idx tag -> hc (Add tag);
      hc (Keybind (nth (idx + 2), Use tag))) xs;
  end;

  hc (Attr ("theme.tiling.reset", Int 1));
  hc (Attr ("theme.floating.reset", Int 1));

  List.iter (set >> hc) theme;
  List.iter (attr >> hc) attrs;

  hc Unlock
