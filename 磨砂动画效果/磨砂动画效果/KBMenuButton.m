//
//  KBMenuButton.m
//
//  Created by kangbing on 16/4/10.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "KBMenuButton.h"
#import "UIView+Extension.h"



@implementation KBMenuButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置按钮的大小
        self.size = CGSizeMake(popBtnW, popBtnH);
        
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 设置图片为原始大小图片, (并且居中)
        self.imageView.contentMode = UIViewContentModeCenter;
        
        
        
        
        
    }
    return self;
}






// 设置图片和文字的位置
- (void)layoutSubviews{

    [super layoutSubviews];
    
    // 设置图片位置
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = popBtnW;
    self.imageView.height = popBtnW;
    
    // 设置文字位置
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = popBtnW;
    self.titleLabel.height = popBtnH - popBtnW;
    
    
    
    
    




}



@end
