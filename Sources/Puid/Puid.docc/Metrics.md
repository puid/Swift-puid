# Metrics

This page summarizes Puid’s entropy metrics and shows how to inspect them from Swift. The content below is taken from the package README for convenience.

## Entropy Representation Efficiency (ERE)

Entropy Representation Efficiency (ERE) is a measure of how efficient a string ID represents the entropy of the ID itself. When referring to the entropy of an ID, we mean the Shannon Entropy of the character sequence, and that is maximal when all the permissible characters are equally likely to occur. In most random ID generators, this is the case, and the ERE is solely dependent on the count of characters in the charset, where each character represents log2(count) of entropy (a computer specific calc of general Shannon entropy). For example, for a hex charset there are 16 hex characters, so each character "carries" log2(16) = 4 bits of entropy in the string ID. We say the bits per character is 4 and a random ID of 12 hex characters has 48 bits of entropy.

ERE is measured as a ratio of the bits of entropy for the ID divided by the number of bits required to represent the string (8 bits per ID character). If each character is equally probable (the most common case), ERE is (bits-per-char * id_len) / (8 bits * id_len), which simplifies to bits-per-character/8. The BPC displayed in the Puid Characters table is equivalent to the ERE for that charset.

There is, however, a particular random ID exception where each character is not equally probable, namely, the often used v4 format of UUIDs. In that format, there are hyphens that carry no entropy (entropy is uncertainty, and there is no uncertainly as to where those hyphens will be), one hex digit that is actually constrained to 1 of only 4 hex values and another that is fixed. This formatting results in an ID of 36 characters with a total entropy of 122 bits. The ERE of a v4 UUID is, therefore, 122 / (8 * 36) = 0.4236.

## Entropy Transform Efficiency (ETE)

Entropy Transform Efficiency (ETE) is a measure of how efficiently source entropy is transformed into random ID entropy. For charsets with a character count that is a power of 2, all of the source entropy bits can be utilized during random ID generation. Each generated ID character requires exactly log2(count) bits, so the incoming source entropy can easily be carved into appropriate indices for character selection. Since ETE represents the ratio of output entropy bits to input entropy source, when all of the bits are utilized ETE is 1.0.

Even for charsets with power of 2 character count, ETE is only the theoretical maximum of 1.0 if the input entropy source is used as described above. Unfortunately, that is not the case with many random ID generation schemes. Some schemes use the entire output of a call to source entropy to create a single index used to select a character. Such schemes have very poor ETE.

For charsets with a character count that is not a power of 2, some bits will inevitably be discarded since the smallest number of bits required to select a character, ceil(log2(count)), will potentially result in an index beyond the character count. A first‑cut, naïve approach to this reality is to simply throw away all the bits when the index is too large.

However, a more sophisticated scheme of bit slicing can actually improve on the naïve approach. Puid extends the bit slicing scheme by adding a bit shifting scheme to the algorithm, wherein a minimum number of bits in the "over the limit" bits are discarded by observing that some bit patterns of length less than ceil(log2(count)) already guarantee the bits will be over the limit, and only those bits need be discarded.

As example, using the **.alphaNumLower** charset, which has 36 characters, **ceil(log2(36)) = 6** bits are required to create a suitable index. However, if those bits start with the bit pattern **11xxxx**, the index would be out of bounds regardless of the **xxxx** bits, so Puid only tosses the first two bits and keeps the trailing four bits for use in the next index. (It is beyond scope to discuss here, but analysis shows this bit shifting scheme does not alter the random characteristics of generated IDs). So whereas the naïve approach would have an ETE of **0.485**, Puid achieves an ETE of **0.646**, a **33%** improvement.

## Examples

```swift
import Puid

let safe = Puid.Chars.metrics(.safe64)
print(safe.avgBits)    // 6.0
print(safe.bitShifts)  // [BitShift(value: 63, shift: 6)]
print(safe.ere)        // 0.75
print(safe.ete)        // 1.0

let alpha = Puid.Chars.metrics(.alpha)
print(alpha.avgBits)   // > 6.0 (accounts for rare rejects)
print(alpha.bitShifts) // e.g., [BitShift(value: 51, shift: 6), ...]
print(alpha.ere)       // ~0.71 (5.7 / 8)
print(alpha.ete)       // < 1.0 (non power-of-two charset)
```

