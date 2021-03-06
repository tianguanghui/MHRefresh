//
//  UIView+QYFrame.h
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QYFrame)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGSize size;

@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

@property (nonatomic, assign) CGPoint origin;

@end
