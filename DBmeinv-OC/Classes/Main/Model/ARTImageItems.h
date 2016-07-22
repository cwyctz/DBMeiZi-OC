//
//  ARTImageItems.h
//  DBmeinv-OC
//
//  Created by Artillery on 16/7/19.
//  Copyright © 2016年 com.Artillery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ARTImageItems : NSObject

/**原图地址*/
@property (nonatomic,strong) NSString *src;
/**标题*/
@property (nonatomic,strong) NSString *title;

@property (nonatomic,assign) CGSize cellSize;
@end
