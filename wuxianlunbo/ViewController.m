//
//  ViewController.m
//  wuxianlunbo
//
//  Created by bug neo on 2017/5/25.
//  Copyright © 2017年 bug neo. All rights reserved.
//

#import "ViewController.h"
#import "ForeverBannerView.h"

@interface ViewController ()<ForeverBannerViewDelegate>
@property (nonatomic, strong) ForeverBannerView *bannerview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1.jpeg", @"2.jpeg", @"3.jpg", nil];
    self.bannerview = [[ForeverBannerView alloc] initWithFrame:CGRectMake(30, 100, self.view.frame.size.width-60, 300) array:arr];
    [self.view addSubview:self.bannerview];
    self.bannerview.delegate = self;
    
    [self addBtn];
    
}

- (void)tapImageView:(id)model {
    NSLog(@"%@",model);
}

- (void)addBtn {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    btn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(didBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 20, 40, 40)];
    btn2.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(didBtn2) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didBtn {
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"4.png", nil];//@"5.png", @"6.jpg", nil];
    [self.bannerview resetBanarViewWithArray:arr2];
}


- (void)didBtn2 {
    NSMutableArray *arr3 = [NSMutableArray arrayWithObjects:@"1.jpeg", @"2.jpeg", @"3.jpg", @"5.png", @"6.jpg",nil];
    [self.bannerview resetBanarViewWithArray:arr3];
}

- (void)cgrectOffset {
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(30, 100, 100, 100)];
    [self.view addSubview:firstView];
    firstView.backgroundColor = [UIColor yellowColor];
    
    UIView *secendView = [[UIView alloc] init];
    [self.view addSubview:secendView];
    secendView.frame = CGRectOffset(firstView.frame, 20, 120);
    secendView.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
