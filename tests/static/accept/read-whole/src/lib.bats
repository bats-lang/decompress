#include "share/atspre_staload.hats"
#use array as A
#use result as R
#use wasm.bats-packages.dev/decompress as DC

(* A claimed blob is read whole, then freed *)
fn f (h: $DC.blob_handle): int =
  case+ $DC.blob_claim(h) of
  | ~$R.none() => 0
  | ~$R.some(b) => let
      val n = $DC.blob_len(b)
    in
      if n <= 0 then let val () = $DC.blob_free(b) in 0 end
      else if n > 1048576 then let val () = $DC.blob_free(b) in 0 end
      else let
        val buf = $A.alloc<byte>(n)
        val () = $DC.blob_read(b, 0, buf, n)
        val () = $DC.blob_free(b)
        val () = $A.free<byte>(buf)
      in n end
    end
