//
//  OCAesBridge.m
//  AES_GUI
//
//  Created by 李文坤 on 2017/6/3.
//  Copyright © 2017年 李文坤. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OCAesBridge.h"
#import "aes.hpp"


@implementation OCAesBridge

+ (void)encrypt: (NSString*)inputFilePath :(NSString*)outputFilePath :(NSString*)hex_key {
    aes().aes_encrypt([inputFilePath UTF8String], [outputFilePath UTF8String], [hex_key UTF8String]);
}

+ (void)decrypt: (NSString*)inputFilePath :(NSString*)outputFilePath :(NSString*)hex_key {
    aes().aes_decrypt([inputFilePath UTF8String], [outputFilePath UTF8String], [hex_key UTF8String]);
}

@end
