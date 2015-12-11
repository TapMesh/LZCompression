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

#import <Foundation/Foundation.h>

@interface NSString (LZCompression)

- (NSString *) compressLZ;
- (NSString *) compressLZToUTF16;
- (NSString *) compressToBase64;

- (NSString *) decompressLZ;
- (NSString *) decompressLZFromUTF16;
- (NSString *) decompressFromBase64;

@end