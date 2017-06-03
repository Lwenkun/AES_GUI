//
//  OCAesBridge.h
//  AES_GUI
//
//  Created by 李文坤 on 2017/6/3.
//  Copyright © 2017年 李文坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCAesBridge : NSObject

+ (void)encrypt: (NSString*)inputFilePath :(NSString*)outputFilePath :(NSString*)hex_key;
+ (void)decrypt: (NSString*)inputFilePath :(NSString*)outputFilePath :(NSString*)hex_key;

@end
