(* decompress -- gzip/deflate decompression *)

#include "share/atspre_staload.hats"

#use array as A
#use promise as P
#use wasm.bats-packages.dev/bridge as B
#use result as R

#pub fun decompress
  {lb:agz}{n:pos}
  (data: !$A.borrow(byte, lb, n), data_len: int n, method: int)
  : $P.promise(int, $P.Pending)

#pub fun get_len(): int

#pub fun blob_read
  {l:agz}{n:pos}
  (handle: int, blob_offset: int,
   out: !$A.arr(byte, l, n), len: int n): $R.result(int)

#pub fun blob_free
  (handle: int): void

implement decompress{lb}{n}(data, data_len, method) = let
  val @(p, r) = $P.create<int>()
  val id = $P.stash(r)
  val () = $B.decompress_req(data, data_len, method, id)
in p end

implement get_len() = $B.decompress_len()

implement blob_read{l}{n}(handle, blob_offset, out, len) =
  $B.blob_read(handle, blob_offset, out, len)

implement blob_free(handle) = $B.blob_free(handle)
