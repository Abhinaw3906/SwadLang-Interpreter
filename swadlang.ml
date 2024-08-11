(* SwedLang Tolkare *)

(* Nödvändiga bibliotek *)
open List

(* Hjälpfunktion: span *)
let rec span p = function
  | [] -> ([], [])
  | x :: xs as list -> if p x then 
      let (ys, zs) = span p xs in (x :: ys, zs) 
    else 
      ([], list)

(* Lexer *)
type token =
  | INT of int
  | PLUS | MINUS | TIMES | DIV
  | LPAREN | RPAREN
  | LAT | IN | LIKA
  | OM | DA | ANNARS
  | IDENT of string
  | EOF
  | GT | LT (* Greater than and Less than *)

let tokenize input =
  let rec aux acc = function
    | [] -> List.rev (EOF :: acc)
    | ' ' :: rest -> aux acc rest
    | '\n' :: rest -> aux acc rest
    | '+' :: rest -> aux (PLUS :: acc) rest
    | '-' :: rest -> aux (MINUS :: acc) rest
    | '*' :: rest -> aux (TIMES :: acc) rest
    | '/' :: rest -> aux (DIV :: acc) rest
    | '(' :: rest -> aux (LPAREN :: acc) rest
    | ')' :: rest -> aux (RPAREN :: acc) rest
    | '=' :: rest -> aux (LIKA :: acc) rest
    | '>' :: rest -> aux (GT :: acc) rest
    | '<' :: rest -> aux (LT :: acc) rest
    | ch :: rest when ('a' <= ch && ch <= 'z') || ('A' <= ch && ch <= 'Z') ->
        let (ident, rest') = span (fun c -> ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || ('0' <= c && c <= '9')) (ch :: rest) in
        let ident_str = String.of_seq (List.to_seq ident) in
        let token = match ident_str with
          | "lat" -> LAT (* let *)
          | "i" -> IN (* in *)
          | "om" -> OM (* if *)
          | "da" -> DA (* then *)
          | "annars" -> ANNARS (* else *)
          | _ -> IDENT ident_str
        in
        aux (token :: acc) rest'
    | ch :: rest when '0' <= ch && ch <= '9' ->
        let (num, rest') = span (fun c -> '0' <= c && c <= '9') (ch :: rest) in
        aux (INT (int_of_string (String.of_seq (List.to_seq num))) :: acc) rest'
    | ch :: _ -> failwith (Printf.sprintf "Ovväntat tecken: %c" ch)
  in
  aux [] (List.of_seq (String.to_seq input))

(* Parser och AST *)
type expr =
  | Int of int
  | Var of string
  | BinOp of expr * string * expr
  | Lat of string * expr * expr
  | Om of expr * expr * expr

let rec parse_expr tokens =
  let (expr, rest) = parse_term tokens in
  parse_binop expr rest

and parse_term tokens =
  let (expr, rest) = parse_factor tokens in
  parse_term_op expr rest

and parse_factor = function
  | INT n :: rest -> (Int n, rest)
  | IDENT x :: rest -> (Var x, rest)
  | LPAREN :: rest ->
      let (expr, rest1) = parse_expr rest in
      (match rest1 with
       | RPAREN :: rest2 -> (expr, rest2)
       | _ -> failwith "Förväntad stängning parentes")
  | LAT :: IDENT x :: LIKA :: rest ->
      let (e1, rest1) = parse_expr rest in
      (match rest1 with
       | IN :: rest2 ->
           let (e2, rest3) = parse_expr rest2 in
           (Lat (x, e1, e2), rest3)
       | _ -> failwith "Förväntad 'i' efter lat bindning")
  | OM :: rest ->
      let (cond, rest1) = parse_expr rest in
      (match rest1 with
       | DA :: rest2 ->
           let (then_expr, rest3) = parse_expr rest2 in
           (match rest3 with
            | ANNARS :: rest4 ->
                let (else_expr, rest5) = parse_expr rest4 in
                (Om (cond, then_expr, else_expr), rest5)
            | _ -> failwith "Förväntad 'annars' i om uttryck")
       | _ -> failwith "Förväntad 'da' i om uttryck")
  | _ -> failwith "Ovväntat token i parse_factor"

and parse_term_op left = function
  | TIMES :: rest ->
      let (right, rest1) = parse_factor rest in
      parse_term_op (BinOp (left, "*", right)) rest1
  | DIV :: rest ->
      let (right, rest1) = parse_factor rest in
      parse_term_op (BinOp (left, "/", right)) rest1
  | rest -> (left, rest)

and parse_binop left = function
  | PLUS :: rest ->
      let (right, rest1) = parse_term rest in
      parse_binop (BinOp (left, "+", right)) rest1
  | MINUS :: rest ->
      let (right, rest1) = parse_term rest in
      parse_binop (BinOp (left, "-", right)) rest1
  | LIKA :: rest ->
      let (right, rest1) = parse_term rest in
      parse_binop (BinOp (left, "=", right)) rest1
  | GT :: rest ->
      let (right, rest1) = parse_term rest in
      parse_binop (BinOp (left, ">", right)) rest1
  | LT :: rest ->
      let (right, rest1) = parse_term rest in
      parse_binop (BinOp (left, "<", right)) rest1
  | rest -> (left, rest)

let parse tokens =
  let (expr, rest) = parse_expr tokens in
  match rest with
  | [EOF] -> expr
  | _ -> failwith "Ovväntade token i slutet av input"

(* Tolkare *)
type value =
  | VInt of int
and env = (string * value) list

let rec eval expr env =
  match expr with
  | Int n -> VInt n
  | Var x -> List.assoc x env
  | BinOp (e1, op, e2) ->
      let v1 = eval e1 env in
      let v2 = eval e2 env in
      (match (v1, v2) with
       | (VInt n1, VInt n2) ->
           VInt (match op with
                 | "+" -> n1 + n2
                 | "-" -> n1 - n2
                 | "*" -> n1 * n2
                 | "/" -> n1 / n2
                 | "=" -> if n1 = n2 then 1 else 0
                 | ">" -> if n1 > n2 then 1 else 0
                 | "<" -> if n1 < n2 then 1 else 0
                 | _ -> failwith ("Okänt operator: " ^ op)))
  | Lat (x, e1, e2) ->
      let v1 = eval e1 env in
      eval e2 ((x, v1) :: env)
  | Om (cond, then_expr, else_expr) ->
      match eval cond env with
      | VInt 0 -> eval else_expr env
      | VInt _ -> eval then_expr env

(* Huvud tolkar funktion *)
let interpret input =
  input
  |> tokenize
  |> parse
  |> fun expr -> eval expr []

(* Hjälpfunktion att skriva ut resultat *)
let print_result = function
  | VInt n -> Printf.printf "Resultat: %d\n" n

(* Exempel program *)
let examples = [
  "2 + 3 * 4 - 6 / 2";
  "lat x = 2 i lat y = x + 3 i x * y";
  "om 1 da 100 annars 200";
  "om 5 = 5 da 10 annars 20";
  "om 1 da (om 0 da 100 annars 50) annars 25";
  "om 5 > 3 da 10 annars 20";
  "lat x = 10 i lat y = 20 i om x < y da x * 2 annars y / 2";
]

(* Kör exempel *)
let run_examples () =
  List.iteri (fun i example ->
    Printf.printf "Exempel %d: %s\n" (i + 1) example;
    try
      let result = interpret example in
      print_result result;
      Printf.printf "\n"
    with e ->
      Printf.printf "Fel: %s\n\n" (Printexc.to_string e)
  ) examples

(* Huvudfunktion *)
let main () =
  Printf.printf "Välkommen till SwadLang Tolkare!\n";
  Printf.printf "Kör exempel program:\n";
  run_examples ();
  Printf.printf "\nSkriv in dina egna SwadLang uttryck (tryck Ctrl+D för att avsluta):\n";
  try
    while true do
      Printf.printf "> ";
      flush stdout;
      let input = input_line stdin in
      try
        let result = interpret input in
        print_result result
      with e ->
        Printf.printf "Fel: %s\n" (Printexc.to_string e)
    done
  with End_of_file ->
    Printf.printf "\nAdjö!\n"

(* Kör tolkar *)
let () = main ()
