//
//  ViewController.m
//  图片轮播器
//
//  Created by 胡学东 on 15/8/29.
//  Copyright (c) 2015年 胡学东. All rights reserved.
//

#import "ViewController.h"
#define imgNum 5

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scorllView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageView;
//创建一个播放动画的计时器属性timer
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //设置图片视图的宽度
    CGFloat imgW = 300;
    //设置图片视图的高度
    CGFloat imgH = 130;
    //设置图片视图的y坐标
    CGFloat imgY = 0;
    //循环创建图片视图
    for (int i = 0; i < imgNum; i++) {
        //创建一个图片视图
        UIImageView *imgView = [[UIImageView alloc] init];
        //获取图片的名字
        NSString *imgName = [NSString stringWithFormat:@"img_%02d",i + 1];
        //将图片加到图片视图中
        imgView.image = [UIImage imageNamed:imgName];
        //设置图片视图的x坐标
        CGFloat imgX = i * imgW;
        //设置图片视图的frame属性
        imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        //将图片视图添加显示到scorllView中
        [self.scorllView addSubview:imgView];
    }
    //设置scorllView的滚动框范围
    self.scorllView.contentSize = CGSizeMake(imgW * imgNum, 0);
    //隐藏下面的水平滚动条
    self.scorllView.showsHorizontalScrollIndicator = NO;
    //设置自动分页显示
    self.scorllView.pagingEnabled = YES;
    //设置页数控件的总页数
    self.pageView.numberOfPages = imgNum;
    //调用自动播放函数
    [self setTimer];
}

//重写代理方法，实现显示当前页数
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取scorllView的偏移量
    CGPoint point = self.scorllView.contentOffset;
    //获取scorllView的宽度
    CGFloat scorllViewW = self.scorllView.frame.size.width;
    //计算当前图片所在的页数
    int page = (point.x + scorllViewW / 2) / scorllViewW;
    //设置页数控件的当前页属性
    self.pageView.currentPage = page;
}

//重写协议中的方法
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //当手动滑动时，停止自动播放
    [self.timer invalidate];
}

//重写协议中的方法
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //当不进行手动滑动时，进行自动播放
    [self setTimer];
}

//自动播放方法
- (void) setTimer {
    //每隔2秒，执行chengePicture方法，并且进行重复
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(chengePicture) userInfo:nil repeats:YES];
    //调整优先级，将计时器添加到消息循环runLoop中，当滑动text View时，scroll View会继续播放动画
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//切换图片方法
- (void) chengePicture {
    //获取当前图片的页数
    NSInteger page = self.pageView.currentPage;
    //判断当前图片是否为最后一张图片
    if (page == imgNum - 1)
        //如果为最后一张图片，则切换到第一张图片
        page = 0;
    else
        //否则切换到下一张图片
        page += 1;
    //获取当前图片的页数
    self.pageView.currentPage = page;
    //设置滚动框的偏移量
    CGPoint point = CGPointMake(page * 300, 0);
    //用动画效果切换滚动框的偏移量
    [self.scorllView setContentOffset:point animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
