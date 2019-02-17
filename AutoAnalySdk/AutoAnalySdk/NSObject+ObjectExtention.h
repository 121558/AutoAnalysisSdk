//
//  NSObject+ObjectExtention.h
//  AutoAnalySdk
//
//  Created by iOS on 19/2/17.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (ObjectExtention)<UIScrollViewDelegate>

@property(nonatomic, copy) NSString *eventKey;

- (UIViewController *)XC_GetViewControllerWithView:(UIView *)view;

@end

