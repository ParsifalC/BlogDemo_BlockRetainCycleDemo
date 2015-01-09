//
//  ViewController.m
//  RetainCycleTest
//
//  Created by Parsifal on 15/1/8.
//  Copyright (c) 2015年 Parsifal. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.434 green:0.500 blue:0.372 alpha:1.000];
    //添加按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"tap me!" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(tapView) forControlEvents:(UIControlEventTouchDown)];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)tapView
{
    [self presentViewController:[SecondViewController new] animated:YES completion:nil];
}
@end
