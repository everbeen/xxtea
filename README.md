# XXTEA
Objective-C implementation of [XXTEA][wikipedia/xxtea] cipher for OS X and iOS.

[wikipedia/xxtea]: http://en.wikipedia.org/wiki/XXTEA

# Installation

Open project in Xcode then drag `XXTEA` directory (or `XXTEA.h` & `XXTEA.m`)
to your project directory (or any subdirectory).

Make sure '**Create groups**' in 'Added folders' is checked.

# Sample

```objective-c
#import "XXTEA.h"

// create a random key
unsigned char key[16];
XXTEAFillRandomKey(key);

// encrypt sample data
// output: length: 32/36
NSData *data = [@"Hello, world! 你好，世界！" dataUsingEncoding:NSUTF8StringEncoding];
NSData *encrypedData = XXTEAEncryptData(data, key);
NSLog(@"Length: %tu/%tu", data.length, encrypedData.length);

// decrypt data chunk
// output: Hello, world! 你好，世界！
data = XXTEADecryptData(encrypedData, key);
NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
```


# License
XXTEA is released under the MIT license. See LICENSE for details.
