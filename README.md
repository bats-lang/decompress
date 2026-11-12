# decompress

> **Superseded.** Decompression is in
> [bridge](https://github.com/bats-lang/bridge) (`decompress_req`,
> `blob_claim`, `blob_len`, `blob_read`, `blob_free`, in
> [`src/decompress.bats`](https://github.com/bats-lang/bridge/blob/main/src/decompress.bats)).
> Use `#use wasm.bats-packages.dev/bridge` instead. No package depends on
> this one since bats-lang/quire#175, and the repository is to be archived.

Decompression bridge supporting gzip, deflate, and deflate-raw. Decompression
runs on the host; the result is a blob handle you can read synchronously.
