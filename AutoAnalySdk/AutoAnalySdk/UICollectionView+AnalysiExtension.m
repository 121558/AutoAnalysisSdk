//
//  UICollectionView+AnalysiExtension.m
//  AutoAnalySdk
//
//  Created by iOS on 19/2/17.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "UICollectionView+AnalysiExtension.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+ObjectExtention.h"
@implementation UICollectionView (AnalysiExtension)
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

- (void)dd_setDelegate:(id <UICollectionViewDelegate>)delegate {
    
    //只监听UICollectionView
    if (![self isMemberOfClass:[UICollectionView class]]) {
        return;
    }
    
    [self dd_setDelegate:delegate];
    if (delegate) {
        Class class = [delegate class];
        SEL originSelector = @selector(collectionView:didSelectItemAtIndexPath:);
        SEL swizzlSelector = NSSelectorFromString(@"dd_didSelectItemAtIndexPath");
        BOOL didAddMethod = class_addMethod(class, swizzlSelector, (IMP)dd_didSelectItemAtIndexPath, "v@:@@");
        if (didAddMethod) {
            Method originMethod = class_getInstanceMethod(class, swizzlSelector);
            Method swizzlMethod = class_getInstanceMethod(class, originSelector);
            method_exchangeImplementations(originMethod, swizzlMethod);
        }
    }
}

void dd_didSelectItemAtIndexPath(id self, SEL _cmd, id collectionView, NSIndexPath *indexpath) {
    SEL selector = NSSelectorFromString(@"dd_didSelectItemAtIndexPath");
    ((void(*)(id, SEL,id, NSIndexPath *))objc_msgSend)(self, selector, collectionView, indexpath);
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexpath];
    [cell XC_GetViewControllerWithView:cell];
    
    NSString *targetString = NSStringFromClass([self class]);
    NSString *actionString = NSStringFromSelector(_cmd);
    
    NSString *eventId = [NSString stringWithFormat:@"%@&&%@",targetString,actionString];
   
}


@end
