#include "share/atspre_staload.hats"
#use array as A
#use result as R
#use wasm.bats-packages.dev/decompress as DC

(* A claimed blob must be freed: this one is only measured *)
fn f (h: Int): int =
  case+ $DC.blob_claim(h) of
  | ~$R.none() => 0
  | ~$R.some(b) => $DC.blob_len(b)
