//
//  ARTMainViewController.m
//  DBmeinv-OC
//
//  Created by Artillery on 16/7/19.
//  Copyright © 2016年 com.Artillery. All rights reserved.
//
#define DOUBAN_BASE_URL @"http://www.dbmeinv.com/"


#import "ARTMainViewController.h"
#import "ARTCollectionViewCell.h"
#import "ARTImageItems.h"
#import "UIView+Frame.h"

#import "AFNetworking.h"
#import "MJRefresh.h"
#import <Ono/ONOXMLDocument.h>
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>

#warning TODO 
/**
 *  
    加载新数据
    上下拉刷新
    点击放大
 */

@interface ARTMainViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *squareItems;
@property (nonatomic,strong) NSMutableArray *heightArray;


/**保存按钮状态*/
@property (nonatomic,strong) UIButton *preButton;

@property (nonatomic,weak) UICollectionView *collect;



@end

@implementation ARTMainViewController




static NSString * const reuseIdentifier = @"Cell";

#pragma mark - lazy loading
-(NSMutableArray *)squareItems
{
    if (_squareItems == nil)
    {
        _squareItems = [NSMutableArray array];
    }
    
    return _squareItems;
}

-(NSMutableArray *)heightArray
{
    if (_heightArray == nil)
    {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

#pragma mark - life cicyle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpCollectionView];
    [self setUptitleView];
    
    [self refreshAction];
    

    
    self.navigationItem.title = @"豆瓣妹子";
    
    

}

-(ARTTopicType)type
{
    return daxiong;
}


-(void)setUptitleView
{

    NSArray *titleArr = @[@"大胸妹",@"小翘臀",@"黑丝袜",@"美腿控",@"有颜值",@"大杂烩"];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 35)];
    
    for (int i = 0; i < titleArr.count; i++)
    {
        
        CGFloat btnX = i * titleView.bounds.size.width / titleArr.count;
        CGFloat btnW = titleView.bounds.size.width / titleArr.count;
        UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 0, btnW, 35)];
        
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        titleView.backgroundColor =  [UIColor grayColor];
        
        [btn addTarget:self action:@selector(switchPage:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
        
    }
    [self.view addSubview: titleView];

}

-(void)switchPage:(UIButton *)button
{
    self.preButton.selected = NO;
    
    button.selected = !button.selected;

   self.preButton = button;

}

#pragma mark - 上下拉刷新控件
-(void)refreshAction
{

    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collect.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        
            [self loadDate];

            [weakSelf.collect reloadData];
            
            // 结束刷新
            [weakSelf.collect.mj_header endRefreshing];
        
    }];
    [self.collect.mj_header beginRefreshing];
    
    // 上拉刷新
    self.collect.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
            [self loadMoreDate];

            [weakSelf.collect reloadData];
        
//        [self.heightArray removeAllObjects];
        
            // 结束刷新
            [weakSelf.collect.mj_footer endRefreshing];
        
    }];
    // 默认先隐藏footer
    self.collect.mj_footer.hidden = YES;


}

#pragma mark - 数据加载
-(void)loadDate
{
    
    [self.squareItems removeAllObjects];
    [self.heightArray removeAllObjects];
    
    NSString * randomUserAgent = ({
        
        NSArray * userAgents = @[@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36",
                                 @"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36",
                                 @"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:36.0) Gecko/20100101 Firefox/36.0",
                                 @"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36",
                                 @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-US) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27"];
        
        randomUserAgent =  userAgents[arc4random() % userAgents.count];
        randomUserAgent;
        
    });
    
    AFHTTPSessionManager *request =({
        request =  [[AFHTTPSessionManager alloc]init];
        
        request.responseSerializer = [AFHTTPResponseSerializer serializer];
        request.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        request;
    });
    
    [request.requestSerializer setValue:randomUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    
    NSDictionary *parameters = @{@"cid":@(self.type),
                                 @"pager_offset":@1
                                 };
    
    
    
    [request GET:BASE_URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress)
    {
    
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSData *data = responseObject;
         
         ONOXMLDocument * document = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
         
         NSString * olPath = @"//*[@id=\"main\"]/div[2]/div[2]/ul[@class=\"thumbnails\"]";
         
         
         ONOXMLElement * olELement = [document firstChildWithXPath:olPath];
         NSArray * olElementChildern = olELement.children;
         
         NSMutableArray *tempArr = [NSMutableArray array];
         for (NSUInteger index = 1; index < olElementChildern.count +1; index ++)
         {
             NSString *liXPath  = [NSString stringWithFormat:@"//*[@id=\"main\"]/div[2]/div[2]/ul/li[%ld]/div/div[1]/a/img",index];
             
             ONOXMLElement * liElement = [olELement firstChildWithXPath:liXPath];
             
             [tempArr addObject:liElement.attributes];
         }
         
         for (NSDictionary *dic in tempArr) {
             ARTImageItems * item = [[ARTImageItems alloc] init];
             item.src = dic[@"src"];
             
             NSURL *url = [NSURL URLWithString:item.src];
             NSData * data = [NSData dataWithContentsOfURL:url];
             UIImage * image = [UIImage imageWithData:data];
            
             CGSize currentSize = image.size;

             
             //列数
             NSInteger  cols = 2;
             //间距
             NSInteger margin = 10;
             
             //当前的尺寸
             CGFloat   currentW = ([UIScreen mainScreen].bounds.size.width - margin *(1 + cols)) / cols ;
             currentSize.height = currentW * image.size.height / image.size.width;
             currentSize.width = currentW;
             item.cellSize = currentSize;
//             static int i = 1;
             [self.squareItems addObject:item];
             [self.heightArray addObject:[NSString stringWithFormat:@"%f",currentSize.height]];
         }
//         self.squareItems = [ARTImageItems mj_objectArrayWithKeyValuesArray:tempArr];
         
      
         
         [self.collect reloadData];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
     }];
    

}

-(void)loadMoreDate
{

  static  NSInteger i = 2;
    NSString * randomUserAgent = ({
        
        NSArray * userAgents = @[@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36",
                                 @"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36",
                                 @"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:36.0) Gecko/20100101 Firefox/36.0",
                                 @"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36",
                                 @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-US) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27"];
        
        randomUserAgent =  userAgents[arc4random() % userAgents.count];
        randomUserAgent;
        
    });
    
    AFHTTPSessionManager *request =({
        request =  [[AFHTTPSessionManager alloc]init];
        
        request.responseSerializer = [AFHTTPResponseSerializer serializer];
        request.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        request;
    });
    
    [request.requestSerializer setValue:randomUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSDictionary *parameters = @{@"cid":@(self.type),
                                 @"pager_offset":@(i)
                                 };
    
    
    [request GET:BASE_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSData *data = responseObject;
         
         ONOXMLDocument * document = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
         
         NSString * olPath = @"//*[@id=\"main\"]/div[2]/div[2]/ul[@class=\"thumbnails\"]";
         
         
         ONOXMLElement * olELement = [document firstChildWithXPath:olPath];
         NSArray * olElementChildern = olELement.children;
         
         NSMutableArray *tempArr = [NSMutableArray array];
         for (NSUInteger index = 1; index < olElementChildern.count +1; index ++)
         {
             NSString *liXPath  = [NSString stringWithFormat:@"//*[@id=\"main\"]/div[2]/div[2]/ul/li[%ld]/div/div[1]/a/img",index];
             
             ONOXMLElement * liElement = [olELement firstChildWithXPath:liXPath];
             
             [tempArr addObject:liElement.attributes];
         }
         
         for (NSDictionary *dic in tempArr) {
             ARTImageItems * item = [[ARTImageItems alloc] init];
             item.src = dic[@"src"];
             
             NSURL *url = [NSURL URLWithString:item.src];
             NSData * data = [NSData dataWithContentsOfURL:url];
             UIImage * image = [UIImage imageWithData:data];
             
             CGSize currentSize = image.size;
             
             //列数
             NSInteger  cols = 2;
             //间距
             NSInteger margin = 10;
             
             //当前的尺寸
             CGFloat   currentW = ([UIScreen mainScreen].bounds.size.width - margin *(1 + cols)) / cols ;
             currentSize.height = currentW * image.size.height / image.size.width;
             currentSize.width = currentW;
             item.cellSize = currentSize;
             static int i = 1;
             NSLog(@"%i  ==== %lf",i++ , currentSize.height);
             [self.squareItems addObject:item];
             
             [self.heightArray addObject:[NSString stringWithFormat:@"%f",currentSize.height]];
         }
//         NSMutableArray *moreArr = [ARTImageItems mj_objectArrayWithKeyValuesArray:tempArr];
         
//         [self.squareItems addObjectsFromArray:moreArr];
         
         
         [self.collect reloadData];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
     }];
    
    i ++;

}

#pragma mark - 数据源
-(void)setUpCollectionView
{
    
    
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout;
    });
    
    UICollectionView *collect = ({
        
        collect = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        collect.delegate = self;
        collect.dataSource = self;
        collect.backgroundColor = [UIColor grayColor];
        collect;
    });
    
    collect.contentInset = UIEdgeInsetsMake(35, 0, 0, 0);
    
    
    
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:collect];
    
    self.collect = collect;



}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    ARTImageItems *item = self.squareItems[indexPath.row];
    

    
    return  item.cellSize;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 设置尾部控件的显示和隐藏
    self.collect.mj_footer.hidden = self.squareItems.count == 0;
    return self.squareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
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
    CGFloat   currentH = [self.heightArray[indexPath.row] floatValue];

    //当前的位置
    CGFloat positionX = currentW * currentCol + margin * (currentCol + 1);
    CGFloat positionY = (currentRow + 1) * margin;
    //求Y值
    for (NSInteger i = 0; i < currentRow; i++)
    {   //当前是第几个
        NSInteger position = currentCol + i * cols;
        
        positionY += [self.heightArray[position] floatValue];

    }

    cell.frame = CGRectMake(positionX,positionY,currentW,currentH) ;
    
    cell.backgroundColor = [UIColor redColor];
    
    //添加图片
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:cell.bounds];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    
    ARTImageItems *item = self.squareItems[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:item.src];
    
    
    
    // 从内存\沙盒缓存中获得原图
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:item.src];
    
    if (originalImage) { // 如果内存\沙盒缓存有原图，那么就直接显示原图（不管现在是什么网络状态）
        
        static int i  = 0;
        
        NSLog(@"缓存po 到第%dcell",i++);
        [imageV sd_setImageWithURL:[NSURL URLWithString:item.src] completed:nil];
    }else{
        [imageV sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             CGSize currentSize = image.size;
             currentSize.height = currentW * image.size.height / image.size.width;
             currentSize.width = currentW;
             UIGraphicsBeginImageContextWithOptions(currentSize, NO, 0);
             [image drawInRect:CGRectMake(0, 0, currentSize.width, currentSize.height)];
             UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             imageV.image = newImage;
         }];
        

        NSLog(@"高度%fcell",imageV.image.size.height);

    }
    


    //防止图片被循环利用
    for (UIView * view in cell.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [cell addSubview:imageV];
    
    
    return cell;
}

#pragma mark - 代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{


}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"%zd %zd",self.heightArray.count , self.squareItems.count);
//}

@end
