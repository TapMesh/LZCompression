# LZCompression
An Objective-C implementation of lz-string for Javascript [http://pieroxy.net/blog/pages/lz-string/index.html](http://pieroxy.net/blog/pages/lz-string/index.html)

# Installation
## Cocoapods

```
pod 'LZCompression'
```

## Manual Installation

Add the NZString+LZCompression.h and NZString+LZCompression.m files to your project to use the new LZCompression category on NSString.

# Usage

Text can be compressed to UTF16 only characters by using the compressLZToUTF16 method instead of the regular compressLZ method.

```
NSString *input = @"String that should be compressed";
NSString *lzCompressedInput = [input compressLZ];
NSString *lzCompressedInputBase64Coded = [input compressToBase64];
NSString *lzCompressedUTF16Input = [input compressLZToUTF16];

NSString *output = [lzCompressedInput decompressLZ];
NSString *outputFromCompressedBase64 = [lzCompressedInputBase64Coded decompressFromBase64];
NSString *outputFromUTF16 = [lzCompressedUTF16Input decompressLZFromUTF16];
```

## Credits

A big thanks to [Saumitra Bhave](https://github.com/saumitrabhave) for implementing additional functionality from the original implementation.