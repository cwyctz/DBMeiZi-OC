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
#import "ARTSeeBigPictureViewController.h"
#import "ARTImageItems.h"
#import "UIView+Frame.h"

#import "AFNetworking.h"
#import "MJRefresh.h"
#import <pop/POP.h>
#import <Ono/ONOXMLDocument.h>
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>

@interface ARTMainViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *squareItems;


/**保存按钮状态*/
@property (nonatomic,strong) UIButton *preButton;

@property (nonatomic,weak) UICollectionView *collect;

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation ARTMainViewController

static NSString * const reuseIdentifier = @"Cell";

//列数
static NSInteger  cols = 2;
//间距
static NSInteger margin = 10;


#pragma mark - lazy loading
-(NSMutableArray *)squareItems
{
    if (_squareItems == nil)
    {
        _squareItems = [NSMutableArray array];
    }
    
    return _squareItems;
}

-(AFHTTPSessionManager *)manager
{
    if (_manager == nil)
    {
        NSString * randomUserAgent = ({
            
            NSArray * userAgents = @[@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36",
                                     @"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36",
                                     @"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:36.0) Gecko/20100101 Firefox/36.0",
                                     @"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36",
                                     @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-US) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27"];
            
            randomUserAgent =  userAgents[arc4random() % userAgents.count];
            randomUserAgent;
            
        });
        
        _manager =({
            _manager =  [[AFHTTPSessionManager alloc]init];
            
            _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
            _manager;
        });
        
        [_manager.requestSerializer setValue:randomUserAgent forHTTPHeaderField:@"User-Agent"];
    }
    return _manager;
}

#pragma mark - life cicyle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpCollectionView];
    [self setUptitleView];
    
//    [self refreshAction];
    
    self.navigationItem.title = @"豆瓣妹子";
    
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
        btn.tag = i + 1;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        titleView.backgroundColor =  [UIColor grayColor];
        
        [btn addTarget:self action:@selector(switchPage:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
        
    }
    
    [self switchPage:titleView.subviews.firstObject];
    
    [self.view addSubview: titleView];

    
}
-(void)switchPage:(UIButton *)button
{
    self.preButton.selected = NO;
    button.selected = !button.selected;
    self.preButton = button;
    
    self.type  =  button.tag + 1;
    
//    [self.manager invalidateSessionCancelingTasks:YES];
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    [self refreshAction];
}

#pragma mark - 上下拉刷新控件
-(void)refreshAction
{
    [self.squareItems removeAllObjects];
    [self.collect reloadData];

    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collect.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            [self loadDate];

//            [weakSelf.collect reloadData];
            // 结束刷新
            [weakSelf.collect.mj_header endRefreshing];
    }];
    [self.collect.mj_header beginRefreshing];
    
    // 上拉刷新
    self.collect.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
            [self loadMoreDate];

            [weakSelf.collect reloadData];
        
        
            // 结束刷新
            [weakSelf.collect.mj_footer endRefreshing];
        
    }];
    // 默认先隐藏footer
    self.collect.mj_footer.hidden = YES;


}

#pragma mark - 数据加载
-(void)loadDate
{
    
//    [self.squareItems removeAllObjects];

    NSDictionary *parameters = @{@"cid":@(self.type),
                                 @"pager_offset":@1
                                 };


        [self.manager GET:BASE_URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress)
         {
             
             NSLog(@"%0.2f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
             
         }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSData *data = responseObject;
             

          
             NSOperationQueue *queue = [[NSOperationQueue alloc]init];
             
             [queue addOperationWithBlock:^{
                 self.squareItems = [self dealWithHtml:data];
                 
                 [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                  [self.collect reloadData];
                 }];
             }];
             
             


             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"-----%@",error);
         }];
    
}
/**解析Html数据*/
-(NSMutableArray *)dealWithHtml:(NSData *)data
{
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

    NSMutableArray *arr = [NSMutableArray array];

    for (NSDictionary *dic in tempArr)
    {
        ARTImageItems * item = [[ARTImageItems alloc] init];
        item.src = dic[@"src"];
        
            NSURL *url = [NSURL URLWithString:item.src];
            NSData * data = [NSData dataWithContentsOfURL:url];
            UIImage * image = [UIImage imageWithData:data];
            
            CGSize currentSize = image.size;
            
            
            //当前的尺寸
            CGFloat   currentW = ([UIScreen mainScreen].bounds.size.width - margin *(1 + cols)) / cols ;
            currentSize.height = currentW * image.size.height / image.size.width;
            currentSize.width = currentW;
            item.cellSize = currentSize;
        
            [arr addObject:item];
    }
    
    return  arr;


}

-(void)loadMoreDate
{
  static  NSInteger i = 2;

    NSDictionary *parameters = @{@"cid":@(self.type),
                                 @"pager_offset":@(i)
                                 };
    
    [self.manager GET:BASE_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSData *data = responseObject;
         
         NSOperationQueue *queue = [[NSOperationQueue alloc]init];
         
         [queue addOperationWithBlock:^{
             [self.squareItems addObjectsFromArray:[self dealWithHtml:data]];
             
             [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                 [self.collect reloadData];
             }];
         }];
         
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
        collect.contentInset = UIEdgeInsetsMake(35, 0, 0, 0);
        collect.backgroundColor = [UIColor grayColor];
        collect;
    });
    

    
    [collect registerClass:[ARTCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:collect];
    
    self.collect = collect;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTImageItems *item = self.squareItems[indexPath.row];
    
    // 从内存\沙盒缓存中获得原图
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:item.src];
    
    if (originalImage)
    {
        
        CGSize currentSize = originalImage.size;

        //当前的尺寸
        CGFloat   currentW = ([UIScreen mainScreen].bounds.size.width - margin *(1 + cols)) / cols ;
        currentSize.height = currentW * originalImage.size.height / originalImage.size.width;
        currentSize.width = currentW;
        
        return currentSize;
    }

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
    
    ARTImageItems *item = self.squareItems[indexPath.row];
    //设置数据
    cell.imageItem = item;
    //瀑布流计算
    cell.frame = [cell layoutWithIndexPath:indexPath itemsArray:self.squareItems];
    
    return cell;
}

#pragma mark - 代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTSeeBigPictureViewController *vc = [[ARTSeeBigPictureViewController alloc]init];
    vc.imageItem = self.squareItems[indexPath.row];
//    [self presentViewController:vc animated:YES completion:nil];

    
    [self.collect.window.rootViewController presentViewController:vc animated:YES completion:nil];

}


@end
