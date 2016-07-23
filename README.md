# DBmeinv-OC
知道豆瓣妹子这个网站已经很久了,在学习OC的时候萌发了抓取他的网页数据的想法,但是OC毕竟不像Python一样能高效的抓取网页数据.如果使用OC来解析html,由于没有[`XPath`](http://www.w3school.com.cn/xpath/)这方面的概念，简单的学习了下，采用了一个叫[Ono](https://github.com/mattt/Ono)的第三方库来解析html,最终实现了这个小demo.

## Discription

图片来源:

- http://www.dbmeinv.com

## TodoList

- 上下拉刷新加载时间过长
- 保存图片时出现的BUG
- 已经拿到豆瓣小组的API,下一步直接从豆瓣抓去数据

## Screen Shot

 ![Untitled](/Users/Artillery/Desktop/Untitled.gif)

## Dependency

- [AFNetworking](https://github.com/AFNetworking/AFNetworking)
- [MJRefresh](https://github.com/CoderMJLee/MJRefresh)
- [MJExtension](https://github.com/CoderMJLee/MJExtension)
- [SDWebImage](https://github.com/rs/SDWebImage)
- [SVProgressHUD](https://github.com/TransitApp/SVProgressHUD)

## Platform

Mac Pro:

- OS X 10.11.6 

Xcode:

- Version: 7.3.1 (7D1014)
- SDK: iOS SDK 9.3
- Deployment Taget: 8.0