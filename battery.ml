open Prelude

module Dict = Map.Make(String)
type battery =
  { charge     : int;
    max_charge : int }

let explode = String.split_on_char ':' >> List.map String.trim

let less ch1 ch2 = Char.code ch1 <= Char.code ch2
let is_number = String.for_all (fun ch -> less '0' ch && less ch '9')

let read fn filename =
  let chan = open_in filename in
  begin try while true do fn (input_line chan) done
  with End_of_file -> close_in chan end

let load filename =
  let dict = ref Dict.empty in
  read (fun line -> match explode line with
    | [prop; value] when is_number value ->
      dict := Dict.add prop (int_of_string value) !dict
    | _ -> ()) filename;
  !dict

let extract dict =
  { charge     = Dict.find "charge" dict;
    max_charge = Dict.find "max_charge" dict }

let charge bat = 100.0 *. (Float.of_int bat.charge /. Float.of_int bat.max_charge)

let pmu = "/proc/pmu/battery_0"
let () = Printf.printf "%.2f %%\n"
  (load pmu
  |> extract
  |> charge)
