//
//  KBPopView.m
//  磨砂动画效果
//
//  Created by kangbing on 16/4/10.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "KBPopView.h"
#import "UIImage+ImageEffects.h"
#import "MJExtension.h"
#import "KBMenuButton.h"
#import "UIView+Extension.h"
#import <POP.h>


#define KBScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KBScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface KBPopView ()

@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation KBPopView

// 懒加载一数组
- (NSMutableArray *)btnArray{
    
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    
    
    return _btnArray;
    
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        

        self.frame = CGRectMake(0, 0, KBScreenWidth, KBScreenHeight);
        
        // 给图片一个磨砂的效果
        UIImage *image = [[self curentimage] applyLightEffect];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        
        imageView.userInteractionEnabled = YES;
        
        [self addSubview:imageView];
    
        
        //  设置按钮
        [self setbtn];
        
        
        
        [self startAniman];
    }
    return self;
}



- (void)setbtn{

    NSArray *arr = @[@"文字",@"相册",@"文字",@"相册",@"文字",@"相册"];

    
    
    for (int i = 0 ; i < arr.count; i++) {
        

        // 创建按钮
        KBMenuButton *btn = [[KBMenuButton alloc]init];
        btn.backgroundColor = [UIColor orangeColor];
        
//        [btn sizeToFit];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        
        
        // 点击按钮的时候按钮变大
        [btn addTarget:self action:@selector(btnClickBig:) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置位置
        NSInteger lie = 3;
        
        CGFloat margin = (KBScreenWidth - lie * popBtnW) / (lie + 1);
        
        // 设置xy值
        NSInteger col = i % lie;
        NSInteger row = i / lie;
        
        btn.x = (col + 1) * margin + popBtnW * col;
        btn.y = row * popBtnH + KBScreenHeight;
        
        
        [self addSubview:btn];
        
        // 把创建的按钮添加到数组中
        [self.btnArray addObject:btn];
        
        
 
        
    }


}

// 执行动画
- (void)startAniman{
    
    // 遍历数组元素按钮
    [self.btnArray enumerateObjectsUsingBlock:^(KBMenuButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(obj.centerX, obj.centerY - 350)];
        animation.springBounciness = 10;
        animation.springSpeed = 10;
        
        // 给一个延时添加,   最最精确的时间
        animation.beginTime = CACurrentMediaTime() + idx * 0.1;
        
        
        [obj pop_addAnimation:animation forKey:nil];
    }];
    
    
    
    
}

//  点击某一个按钮, 变大
- (void)btnClickBig:(KBMenuButton *)button{
    
    //    NSLog(@"点击按钮");
    
    [UIView animateWithDuration:0.25 animations:^{
        
        // 遍历按钮数组
        [self.btnArray enumerateObjectsUsingBlock:^(KBMenuButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 遍历的是点击的按钮
            if (obj == button) {
                
                obj.transform = CGAffineTransformMakeScale(2, 2);
                obj.alpha = 0.1;
            }else{ // 其他的变小
                
                obj.transform = CGAffineTransformMakeScale(0.2, 0.2);
                obj.alpha = 0.1;
                
                
            }
            
        }];
        
        
    } completion:^(BOOL finished) {
        
        
        //        // 点击之后然后在回到原始状态
                [UIView animateWithDuration:0.5 animations:^{
                   [self.btnArray enumerateObjectsUsingBlock:^(KBMenuButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       obj.transform = CGAffineTransformIdentity;
        
                       obj.alpha = 1.0;
                   }];
        
        
        
                }];
        
        // 可在这跳转控制器
        
        

        
//        [self removeFromSuperview];
        
    }];
    
    
    
    
    
    
}




// 点击消失的时候一个一个消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
    // 一句话数组反转 用一个数组接收
    NSArray *fanArray = [self.btnArray reverseObjectEnumerator].allObjects;
    
    
    [fanArray enumerateObjectsUsingBlock:^(KBMenuButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(obj.centerX, obj.centerY + 350)];
        animation.springBounciness = 10;
        animation.springSpeed = 10;
        
        // 给一个延时添加,   最最精确的时间
        animation.beginTime = CACurrentMediaTime() + idx * 0.05;
        
        
        [obj pop_addAnimation:animation forKey:nil];
    }];
    
    
    
    
    
    // 然后整个view再从父控件中移除
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if (self.myblock) {
            
            self.myblock();
        }
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            
           
            
        }];
        
        
        
        
    });
    
    
    
    
}






#pragma mark 截取当前屏幕
- (UIImage *)curentimage{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 1 实现磨砂效果, 先开启图形上下文
    UIGraphicsBeginImageContext(window.bounds.size);
    
    // 2 获取到开启的图行上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    // 3 把window渲染到上下文当中
    [window.layer renderInContext:ref];
    
    // 4 获取图片,
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5 关闭图形上下文
    UIGraphicsEndImageContext();
    
    
    return image;
    
}




@end
