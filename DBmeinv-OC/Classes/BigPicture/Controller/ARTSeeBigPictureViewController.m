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
#import <Photos/Photos.h>
#import <SVProgressHUD.h>

@interface ARTSeeBigPictureViewController ()

@property (nonatomic,weak) UIImageView *imageView;

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

    self.imageView = img;
    
}
- (IBAction)SaveBtnClick:(UIButton *)sender {
    
    __block NSString *createdAssetId = nil;
    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    
    // 在保存完毕后取出图片
    PHFetchResult<PHAsset *> *createdAssets = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
    
    // 获取软件的名字作为相册的标题
    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    
    // 已经创建的自定义相册
    PHAssetCollection *createdCollection = nil;
    
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            createdCollection = collection;
            break;
        }
    }
    
    if (!createdCollection) { // 没有创建过相册
        __block NSString *createdCollectionId = nil;
        // 创建一个新的相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        } error:nil];
        
        // 创建完毕后再取出相册
        createdCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
    }
    
    if (createdAssets == nil || createdCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
        return;
    }
    
    // 将刚才添加到【相机胶卷】的图片，引用（添加）到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    // 保存结果
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
    }


    
}

- (IBAction)backBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


@end
