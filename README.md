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
NSString *lzCompressedUTF16Input = [input compressLZToUTF16];

NSString *output = [lzCompressedInput decompressLZ];
NSString *outputFromUTF16 = [lzCompressedUTF16Input decompressLZFromUTF16];
```