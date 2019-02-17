//
//  UITextField+AnalysiExtension.m
//  AutoAnalySdk
//
//  Created by iOS on 19/2/17.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "UITextField+AnalysiExtension.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+ObjectExtention.h"
@implementation UITextField (AnalysiExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self startTracker];
    });
}

+ (void)startTracker {
    
    //textFieldDidEndEditing:(UITextField *)textField
    Method addtextMethod = class_getInstanceMethod(self, @selector(setDelegate:));
    Method ddAddtextMethod = class_getInstanceMethod(self, @selector(dd_addtextFielddd_setDelegate:));
    method_exchangeImplementations(addtextMethod, ddAddtextMethod);
    
}
//- (void)dd_setDelegate:(id <UITableViewDelegate>)delegate {

- (void)dd_addtextFielddd_setDelegate:(id <UITextFieldDelegate>)delegate {
    
    
    [self dd_addtextFielddd_setDelegate:delegate];
    
    //- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    if (delegate) {
        Class class = [delegate class];
        SEL originSelector = @selector(textFieldDidEndEditing:);
        SEL swizzlSelector =NSSelectorFromString(@"dd_addtextFielddd_textFieldDidEndEditing")  ;
        BOOL didAddMethod = class_addMethod(class, swizzlSelector, (IMP)dd_addtextFielddd_textFieldDidEndEditing, "v@:@@");
        if (didAddMethod) {
            
            Method originMethod = class_getInstanceMethod(class, swizzlSelector);
            Method swizzlMethod = class_getInstanceMethod(class, originSelector);
            method_exchangeImplementations(originMethod, swizzlMethod);
        }
    }
    
    
    
}

void dd_addtextFielddd_textFieldDidEndEditing(id self, SEL _cmd,  UITextField *textField) {
    
    [textField XC_GetViewControllerWithView:textField];
    
    NSLog(@"textField---------------%@",textField.text);
    
}

/*
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
 NSDictionary *infoDictionary = [cell ddInfoDictionary];
 
 [[DDAutoTrackerOperation sharedInstance] sendTrackerData:eventId
 info:infoDictionary];
 }
 */
@end

