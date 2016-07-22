//
//  ARTCollectionViewCell.h
//  DBmeinv-OC
//
//  Created by Artillery on 16/7/19.
//  Copyright © 2016年 com.Artillery. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTImageItems;
@interface ARTCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) ARTImageItems *imageItem;


-(CGRect)layoutWithIndexPath:(NSIndexPath *)IndexPath itemsArray:(NSArray *)array;

@end
