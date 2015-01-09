//
//  SecondViewController.m
//  RetainCycleTest
//
//  Created by Parsifal on 15/1/8.
//  Copyright (c) 2015年 Parsifal. All rights reserved.
//

#import "SecondViewController.h"
#import <ReactiveCocoa.h>
typedef NSString * (^MyBlock)(NSString *);

//测试的类
@interface MyObject ()
@property (copy, nonatomic) MyBlock myBlock;
@end

@implementation MyObject

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

@end


@interface SecondViewController ()

@property (copy, nonatomic) MyBlock myBlock;

@end

@implementation SecondViewController

/*
 * 万变不离其宗——对于block的retain cycle问题，其实只要记住一点：在block里面引用其持有者，只能用弱引用（为了防止弱引用的对象被提前释放，可在block内部进行强引用一次，作用域仅限于block内部，执行完立即被release）。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.434 green:0.500 blue:0.372 alpha:1.000];
    //添加按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    [button setTitle:@"back and dealloc!" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(tapView) forControlEvents:(UIControlEventTouchDown)];
    [self.view addSubview:button];
    
    /******retain cycle test******/
    //1、这种情况下，虽然在block持有了self，但是不会造成retain cycle
    MyBlock myBlock = ^(NSString *str)
    {
        NSLog(@"局部的block 被执行str:%@  obj:%@", str, self);
        return str;
    };
    
    myBlock(@"1");
    
    //2、这种情况下，obj的block里面引用了obj，因而需要用弱引用。
    MyObject *obj = [[MyObject alloc] init];
    __weak MyObject *weakObj = obj;
    
    obj.myBlock = ^(NSString *str) {
        NSLog(@"obj的block被执行 str:%@ obj:%@", str, weakObj);
        return str;
    };
    
    /*
    obj.myBlock = ^(NSString *str) {
        NSLog(@"obj的block被执行 str:%@ obj:%@", obj, str);//错误的写法，会造成obj的retain cycle。这种错误造成的对象无法释放就比较难查到了，因为这个obj是局部的，并不会对当前controller的释放造成影响。这样的内存泄露应该尽量避免(可通过instrument的Leaks查找)。
        return str;
    };
    */
    obj.myBlock(@"2");
    
    //3、这种情况下，block的持有者--self，在block内部被引用了，同1，要用weakSelf
    __weak typeof(self) weakSelf = self;
    self.myBlock = ^(NSString *str)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;//在block内部对weakSelf进行强引用一次，避免weakSelf被提前释放，这次引用会在block结束后被释放；
        NSLog(@"self的block被执行 str:%@  obj:%@", str, strongSelf);
        return str;
    };
    
    /*
     self.myBlock = ^(NSString *str)
     {
     NSLog(@"self的block被执行 str:%@  obj:%@", str, self);//错误的写法，会造成self的retain cycle；
     return str;
     };
     */
    self.myBlock(@"3");
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - private method
- (void)timerMethod
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)tapView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
