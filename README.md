# decompress

Decompression bridge supporting gzip, deflate, and deflate-raw. Decompression
runs on the host; the result is a blob handle you can read synchronously.

## Constants

| Method | Value | Description |
|--------|-------|-------------|
| GZIP | 0 | gzip format |
| DEFLATE | 1 | deflate (zlib-wrapped) |
| DEFLATE_RAW | 2 | raw deflate (no header) |

## API

```
#use wasm.bats-packages.dev/decompress as DC
#use array as A
#use promise as P

(* Decompress data using the specified method.
   Resolves with a blob handle (integer). *)
$DC.decompress{lb:agz}{n:nat}
  (data: !A.borrow(byte, lb, n), data_len: int n, method: int)
  : promise(int, Pending)

(* Get the decompressed length (call after decompress resolves) *)
$DC.get_len() : int

(* Synchronous read from the decompressed blob.
   Returns the number of bytes actually read. *)
$DC.blob_read{l:agz}{n:nat}
  (handle: int, blob_offset: int,
   out: !A.arr(byte, l, n), len: int n) : int

(* Free a blob handle *)
$DC.blob_free(handle: int) : void
```

## Dependencies

- **array**
- **promise**
