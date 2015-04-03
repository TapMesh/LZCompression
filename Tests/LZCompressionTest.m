//
// Created by Bob Wieler on 3/26/15.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+LZCompression.h"

@interface LZCompressionTest : XCTestCase

@end

@implementation LZCompressionTest

- (void)testBasicCompression {
    NSString *input = @"Test of a short string";
    NSString *lzCompressedInput = [input compressLZ];

    NSString *output = [lzCompressedInput decompressLZ];
    XCTAssert([input isEqualToString:output], @"Input should equal output");
    XCTAssert(lzCompressedInput.length < input.length, @"Compressed length should be less then uncompressed");
}

- (void)testEmptyCompression {
    NSString *input = @"";
    NSString *lzCompressedInput = [input compressLZ];

    NSString *output = [lzCompressedInput decompressLZ];
    XCTAssert([input isEqualToString:output], @"Input should equal output");
}

- (void)testLongCompression {
    NSString *input = @"Test of a long string with a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated stuff which should compress quite nicely given the lof of repeated a lot of repeated a lot of repeated stuff.";
    NSString *lzCompressedInput = [input compressLZ];

    NSString *output = [lzCompressedInput decompressLZ];
    XCTAssert([input isEqualToString:output], @"Input should equal output");
    XCTAssert(lzCompressedInput.length < input.length, @"Compressed length should be less then uncompressed");
}

- (void)testJSONCompression {
    NSString *input = @"{\"pendingUpdates\":false,\"cachedMessageCounter\":10,\"members\":{\"smith\":\"John Smith\",\"bobwieler\":\"Bobby Wieler\"},\"lastMessageTime\":\"2015-03-23T11:07:52.189-0400\",\"lastNotification\":\"Bobby Wieler: As well. \",\"eventCount\":0,\"temporaryMembers\":[],\"pushNotifications\":true,\"mojo\":\"CE7F16CE-0002-4838-A453-D677C4F33251\",\"temporaryCards\":[],\"messageCounter\":10,\"membersData\":{\"smith\":{\"firstName\":\"John\",\"name\":\"John Smith\",\"lastName\":\"Smith\"},\"bobwieler\":{\"firstName\":\"Bobby\",\"name\":\"Bobby Wieler\",\"lastName\":\"Wieler\"}},\"cards\":[]}";
    NSString *lzCompressedInput = [input compressLZ];

    NSString *output = [lzCompressedInput decompressLZ];
    XCTAssert([input isEqualToString:output], @"Input should equal output");
    XCTAssert(lzCompressedInput.length < input.length, @"Compressed length should be less then uncompressed");
}

- (void)testBasicUTF16Compression {
    NSString *input = @"Test of a short string";
    NSString *lzCompressedInput = [input compressLZToUTF16];

    NSString *output = [lzCompressedInput decompressLZFromUTF16];
    XCTAssert([input isEqualToString:output], @"Input should equal output");
    XCTAssert(lzCompressedInput.length < input.length, @"Compressed length should be less then uncompressed");
}

- (void)testLongUTF16Compression {
    NSString *input = @"Test of a long string with a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated a lot of repeated stuff which should compress quite nicely given the lof of repeated a lot of repeated a lot of repeated stuff.";
    NSString *lzCompressedInput = [input compressLZToUTF16];

    NSString *output = [lzCompressedInput decompressLZFromUTF16];
    XCTAssert([input isEqualToString:output], @"Input should equal output");
    XCTAssert(lzCompressedInput.length < input.length, @"Compressed length should be less then uncompressed");
}

- (void)testJSONUTF16Compression {
    NSString *input = @"{\"pendingUpdates\":false,\"cachedMessageCounter\":10,\"members\":{\"smith\":\"John Smith\",\"bobwieler\":\"Bobby Wieler\"},\"lastMessageTime\":\"2015-03-23T11:07:52.189-0400\",\"lastNotification\":\"Bobby Wieler: As well. \",\"eventCount\":0,\"temporaryMembers\":[],\"pushNotifications\":true,\"mojo\":\"CE7F16CE-0002-4838-A453-D677C4F33251\",\"temporaryCards\":[],\"messageCounter\":10,\"membersData\":{\"smith\":{\"firstName\":\"John\",\"name\":\"John Smith\",\"lastName\":\"Smith\"},\"bobwieler\":{\"firstName\":\"Bobby\",\"name\":\"Bobby Wieler\",\"lastName\":\"Wieler\"}},\"cards\":[]}";
    NSString *lzCompressedInput = [input compressLZToUTF16];

    NSString *output = [lzCompressedInput decompressLZFromUTF16];
    XCTAssert([input isEqualToString:output], @"Input should equal output");
    XCTAssert(lzCompressedInput.length < input.length, @"Compressed length should be less then uncompressed");
}

- (void)testCompressionSpeed {
    NSUInteger iterations = 500;
    NSDate *start = [NSDate date];
    for (NSUInteger i = 0; i < iterations; i++) {
        NSString *input = @"{\"pendingUpdates\":false,\"cachedMessageCounter\":10,\"members\":{\"smith\":\"John Smith\",\"bobwieler\":\"Bobby Wieler\"},\"lastMessageTime\":\"2015-03-23T11:07:52.189-0400\",\"lastNotification\":\"Bobby Wieler: As well. \",\"eventCount\":0,\"temporaryMembers\":[],\"pushNotifications\":true,\"mojo\":\"CE7F16CE-0002-4838-A453-D677C4F33251\",\"temporaryCards\":[],\"messageCounter\":10,\"membersData\":{\"smith\":{\"firstName\":\"John\",\"name\":\"John Smith\",\"lastName\":\"Smith\"},\"bobwieler\":{\"firstName\":\"Bobby\",\"name\":\"Bobby Wieler\",\"lastName\":\"Wieler\"}},\"cards\":[]}";
        [input compressLZ];
    }
    NSTimeInterval timeTaken = fabs([start timeIntervalSinceNow]);
    NSLog(@"Time to process %lu compressions: %fs (average %.2fms/compression)", (unsigned long)iterations, timeTaken, timeTaken/iterations * 1000);
}

- (void)testUTF16CompressionSpeed {
    NSUInteger iterations = 500;
    NSDate *start = [NSDate date];
    for (NSUInteger i = 0; i < iterations; i++) {
        NSString *input = @"{\"pendingUpdates\":false,\"cachedMessageCounter\":10,\"members\":{\"smith\":\"John Smith\",\"bobwieler\":\"Bobby Wieler\"},\"lastMessageTime\":\"2015-03-23T11:07:52.189-0400\",\"lastNotification\":\"Bobby Wieler: As well. \",\"eventCount\":0,\"temporaryMembers\":[],\"pushNotifications\":true,\"mojo\":\"CE7F16CE-0002-4838-A453-D677C4F33251\",\"temporaryCards\":[],\"messageCounter\":10,\"membersData\":{\"smith\":{\"firstName\":\"John\",\"name\":\"John Smith\",\"lastName\":\"Smith\"},\"bobwieler\":{\"firstName\":\"Bobby\",\"name\":\"Bobby Wieler\",\"lastName\":\"Wieler\"}},\"cards\":[]}";
        [input compressLZToUTF16];
    }
    NSTimeInterval timeTaken = fabs([start timeIntervalSinceNow]);
    NSLog(@"Time to process %lu UTF16 compressions: %fs (average %.2fms/compression)", (unsigned long)iterations, timeTaken, timeTaken/iterations * 1000);
}

- (void)testDecompressionSpeed {
    NSUInteger iterations = 500;
    NSString *input = @"{\"pendingUpdates\":false,\"cachedMessageCounter\":10,\"members\":{\"smith\":\"John Smith\",\"bobwieler\":\"Bobby Wieler\"},\"lastMessageTime\":\"2015-03-23T11:07:52.189-0400\",\"lastNotification\":\"Bobby Wieler: As well. \",\"eventCount\":0,\"temporaryMembers\":[],\"pushNotifications\":true,\"mojo\":\"CE7F16CE-0002-4838-A453-D677C4F33251\",\"temporaryCards\":[],\"messageCounter\":10,\"membersData\":{\"smith\":{\"firstName\":\"John\",\"name\":\"John Smith\",\"lastName\":\"Smith\"},\"bobwieler\":{\"firstName\":\"Bobby\",\"name\":\"Bobby Wieler\",\"lastName\":\"Wieler\"}},\"cards\":[]}";
    NSString *lzCompressedInput = [input compressLZ];

    NSDate *start = [NSDate date];
    for (NSUInteger i = 0; i < iterations; i++) {
        [lzCompressedInput decompressLZ];
    }
    NSTimeInterval timeTaken = fabs([start timeIntervalSinceNow]);
    NSLog(@"Time to process %lu decompressions: %fs (average %.2fms/decompression)", (unsigned long)iterations, timeTaken, timeTaken/iterations * 1000);
}

- (void)testUTF16DecompressionSpeed {
    NSUInteger iterations = 500;
    NSString *input = @"{\"pendingUpdates\":false,\"cachedMessageCounter\":10,\"members\":{\"smith\":\"John Smith\",\"bobwieler\":\"Bobby Wieler\"},\"lastMessageTime\":\"2015-03-23T11:07:52.189-0400\",\"lastNotification\":\"Bobby Wieler: As well. \",\"eventCount\":0,\"temporaryMembers\":[],\"pushNotifications\":true,\"mojo\":\"CE7F16CE-0002-4838-A453-D677C4F33251\",\"temporaryCards\":[],\"messageCounter\":10,\"membersData\":{\"smith\":{\"firstName\":\"John\",\"name\":\"John Smith\",\"lastName\":\"Smith\"},\"bobwieler\":{\"firstName\":\"Bobby\",\"name\":\"Bobby Wieler\",\"lastName\":\"Wieler\"}},\"cards\":[]}";
    NSString *lzCompressedInput = [input compressLZToUTF16];

    NSDate *start = [NSDate date];
    for (NSUInteger i = 0; i < iterations; i++) {
        [lzCompressedInput decompressLZFromUTF16];
    }
    NSTimeInterval timeTaken = fabs([start timeIntervalSinceNow]);
    NSLog(@"Time to process %lu UTF16 decompressions: %fs (average %.2fms/decompression)", (unsigned long)iterations, timeTaken, timeTaken/iterations * 1000);
}

@end