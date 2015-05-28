# XXTEA
Objective-C implementation of [XXTEA][wikipedia/xxtea] cipher for OS X and iOS.

[wikipedia/xxtea]: http://en.wikipedia.org/wiki/XXTEA

# Installation

Open project in Xcode then drag `XXTEA` directory (or `XXTEA.h` & `XXTEA.m`)
to your project directory (or any subdirectory).

Make sure '**Create groups**' in 'Added folders' is checked.

# Usage

```objective-c
#import "XXTEA.h"

NSString *sampleString = @"Hello, world! 你好，世界！";

// create a random key
char key[XXTEA_KEY_LENGTH];
XXTEAFillRandomKey(key);

// encrypt sample data
// output: length: 32/36
NSData *data = [sampleString dataUsingEncoding:NSUTF8StringEncoding];
NSData *encryptedData = XXTEAEncryptData(data, key);
NSLog(@"Length: %tu/%tu", data.length, encryptedData.length);

// decrypt data chunk
// output: Hello, world! 你好，世界！
data = XXTEADecryptData(encryptedData, key);
NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
```


# License
XXTEA is released under the MIT license. See LICENSE for details.
