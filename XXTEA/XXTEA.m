//
//  XXTEA.m
//  XXTEA - https://github.com/everbeen/xxtea
//
//  Copyright (c) 2015 Eric
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <stdlib.h>
#import "XXTEA.h"

const size_t XXTEA_KEY_LENGTH = 16;

#define EVERBEEN_XXTEA_DELTA 0x9e3779b9
#define EVERBEEN_XXTEA_MX (((z>>5^y<<2) + (y>>3^z<<4)) ^ ((sum^y) + (k[(p&3)^e]^z)))

static void btea(uint32_t *v, int n, uint32_t const k[4]) {
	uint32_t y, z, sum;
	unsigned p, rounds, e;
	if (n > 1) {              /* Coding Part */
		rounds = 6 + 52/n;
		sum = 0;
		z = v[n-1];
		do {
			sum += EVERBEEN_XXTEA_DELTA;
			e = (sum >> 2) & 3;
			for (p=0; p<n-1; p++) {
				y = v[p+1];
				z = v[p] += EVERBEEN_XXTEA_MX;
			}
			y = v[0];
			z = v[n-1] += EVERBEEN_XXTEA_MX;
		} while (--rounds);
	} else if (n < -1) {      /* Decoding Part */
		n = -n;
		rounds = 6 + 52/n;
		sum = rounds*EVERBEEN_XXTEA_DELTA;
		y = v[0];
		do {
			e = (sum >> 2) & 3;
			for (p=n-1; p>0; p--) {
				z = v[p-1];
				y = v[p] -= EVERBEEN_XXTEA_MX;
			}
			z = v[n-1];
			y = v[0] -= EVERBEEN_XXTEA_MX;
		} while ((sum -= EVERBEEN_XXTEA_DELTA) != 0);
	}
}

#pragma mark -

NSData *XXTEAEncryptData(NSData *data, const void *key) {
	uint32_t data_length = (uint32_t)data.length;
	uint32_t len = (data_length + 4) >> 2;
	if ((data_length & 3) != 0) ++len;
	uint32_t bytes_len = len << 2;
	unsigned char *bytes = (unsigned char *)malloc(bytes_len);
	memcpy(bytes, data.bytes, data.length);
	memcpy(bytes+bytes_len-4, &data_length, 4);
	
	btea((uint32_t *)bytes, len, (uint32_t *)key);
	return [NSData dataWithBytesNoCopy:bytes length:bytes_len];
}

NSData *XXTEADecryptData(NSData *code, const void *key) {
	if ((code.length & 3) != 0)
		return nil;
	uint32_t bytes_len = (uint32_t)code.length;
	unsigned char *bytes = (unsigned char *)malloc(bytes_len);
	memcpy(bytes, code.bytes, bytes_len);
	btea((uint32_t *)bytes, (uint32_t)-(code.length>>2), (uint32_t *)key);
	uint32_t len = *(uint32_t *)(bytes+code.length-4);
	if (len > bytes_len) {
		free(bytes);
		return nil;
	}
	return [NSData dataWithBytesNoCopy:bytes length:len];
}


void XXTEAFillRandomKey(void *key) {
	arc4random_buf(key, XXTEA_KEY_LENGTH);
}
