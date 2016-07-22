//
//  ARTCollectionViewCell.m
//  DBmeinv-OC
//
//  Created by Artillery on 16/7/19.
//  Copyright © 2016年 com.Artillery. All rights reserved.
//

#import "ARTCollectionViewCell.h"
#import "ARTImageItems.h"

#import <UIImageView+WebCache.h>

@implementation ARTCollectionViewCell


-(void)setImageItem:(ARTImageItems *)imageItem
{
    _imageItem = imageItem;

    //添加图片
    UIImageView *imageV = ({
        imageV = [[UIImageView alloc]initWithFrame:self.bounds];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV;
    });
    
    
    NSURL *url = [NSURL URLWithString:imageItem.src];
    
    // 从内存\沙盒缓存中获得原图
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageItem.src];
    
    if (originalImage)
    { // 如果内存\沙盒缓存有原图，那么就直接显示原图
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageItem.src] completed:nil];
    }else{
        [imageV sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             CGSize currentSize = image.size;
             currentSize.height = imageItem.cellSize.width * image.size.height / image.size.width;
             currentSize.width = imageItem.cellSize.width;
             UIGraphicsBeginImageContextWithOptions(currentSize, NO, 0);
             [image drawInRect:CGRectMake(0, 0, currentSize.width, currentSize.height)];
             UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             imageV.image = newImage;
         }];
        
        
        
    }
    
    //防止图片被循环利用
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self addSubview:imageV];
}

-(CGRect)layoutWithIndexPath:(NSIndexPath *)indexPath itemsArray:(NSArray *)array
{

    //列数
    NSInteger  cols = 2;
    //间距
    NSInteger margin = 10;
    //当前列
    NSInteger currentCol = indexPath.row % cols;
    //当前行
    NSInteger currentRow = indexPath.row / cols;
    //当前的尺寸
    CGFloat   currentW = ([UIScreen mainScreen].bounds.size.width - margin *(1 + cols)) / cols ;
    //    CGFloat   currentH = [self.heightArray[indexPath.row] floatValue];
    CGFloat currentH = self.imageItem.cellSize.height;
    
    //当前的位置
    CGFloat positionX = currentW * currentCol + margin * (currentCol + 1);
    CGFloat positionY = (currentRow + 1) * margin;
    //求Y值
    for (NSInteger i = 0; i < currentRow; i++)
    {   //当前是第几个
        NSInteger position = currentCol + i * cols;
        
        ARTImageItems *tempitem =  array[position];
        positionY += tempitem.cellSize.height;
        
    }
    
    return  CGRectMake(positionX,positionY,currentW,currentH) ;

    
}

@end
