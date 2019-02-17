//
//  UITableView+AnalysiExtension.m
//  AutoAnalySdk
//
//  Created by iOS on 19/2/17.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "UITableView+AnalysiExtension.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation UITableView (AnalysiExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self startTracker];
    });
}
+ (void)startTracker {
    Method setDelegateMethod = class_getInstanceMethod(self, @selector(setDelegate:));
    Method ddSetDelegateMethod = class_getInstanceMethod(self, @selector(dd_setDelegate:));
    method_exchangeImplementations(setDelegateMethod, ddSetDelegateMethod);
}

- (void)dd_setDelegate:(id <UITableViewDelegate>)delegate {
    
    //只监听UITableView
    if (![self isMemberOfClass:[UITableView class]]) {
        return;
    }
    
    [self dd_setDelegate:delegate];
    
    if (delegate) {
        Class class = [delegate class];
        SEL originSelector = @selector(tableView:didSelectRowAtIndexPath:);
        SEL swizzlSelector = NSSelectorFromString(@"dd_didSelectRowAtIndexPath");
        BOOL didAddMethod = class_addMethod(class, swizzlSelector, (IMP)dd_didSelectRowAtIndexPath, "v@:@@");
        if (didAddMethod) {
            Method originMethod = class_getInstanceMethod(class, swizzlSelector);
            Method swizzlMethod = class_getInstanceMethod(class, originSelector);
            method_exchangeImplementations(originMethod, swizzlMethod);
        }
    }
}

void dd_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, NSIndexPath *indexpath) {
    SEL selector = NSSelectorFromString(@"dd_didSelectRowAtIndexPath");
    ((void(*)(id, SEL,id, NSIndexPath *))objc_msgSend)(self, selector, tableView, indexpath);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexpath];
    
    [cell XC_GetViewControllerWithView:cell];
    
    NSString *targetString = NSStringFromClass([self class]);
    NSString *actionString = NSStringFromSelector(_cmd);
    
    NSString *eventId = [NSString stringWithFormat:@"%@&&%@",targetString,actionString];
 
}

@end

