(* decompress -- gzip/deflate decompression *)

#include "share/atspre_staload.hats"

#use array as A
#use promise as P
#use wasm.bats-packages.dev/bridge as B
#use result as R

staload BD = "wasm.bats-packages.dev/bridge/src/decompress.sats"

(* Decompresses data[0, data_len) (method 0 stored, 1 gzip, 2 deflate,
   8 raw deflate); the promise resolves with a handle to claim *)
#pub fun decompress
  {lb:agz}{n:pos}
  (data: !$A.borrow(byte, lb, n), data_len: int n, method: int)
  : $P.promise(Int, $P.Pending)

(* The blob a decompress promise resolved with, or none if it failed: a
   bridge dblob(n), n bytes held by JS *)
#pub fun blob_claim
  (handle: Int): $R.option([n:nat] $BD.dblob(n))

#pub fun blob_len {n:nat} (b: !$BD.dblob(n)): int n

(* out[0, len) := the blob's bytes [blob_offset, blob_offset + len) *)
#pub fun blob_read
  {n:nat}{o,k:nat | o + k <= n}{l:agz}{m:pos | k <= m}
  (b: !$BD.dblob(n), blob_offset: int o,
   out: !$A.arr(byte, l, m), len: int k): void

#pub fun blob_free {n:nat} (b: $BD.dblob(n)): void

implement decompress{lb}{n}(data, data_len, method) = let
  val @(p, r) = $P.create<Int>()
  val id = $P.stash(r)
  val () = $BD.decompress_req(data, data_len, method, id)
in p end

implement blob_claim(handle) = $BD.blob_claim(handle)

implement blob_len{n}(b) = $BD.blob_len(b)

implement blob_read{n}{o,k}{l}{m}(b, blob_offset, out, len) =
  $BD.blob_read(b, blob_offset, out, len)

implement blob_free{n}(b) = $BD.blob_free(b)
