//
//  ARTMainViewController.h
//  DBmeinv-OC
//
//  Created by Artillery on 16/7/19.
//  Copyright © 2016年 com.Artillery. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BASE_URL  @"http://www.dbmeinv.com/dbgroup/show.htm"
typedef NS_ENUM(NSUInteger , ARTTopicType)
{
    daxiong = 2,
    qiaotun = 6,
    heisi   = 7,
    meitui  = 3,
    yanzhi  = 4,
    dazahui = 5,
};

@interface ARTMainViewController : UIViewController

@property (nonatomic,assign) NSUInteger type;
//- (ARTTopicType)type;

@end
