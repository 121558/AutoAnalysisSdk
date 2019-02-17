//
//  UIScrollView+AnalysiExtension.m
//  AutoAnalySdk
//
//  Created by iOS on 19/2/17.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "UIScrollView+AnalysiExtension.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+ObjectExtention.h"
@implementation UIScrollView (AnalysiExtension)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self startTracker];
    });
}

+ (void)startTracker {
    
    
    //textFieldDidEndEditing:(UITextField *)textField
    Method addtextMethod = class_getInstanceMethod(self, @selector(setDelegate:));
    Method ddAddtextMethod = class_getInstanceMethod(self, @selector(dd_addScrollviewdd_setDelegate:));
    method_exchangeImplementations(addtextMethod, ddAddtextMethod);
    
}
//- (void)dd_setDelegate:(id <UITableViewDelegate>)delegate {

- (void)dd_addScrollviewdd_setDelegate:(id <UIScrollViewDelegate>)delegate {
    
    
    [self dd_addScrollviewdd_setDelegate:delegate];
    
    //- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //    - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
    
    if (delegate) {
        Class class = [delegate class];
        SEL originSelector = @selector(scrollViewDidEndDecelerating:);
        SEL swizzlSelector =NSSelectorFromString(@"dd_addscrollViewDidEndDecelerating")  ;
        BOOL didAddMethod = class_addMethod(class, swizzlSelector, (IMP)dd_addscrollViewDidEndDecelerating, "v@:@@");
        if (didAddMethod) {
            
            Method originMethod = class_getInstanceMethod(class, swizzlSelector);
            Method swizzlMethod = class_getInstanceMethod(class, originSelector);
            method_exchangeImplementations(originMethod, swizzlMethod);
        }
    }
    
    if (delegate) {
        Class class = [delegate class];
        SEL originSelector = @selector(scrollViewDidEndDragging: willDecelerate:);
        SEL swizzlSelector =NSSelectorFromString(@"dd_addscrollViewDidEndDeceleratingdrag")  ;
        BOOL didAddMethod = class_addMethod(class, swizzlSelector, (IMP)dd_addscrollViewDidEndDeceleratingdrag, "v@:@@@@@");
        if (didAddMethod) {
            
            Method originMethod = class_getInstanceMethod(class, swizzlSelector);
            Method swizzlMethod = class_getInstanceMethod(class, originSelector);
            method_exchangeImplementations(originMethod, swizzlMethod);
        }
    }
    
    
    
    
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

void dd_addscrollViewDidEndDecelerating(id self, SEL _cmd,  id scrollView) {
    
    //下面两句使其继续执行原来的方法
    SEL selector = NSSelectorFromString(@"dd_addscrollViewDidEndDecelerating");
    ((void(*)(id, SEL, UIScrollView *))objc_msgSend)(self, selector, scrollView);
    
    [scrollView XC_GetViewControllerWithView:scrollView];
    
    //判断是否为UITableView或者UICollectionView
    if([scrollView isKindOfClass:[UITableView class]]){
        
        //获取处于UITableView中心的cell
        //系统方法返回处于tableView某坐标处的cell的indexPath
        NSIndexPath * topIndexPath = [(UITableView *)scrollView  indexPathForRowAtPoint:CGPointMake(0, ((UITableView *)scrollView).contentOffset.y)];
        NSIndexPath * middleIndexPath = [ ((UITableView *)scrollView)  indexPathForRowAtPoint:CGPointMake(0,  ((UITableView *)scrollView).contentOffset.y +  ((UITableView *)scrollView).frame.size.height/2)];
        
        NSIndexPath * botmIndexPath = [ ((UITableView *)scrollView)  indexPathForRowAtPoint:CGPointMake(0,  ((UITableView *)scrollView).contentOffset.y +  ((UITableView *)scrollView).frame.size.height)];
        
        NSLog(@"top的cell：第 %ld 组 %ld个",topIndexPath.section, topIndexPath.row);
        NSLog(@"中间的cell：第 %ld 组 %ld个",middleIndexPath.section, middleIndexPath.row);
        NSLog(@"底部的cell：第 %ld 组 %ld个",botmIndexPath.section, botmIndexPath.row);
        
        UITableViewCell * cell = (UITableViewCell *)[(UITableView *)scrollView cellForRowAtIndexPath:botmIndexPath];
        
        //iOS黑魔法,kvc获取属性值
        NSLog(@"-------当前底部cell = %@",[cell valueForKeyPath:@"tablebtn.titleLabel.text"]);
        
        //获取当前显示的cell
        NSArray *arr = ((UITableView *)scrollView).visibleCells;
        for(int i = 0;i<arr.count;i++){
            
            UITableViewCell *cell = arr[i];
            NSLog(@"-------当前cell = %@",[cell valueForKeyPath:@"tablebtn.titleLabel.text"]);
            
        }
        
        
        
    }else if([scrollView isKindOfClass:[UICollectionView class]]){
        
        
        //  // 获取当前显示的cell的个数
        NSArray *itemarr =[((UICollectionView *)scrollView) indexPathsForVisibleItems];
        NSIndexPath *firstIndexPath = [[((UICollectionView *)scrollView) indexPathsForVisibleItems] firstObject];
        
        NSArray *arr = ((UICollectionView *)scrollView).visibleCells;
        
        for(int i = 0;i<arr.count;i++){
            
            UICollectionViewCell *cell = arr[i];
            NSLog(@"-------当前cell = %@",[cell valueForKeyPath:@"btncellbtn.titleLabel.text"]);
            
        }
        
        
    }
    
    NSLog(@"偏移量------X = %f,Y = %f",((UIScrollView *)scrollView).contentOffset.x,((UIScrollView *)scrollView).contentOffset.y);
    
}


void dd_addscrollViewDidEndDeceleratingdrag(id self, SEL _cmd,  id scrollView,BOOL decelerate) {
    
    if(!decelerate){
        
        //下面两句使其继续执行原来的方法
        SEL selector = NSSelectorFromString(@"dd_addscrollViewDidEndDecelerating");
        ((void(*)(id, SEL, UIScrollView *))objc_msgSend)(self, selector, scrollView);
        
        [scrollView XC_GetViewControllerWithView:scrollView];
        
        //判断是否为UITableView或者UICollectionView
        if([scrollView isKindOfClass:[UITableView class]]){
            
            //获取处于UITableView中心的cell
            //系统方法返回处于tableView某坐标处的cell的indexPath
            NSIndexPath * topIndexPath = [(UITableView *)scrollView  indexPathForRowAtPoint:CGPointMake(0, ((UITableView *)scrollView).contentOffset.y)];
            NSIndexPath * middleIndexPath = [ ((UITableView *)scrollView)  indexPathForRowAtPoint:CGPointMake(0,  ((UITableView *)scrollView).contentOffset.y +  ((UITableView *)scrollView).frame.size.height/2)];
            
            NSIndexPath * botmIndexPath = [ ((UITableView *)scrollView)  indexPathForRowAtPoint:CGPointMake(0,  ((UITableView *)scrollView).contentOffset.y +  ((UITableView *)scrollView).frame.size.height)];
            
            NSLog(@"top的cell：第 %ld 组 %ld个",topIndexPath.section, topIndexPath.row);
            NSLog(@"中间的cell：第 %ld 组 %ld个",middleIndexPath.section, middleIndexPath.row);
            NSLog(@"底部的cell：第 %ld 组 %ld个",botmIndexPath.section, botmIndexPath.row);
            
            UITableViewCell * cell = (UITableViewCell *)[(UITableView *)scrollView cellForRowAtIndexPath:botmIndexPath];
            
            //iOS黑魔法,kvc获取属性值
            NSLog(@"-------city = %@",[cell valueForKeyPath:@"tablebtn.titleLabel.text"]);
            
            //获取当前显示的cell
            NSArray *arr = ((UITableView *)scrollView).visibleCells;
            for(int i = 0;i<arr.count;i++){
                
                UITableViewCell *cell = arr[i];
                NSLog(@"-------city = %@",[cell valueForKeyPath:@"tablebtn.titleLabel.text"]);
                
            }
            
            
            
        }else if([scrollView isKindOfClass:[UICollectionView class]]){
            
            
            //  // 获取当前显示的cell的个数
            NSArray *itemarr =[((UICollectionView *)scrollView) indexPathsForVisibleItems];
            NSIndexPath *firstIndexPath = [[((UICollectionView *)scrollView) indexPathsForVisibleItems] firstObject];
            NSLog(@"top的cell：第 %ld 组 %ld个",firstIndexPath.section, firstIndexPath.row);
            
            NSArray *arr = ((UICollectionView *)scrollView).visibleCells;
            
            for(int i = 0;i<arr.count;i++){
                
                UICollectionViewCell *cell = arr[i];
                NSLog(@"-------city = %@",[cell valueForKeyPath:@"btncellbtn.titleLabel.text"]);
                
            }
            
            
        }
        
        NSLog(@"X = %f,Y = %f",((UIScrollView *)scrollView).contentOffset.x,((UIScrollView *)scrollView).contentOffset.y);
        
        
    }
    
}


@end

