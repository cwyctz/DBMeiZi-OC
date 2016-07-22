//
//  UIView+Frame.m
//  Artillery -BaiSi
//
//  Created by Artillery on 16/7/10.
//  Copyright © 2016年 com.Artillery. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
-(CGFloat)ART_X
{
    return  self.frame.origin.x;
}
-(void)setART_X:(CGFloat)ART_X
{
    CGRect rect = self.frame;
    rect.origin.x = ART_X;
    self.frame = rect;
}

-(CGFloat)ART_Y
{
    return self.frame.origin.y;
}
-(void)setART_Y:(CGFloat)ART_Y
{
    CGRect rect = self.frame;
    rect.origin.y = ART_Y;
    self.frame = rect;
}

-(CGFloat)ART_width
{
    return self.bounds.size.width;
}
-(void)setART_width:(CGFloat)ART_width
{
    CGRect rect = self.frame;
    rect.size.width = ART_width;
    self.frame = rect;
}

-(CGFloat)ART_Height
{
    return  self.bounds.size.height;
}
-(void)setART_Height:(CGFloat)ART_Height
{
    CGRect rect = self.frame;
    rect.size.height = ART_Height;
    self.frame = rect;
}

-(CGFloat)ART_centerX
{

    return self.center.x;
}

-(void)setART_centerX:(CGFloat)ART_centerX
{
    CGPoint center = self.center;
    center.x = ART_centerX;
    self.center = center;
}

-(CGFloat)ART_centerY
{
    return self.center.y;
}
-(void)setART_centerY:(CGFloat)ART_centerY
{
    
    CGPoint center = self.center;
    center.y = ART_centerY;
    self.center = center;

}
@end
