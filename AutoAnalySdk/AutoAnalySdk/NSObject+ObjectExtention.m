//
//  NSObject+ObjectExtention.m
//  AutoAnalySdk
//
//  Created by iOS on 19/2/17.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "NSObject+ObjectExtention.h"
#import <objc/runtime.h>

@implementation NSObject (ObjectExtention)
//减速停止了时执行，手触摸时执行执行

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

{
    
    
}
//停止滑动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    
}


- (NSString *)eventKey {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEventKey:(NSString *)eventKey {
    
    objc_setAssociatedObject(self, @selector(eventKey), eventKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//获取路径和viewPathClass(路径对应的类名)
- (void)nextView:(UIView *)next foreView:(UIView *)viewFore viewPathClass:(NSMutableString *)viewPathClass viewPath:(NSMutableString *)viewPath {
    
    /*
     注意点:在UITableView或UICollectionView的自定义cell中创建一button,如何判断
     若无法通过下面方式获取,是否可以通过查找cell所在行数判断
     */
    
    
    
    NSMutableArray *selfClassArr = [NSMutableArray array];
    NSInteger numTablecell = 0;
    //循环遍历父视图的子视图个数,并找出自身所在的子视图位置
    for (int i = 0;i< next.subviews.count;i++){
        
        //查找相同类型的视图,比如button,uiview 这样可以避免当删除其它类型视图的时候不影响同类型的深度排序
        if([next.subviews[i] isMemberOfClass:[viewFore class]]){
            
            if ([next.subviews[i] isKindOfClass:[UITableViewCell class]]) {
                //UITableViewCell的上面有一层UIView,因而最终出来的路径会多一层0
                if (numTablecell !=1 ) {
                    
                    UITableViewCell *cell = (UITableViewCell *)viewFore;
                    NSIndexPath *indexPath = [(UITableView *)next indexPathForCell:cell];
                    [viewPathClass appendFormat:@"%@&",NSStringFromClass([viewFore class])];
                    [viewPath appendFormat:@"%ld&",indexPath.row];
                    NSLog(@"%ld",indexPath.row);
                    
                }
                
                numTablecell = 1;
                
            } else if ([next.subviews[i] isKindOfClass:[UICollectionViewCell class]]) {
                //UITableViewCell的上面有一层UITableViewCellContentView,因而最终出来的路径会多一层0
                if (numTablecell !=1 ) {
                    
                    UICollectionViewCell *cell = (UICollectionViewCell *)viewFore;
                    
                    
                    NSIndexPath * indexPath = [(UICollectionView *)next  indexPathForCell:cell];
                    [viewPathClass appendFormat:@"%@&",NSStringFromClass([viewFore class])];
                    [viewPath appendFormat:@"%ld&",indexPath.row];
                    NSLog(@"%ld",indexPath.row);
                    
                    
                }
                
                numTablecell = 1;
                
            }else{
                
                [selfClassArr addObject:next.subviews[i]];
                
            }
            
        }
        
    }
    
    for (int i = 0;i< selfClassArr.count;i++){
        
        if (viewFore == selfClassArr[i]) {
            //拼接路径
            
            [viewPathClass appendFormat:@"%@&",NSStringFromClass([viewFore class])];
            [viewPath appendFormat:@"%d&",i];
            
            NSLog(@"index------------%ld",i);
            
        }
        
    }
    
    
}

- (UIViewController *)XC_GetViewControllerWithView:(UIView *)view
{
    /*
     isKindOfClass:确定一个对象是否是一个类的成员,或者是派生自该类的成员.,可以是继承者
     isMemberOfClass:确定一个对象是否是当前类的成员.,不能是继承者
     */
    UIView *viewFore = self;
    NSMutableString *viewPath = [[NSMutableString alloc] init];
    NSMutableString *viewPathClass = [[NSMutableString alloc] init];
    
    for (UIView* next = [view superview]; next; next = next.superview) {
        
        UIResponder *nextResponder = [next nextResponder];
        NSLog(@"class-----%@", NSStringFromClass([next class]));
        NSLog(@"classnext-----%@", NSStringFromClass([nextResponder class]));
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            [self nextView:next foreView:viewFore viewPathClass:viewPathClass viewPath:viewPath];
            [viewPathClass appendFormat:@"%@",NSStringFromClass([nextResponder class])];
            
            //当遍历到控制器的时候结束路径拼接,最终路径为0
            [viewPath appendFormat:@"%@",@"0"];
            
            NSLog(@"viewPathClass------%@------viewPath-------%@",viewPathClass,viewPath);
            
            return (UIViewController *)nextResponder;
            
        }else{
            
            [self nextView:next foreView:viewFore viewPathClass:viewPathClass viewPath:viewPath];
            
        }
        //将下一个父视图赋值给viewFore
        viewFore = next;
        
    }
    return nil;
    
}


@end
