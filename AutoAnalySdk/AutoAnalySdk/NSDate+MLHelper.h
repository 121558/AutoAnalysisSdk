//
//  NSDate+MLHelper.h
//  AutoAnalySdk
//
//  Created by iOS on 19/2/17.
//  Copyright © 2019年 iOS. All rights reserved.
//


#import <Foundation/Foundation.h>

#define kDateStyle0     @"yyyy-MM-dd HH:mm:ss"

@interface NSDate (MLHelper)

- (NSString *)toDateStyle:(NSString *)dateStyle;


+ (long long)currentTime;

- (long long)timeStamp;

@end
