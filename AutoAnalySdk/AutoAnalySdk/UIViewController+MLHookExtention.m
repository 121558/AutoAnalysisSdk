//
//  UIViewController+MLHookExtention.m
//  AutoAnalySdk
//
//  Created by iOS on 19/2/17.
//  Copyright © 2019年 iOS. All rights reserved.
//


#import "UIViewController+MLHookExtention.h"
#import "MLHookHelper.h"
#import "AutoAnaly.h"
#import <objc/runtime.h>
#import "NSDate+MLHelper.h"


void swizzleViewControllerAction();

@implementation UIViewController (MLHookExtention)
//所有的方法都会走这里
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleViewControllerAction();
    });
}


#pragma mark - Method Swizzling

- (void)swiz_viewWillAppear:(BOOL)animated
{
    //插入需要执行的代码
    NSLog(@"页面出现");
    [self inject_viewWillAppear];
    [self swiz_viewWillAppear:animated];
}

- (void)swiz_viewWillDisappear:(BOOL)animated
{
    
    NSLog(@"页面消失");

    [self inject_viewWillDisappear];
    [self swiz_viewWillDisappear:animated];
}

//利用hook 统计所有页面的停留时长
- (void)inject_viewWillAppear {
    NSLog(@"%@", NSStringFromClass([self class]));
    
    self.enterDate = [NSDate currentTime];
}

- (void)inject_viewWillDisappear {
    
}

#pragma setter && Getter

- (long long)enterDate {
    return [objc_getAssociatedObject(self, _cmd) longLongValue];
}

- (void)setEnterDate:(long long)enterDate {
    
    objc_setAssociatedObject(self, @selector(enterDate), [NSNumber numberWithLongLong:enterDate], OBJC_ASSOCIATION_ASSIGN);
}

- (long long)leaveDate {
    return [objc_getAssociatedObject(self, _cmd) longLongValue];
}

- (void)setLeaveDate:(long long)leaveDate {
    
    objc_setAssociatedObject(self, @selector(leaveDate), [NSNumber numberWithLongLong:leaveDate], OBJC_ASSOCIATION_ASSIGN);
}



@end

void swizzleViewControllerAction() {
    __swizzle__([UIViewController class], @selector(viewWillAppear:), @selector(swiz_viewWillAppear:));
    __swizzle__([UIViewController class], @selector(viewWillDisappear:), @selector(swiz_viewWillDisappear:));
}
