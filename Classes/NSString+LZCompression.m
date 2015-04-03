//
// Created by Bob Wieler on 2/16/15.
//  Copyright (c) 2015 TapMesh, Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "NSString+LZCompression.h"

@interface Data : NSObject
@property(nonatomic, readwrite) unichar val;
@property(nonatomic, copy) NSString *string;
@property(nonatomic, readwrite) unichar position;
@property(nonatomic, readwrite) int index;
@end

@implementation Data
@end

@implementation NSString (LZCompression)

- (NSString *) compressLZ {
    int value;
    NSMutableDictionary *contextDictionary = [NSMutableDictionary dictionary];
    NSMutableSet *contextDictionaryToCreate = [NSMutableSet set];

    NSString *contextC;
    NSString *contextWC;
    NSString *contextW = @"";
    int contextEnlargeIn = 2; // Compensate for the first entry which should not count
    int contextDictSize = 3;
    int contextNumBits = 2;
    NSMutableString *contextDataString = [NSMutableString stringWithString:@""];
    unichar contextDataVal = 0;
    int contextDataPosition = 0;

    for (NSUInteger ii = 0; ii < self.length; ii += 1) {
        contextC = [NSString stringWithFormat:@"%C", [self characterAtIndex:ii]];
        if (![contextDictionary.allKeys containsObject:contextC]) {
            contextDictionary[contextC] = @(contextDictSize++);
            [contextDictionaryToCreate addObject:contextC];
        }

        contextWC = [NSString stringWithFormat:@"%@%@", contextW, contextC];

        if ([contextDictionary.allKeys containsObject:contextWC]) {
            contextW = contextWC;
        }
        else {
            if ([contextDictionaryToCreate containsObject:contextW]) {
                if ((int)[contextW characterAtIndex:0] < 256) {
                    for (int i = 0; i < contextNumBits; i++) {
                        contextDataVal = (contextDataVal << 1);
                        if (contextDataPosition == 15) {
                            contextDataPosition = 0;
                            [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
                            contextDataVal = 0;
                        }
                        else {
                            contextDataPosition++;
                        }
                    }
                    value = [contextW characterAtIndex:0];
                    for (int i = 0; i < 8; i++) {
                        contextDataVal = (unichar)((contextDataVal << 1) | (value & 1));
                        if (contextDataPosition == 15) {
                            contextDataPosition = 0;
                            [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
                            contextDataVal = 0;
                        }
                        else {
                            contextDataPosition++;
                        }
                        value = value >> 1;
                    }
                }
                else {
                    value = 1;
                    for (int i = 0; i < contextNumBits; i++) {
                        contextDataVal = (unichar)((contextDataVal << 1) | value);
                        if (contextDataPosition == 15) {
                            contextDataPosition = 0;
                            [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
                            contextDataVal = 0;
                        }
                        else {
                            contextDataPosition++;
                        }
                        value = 0;
                    }
                    value = (int)[contextW characterAtIndex:0];
                    for (int i = 0; i < 16; i++) {
                        contextDataVal = (unichar)((contextDataVal << 1) | (value & 1));
                        if (contextDataPosition == 15) {
                            contextDataPosition = 0;
                            [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
                            contextDataVal = 0;
                        }
                        else {
                            contextDataPosition++;
                        }
                        value = value >> 1;
                    }
                }
                contextEnlargeIn--;
                if (contextEnlargeIn == 0) {
                    contextEnlargeIn = 1 << contextNumBits;
                    contextNumBits++;
                }
                [contextDictionaryToCreate removeObject:contextW];
            }
            else {
                value = [contextDictionary[contextW] intValue];
                for (int i = 0; i < contextNumBits; i++) {
                    contextDataVal = (unichar)((contextDataVal << 1) | (value & 1));
                    if (contextDataPosition == 15) {
                        contextDataPosition = 0;
                        [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
                        contextDataVal = 0;
                    }
                    else {
                        contextDataPosition++;
                    }
                    value = value >> 1;
                }
            }
            contextEnlargeIn--;
            if (contextEnlargeIn == 0) {
                contextEnlargeIn = 1 << contextNumBits;
                contextNumBits++;
            }
            // Add wc to the dictionary.
            contextDictionary[contextWC] = @(contextDictSize++);
            contextW = contextC;
        }
    }

    // Output the code for w.
    if (![contextW isEqualToString:@""]) {
        if ([contextDictionaryToCreate containsObject:contextW]) {
            if ((int)[contextW characterAtIndex:0] < 256) {
                for (int i = 0; i < contextNumBits; i++) {
                    contextDataVal = (contextDataVal << 1);
                    if (contextDataPosition == 15) {
                        contextDataPosition = 0;
                        [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
                        contextDataVal = 0;
                    }
                    else {
                        contextDataPosition++;
                    }
                }
                value = [contextW characterAtIndex:0];
                for (int i = 0; i < 8; i++) {
                    contextDataVal = (unichar)((contextDataVal << 1) | (value & 1));
                    if (contextDataPosition == 15) {
                        contextDataPosition = 0;
                        [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
                        contextDataVal = 0;
                    }
                    else {
                        contextDataPosition++;
                    }
                    value = value >> 1;
                }
            }
            else {
                value = 1;
                for (int i = 0; i < contextNumBits; i++) {
                    contextDataVal = (unichar)((contextDataVal << 1) | value);
                    if (contextDataPosition == 15) {
                        contextDataPosition = 0;
                        [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
                        contextDataVal = 0;
                    }
                    else {
                        contextDataPosition++;
                    }
                    value = 0;
                }
                value = [contextW characterAtIndex:0];
                for (int i = 0; i < 16; i++) {
                    contextDataVal = (unichar)((contextDataVal << 1) | (value & 1));
                    if (contextDataPosition == 15) {
                        contextDataPosition = 0;
                        [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
                        contextDataVal = 0;
                    }
                    else {
                        contextDataPosition++;
                    }
                    value = value >> 1;
                }
            }
            contextEnlargeIn--;
            if (contextEnlargeIn == 0) {
                contextEnlargeIn = 1 << contextNumBits;
                contextNumBits++;
            }
            [contextDictionaryToCreate removeObject:contextW];
        }
        else {
            value = [contextDictionary[contextW] intValue];
            for (int i = 0; i < contextNumBits; i++) {
                contextDataVal = (unichar)((contextDataVal << 1) | (value & 1));
                if (contextDataPosition == 15) {
                    contextDataPosition = 0;
                    [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
                    contextDataVal = 0;
                }
                else {
                    contextDataPosition++;
                }
                value = value >> 1;
            }
        }

        contextEnlargeIn--;
        if (contextEnlargeIn == 0) {
            contextNumBits++;
        }
    }

    // Mark the end of the stream
    value = 2;
    for (int i = 0; i < contextNumBits; i++) {
        contextDataVal = (unichar)((contextDataVal << 1) | (value & 1));
        if (contextDataPosition == 15) {
            contextDataPosition = 0;
            [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
            contextDataVal = 0;
        }
        else {
            contextDataPosition++;
        }
        value = value >> 1;
    }

    // Flush the last char
    while (true) {
        contextDataVal = (contextDataVal << 1);
        if (contextDataPosition == 15) {
            [contextDataString appendString:[NSString stringWithCharacters:&contextDataVal length:1]];
            break;
        }
        else {
            contextDataPosition++;
        }
    }

    return contextDataString;
}

- (NSString *) compressLZToUTF16 {
    NSMutableString *output = [NSMutableString stringWithString:@""];
    int c;
    int current = 0;
    int status = 0;
    unichar value;

    NSString *input = [self compressLZ];

    for (NSUInteger i = 0; i < input.length; i++) {
        c = (int)[input characterAtIndex:i];
        switch (status) {
            case 0:
                value = (unichar)((c >> 1) + 32);
                [output appendString:[NSString stringWithCharacters:&value length:1]];
                current = (c & 1) << 14;
                status++;
                break;
            case 14:
                value = (unichar)((current + (c >> 15)) + 32);
                [output appendString:[NSString stringWithCharacters:&value length:1]];
                value = (unichar)((c & 32767) + 32);
                [output appendString:[NSString stringWithCharacters:&value length:1]];
                status = 0;
                break;
            default:
                value = (unichar)((current + (c >> (status + 1))) + 32);
                [output appendString:[NSString stringWithCharacters:&value length:1]];
                current = (c & ((2 << status) - 1)) << (14 - status);
                status++;
                break;
        }
    }
    value = (unichar)(current + 32);
    [output appendString:[NSString stringWithCharacters:&value length:1]];

    return output;
}

- (int) readBit:(Data *)data {
    int res = data.val & data.position;
    data.position >>= 1;
    if (data.position == 0) {
        data.position = 32768;
        data.val = (unichar)[data.string characterAtIndex:(NSUInteger)data.index++];
    }
    return (res > 0 ? 1 : 0);
}

- (unichar) readBits:(int)numBits fromData:(Data *)data {
    int res = 0;
    int maxPower = 1 << numBits;
    int power = 1;
    while (power != maxPower) {
        res |= [self readBit:data] * power;
        power <<= 1;
    }

    return (unichar)res;
}

- (NSString *) decompressLZ {
    if ([self isEqualToString:@""])
        return nil;

    NSMutableArray *dictionary = [NSMutableArray arrayWithCapacity:200];
    int next;
    int enlargeIn = 4;
    int dictSize = 4;
    int numBits = 3;
    NSString *entry;
    NSMutableString *result;
    NSString *w;
    NSString *c;
    unichar v;
    int d = 0;
    Data *data = [[Data alloc] init];
    data.string = self;
    data.val = (unichar)[self characterAtIndex:0];
    data.position = 32768;
    data.index = 1;

    for (int i = 0; i < 3; i += 1) {
        [dictionary addObject:[NSString stringWithFormat:@"%d", i]];
    }

    next = [self readBits:2 fromData:data];
    switch (next) {
        case 0:
            v = [self readBits:8 fromData:data];
            c = [NSString stringWithCharacters:&v length:1];
            break;
        case 1:
            v = [self readBits:16 fromData:data];
            c = [NSString stringWithCharacters:&v length:1];
            break;
        case 2:
            return @"";
        default:
            break;
    }

    [dictionary addObject:c];
    w = c;
    result = [c mutableCopy];

    while (true) {
        v = [self readBits:numBits fromData:data];
        d = v;
        switch (v) {
            case 0:
                v = [self readBits:8 fromData:data];

                [dictionary addObject:[NSString stringWithCharacters:&v length:1]];
                dictSize++;
                d = dictSize - 1;
                enlargeIn--;

                break;
            case 1:
                v = [self readBits:16 fromData:data];

                [dictionary addObject:[NSString stringWithCharacters:&v length:1]];
                dictSize++;
                d = dictSize - 1;
                enlargeIn--;

                break;
            case 2:
                return result;
            default:
                break;
        }

        if (enlargeIn == 0) {
            enlargeIn = 1 << numBits;
            numBits++;
        }

        if (d < dictSize && dictionary[(NSUInteger)d] && ![dictionary[(NSUInteger)d] isEqualToString:@""]) {
            entry = dictionary[(NSUInteger)d];
        } else {
            if (d == dictSize) {
                entry = [NSString stringWithFormat:@"%@%C", w, (unichar)[w characterAtIndex:0]];
            } else {
                return nil;
            }
        }
        [result appendString:entry];

        // Add w+entry[0] to the dictionary.
        [dictionary addObject:[NSString stringWithFormat:@"%@%C", w, (unichar)[entry characterAtIndex:0]]];
        dictSize++;
        enlargeIn--;

        w = entry;

        if (enlargeIn == 0) {
            enlargeIn = 1 << numBits;
            numBits++;
        }
    }
}

- (NSString *) decompressLZFromUTF16 {
    if (self == nil)
        return @"";

    NSMutableString *output = [NSMutableString stringWithCapacity:self.length];
    unsigned short c;
    int current = 0, i = 0;

    while (i < self.length) {

        c = (unsigned short)(([self characterAtIndex:i]) - 32);
        if ((i & 15) != 0) {
            unichar ch = (unichar)(current | (c >> (15 - (i & 15))));
            [output appendString:[NSString stringWithCharacters:&ch length:1]];
        }
        current = (c & ((1 << (15 - (i & 15))) - 1)) << ((i + 1) & 15);

        i++;
    }

    return [output decompressLZ];
}

@end