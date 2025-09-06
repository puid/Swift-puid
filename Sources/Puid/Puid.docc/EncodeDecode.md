# Encode and Decode

This page summarizes how to convert between Puid strings and representative bits.

- encode(bits:): Convert representative bits into a Puid string.
- decode(_:): Convert a Puid string into representative bits (ASCII charsets only).

## Notes

- Not a generic binary encoding like Base64. Only the leading ceil(bitsPerChar) bits per character are used. Unused trailing bits in the last byte are ignored by encode and zeroed by decode. As a result, bytes → encode → decode does not guarantee byte‑for‑byte round‑trip. However, puid → decode → encode will round‑trip the puid string exactly.
- encode(bits:) expects exactly ceil(ceil(bitsPerChar) * length / 8) bytes.
- decode(_:) is supported for ASCII charsets. For non‑ASCII charsets, decode throws.

## Examples

### Encode from bits (non‑round‑trip for unused trailing bits)

```swift
import Puid

let id = try Puid(bits: 55, chars: .alphaLower)
// 12 chars * ceil(4.7) = 60 bits ⇒ 8 bytes; last 4 bits are unused
let src = Data([0x8D, 0x8A, 0x02, 0xA8, 0x07, 0x0B, 0x0D, 0x0F]) // unused low nibble set
let s = try id.encode(bits: src)      // "rwfafkahbmgq"
let rep = try id.decode(s)            // representative bits; rep != src, low nibble zeroed

func hex(_ d: Data) -> String { d.map { String(format: "%02x", $0) }.joined(separator: " ") }
print("src:", hex(src))  // ... 0f
print("rep:", hex(rep))  // ... 00
```

### Decode and round‑trip (ASCII)

```swift
import Puid

let hex = try Puid(bits: 128, chars: .hex)
let puid = try hex.generate()
let rep = try hex.decode(puid)
let rt = try hex.encode(bits: rep)
assert(rt == puid)
```

