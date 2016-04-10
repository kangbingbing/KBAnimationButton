//
//  ViewController.m
//  磨砂动画效果
//
//  Created by kangbing on 16/4/10.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "ViewController.h"
#import "KBPopView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"点我" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    
    self.navigationItem.leftBarButtonItem = item;
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.png"]];
    
    self.view = imageView;
    
    imageView.userInteractionEnabled = YES;
    
    
}

#pragma mark 点击按钮
- (void)btnClick{

    self.navigationController.navigationBarHidden = YES;
    
    KBPopView *popView = [[KBPopView alloc]init];

    [self.view addSubview:popView];
    
    popView.myblock = ^(){
        
        self.navigationController.navigationBarHidden = NO;
    };
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
