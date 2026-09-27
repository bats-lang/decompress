#include "share/atspre_staload.hats"
#use array as A
#use result as R
#use wasm.bats-packages.dev/decompress as DC

(* A freed blob cannot be read *)
fn f (h: Int): int =
  case+ $DC.blob_claim(h) of
  | ~$R.none() => 0
  | ~$R.some(b) => let
      val n = $DC.blob_len(b)
    in
      if n <= 0 then let val () = $DC.blob_free(b) in 0 end
      else if n > 1048576 then let val () = $DC.blob_free(b) in 0 end
      else let
        val buf = $A.alloc<byte>(n)
        val () = $DC.blob_free(b)
        val () = $DC.blob_read(b, 0, buf, n)
        val () = $A.free<byte>(buf)
      in n end
    end
