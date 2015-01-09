//
//  MyTextField.m
//  RetainCycleTest
//
//  Created by Parsifal on 15/1/9.
//  Copyright (c) 2015年 Parsifal. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

@end
