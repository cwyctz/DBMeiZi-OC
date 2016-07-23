//
//  ARTSeeBigPictureViewController.m
//  DBmeinv-OC
//
//  Created by Artillery on 16/7/21.
//  Copyright © 2016年 com.Artillery. All rights reserved.
//

#import "ARTSeeBigPictureViewController.h"
#import <UIImageView+WebCache.h>
#import "ARTImageItems.h"
#import "UIView+Frame.h"
@interface ARTSeeBigPictureViewController ()

@end

@implementation ARTSeeBigPictureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    
    UIImageView *img = [[UIImageView alloc]init];
    
    img.userInteractionEnabled = YES;
    
    [self.view insertSubview:img atIndex:0];
    
    NSString *str =  [self.imageItem.src stringByReplacingOccurrencesOfString:@"bmiddle" withString:@"large"];
    
    [img sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        NSLog(@"%ld",receivedSize / expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        
        img.ART_width = self.view.ART_width;
        img.ART_Height = image.size.height * self.view.ART_width / image.size.width;
        
        img.ART_centerX = self.view.ART_width * 0.5;
        img.ART_centerY = self.view.ART_Height * 0.5;
        
    
    }];


    
}
- (IBAction)SaveBtnClick:(UIButton *)sender {
}

- (IBAction)backBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


@end
