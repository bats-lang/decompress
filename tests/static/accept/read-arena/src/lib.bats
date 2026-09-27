#include "share/atspre_staload.hats"
#use array as A
#use result as R
#use wasm.bats-packages.dev/decompress as DC

(* A claimed blob of any size (past alloc's 1 MiB) is read whole into
   the piece of an arena sized to it *)
fn f (h: Int): int =
  case+ $DC.blob_claim(h) of
  | ~$R.none() => 0
  | ~$R.some(b) => let
      val n = $DC.blob_len(b)
    in
      if n <= 0 then let val () = $DC.blob_free(b) in 0 end
      else if n > 268435456 then let val () = $DC.blob_free(b) in 0 end
      else (case+ $A.arena_create<byte>(n) of
        | ~$A.arena_none() => let val () = $DC.blob_free(b) in 0 end
        | ~$A.arena_some(ar) => let
            val p = $A.arena_alloc<byte>(ar, n)
            val () = $DC.blob_read(b, 0, p, n)
            val () = $DC.blob_free(b)
            val () = $A.arena_return<byte>(ar, p)
            val () = $A.arena_destroy<byte>(ar)
          in n end)
    end
