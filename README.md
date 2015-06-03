# XXTEA
Objective-C implementation of [XXTEA][wikipedia/xxtea] cipher for OS X and iOS.

[wikipedia/xxtea]: http://en.wikipedia.org/wiki/XXTEA

## Installation

Open project in Xcode then drag `XXTEA` directory (or `XXTEA.h` & `XXTEA.m`)
to your project directory (or any subdirectory).

Make sure '**Create groups**' in 'Added folders' is checked.

## Usage

We create a string `sampleString` to demonstrate how to use xxtea.
xxtea works with `NSData` so,

```objective-c
NSString *sampleString = @"Hello, world! 你好，世界！";
NSData *data = [sampleString dataUsingEncoding:NSUTF8StringEncoding];
```

### Importing Header File

```objective-c
#import "XXTEA.h"
```

### Preparing Secret Key

Load your secret key (16-bytes memory block) into memory or generate a random one:

```objective-c
char key[XXTEA_KEY_LENGTH];
XXTEAFillRandomKey(key);
```

### Encrypting

```objective-c
NSData *encryptedData = XXTEAEncryptData(data, key);

// output: length: 32/36
NSLog(@"Length: %tu/%tu", data.length, encryptedData.length);
```


### Decrypting

```objective-c
NSData *originalData = XXTEADecryptData(encryptedData, key);

// output: Hello, world! 你好，世界！
NSString *originalString = [NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
NSLog(@"%@", originalString);
```


## License
XXTEA is released under the MIT license. See LICENSE for details.
