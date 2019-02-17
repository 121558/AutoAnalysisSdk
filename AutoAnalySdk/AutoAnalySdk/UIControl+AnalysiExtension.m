//
//  UIControl+AnalysiExtension.m
//  AutoAnalySdk
//
//  Created by iOS on 19/2/17.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "UIControl+AnalysiExtension.h"
#import "MLHookHelper.h"
#import "AutoAnaly.h"

void swizzleControlAction();
@implementation UIControl (AnalysiExtension)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleControlAction();
    });
}

- (void)swiz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;
{
    NSLog(@"Current method: %@",NSStringFromSelector(_cmd));
    
    NSLog(@"%@", NSStringFromClass([self class]));
    
    NSLog(@"%@", self.superview);
    NSLog(@"%@", self.superclass);
    
    
    [self inject_sendAction:action to:target forEvent:event];
    [self swiz_sendAction:action to:target forEvent:event];
}

- (void)inject_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    //插入埋点代码
    NSLog(@"swizzleControlAction == %@== %@",[self class],self.eventKey);
    [self XC_GetViewControllerWithView:self];
    
    if (!([self.eventKey length]>0)) {
        return;
    }
    
    
    return;
}

@end

void swizzleControlAction() {
    
    __swizzle__([UIControl class], @selector(sendAction:to:forEvent:), @selector(swiz_sendAction:to:forEvent:));
}
