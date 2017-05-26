//
//  ForeverBanarView.m
//  wuxianlunbo
//
//  Created by bug neo on 2017/5/25.
//  Copyright © 2017年 bug neo. All rights reserved.
//

#import "ForeverBannerView.h"

#define kWidth  self.frame.size.width
#define kHeight self.frame.size.height


typedef NS_ENUM(NSUInteger, MoveDirection){
    MoveDirectionLeft,
    MoveDirectionRight
};

@interface ForeverBannerView ()
@property (nonatomic, strong) UIImageView *currentImage;
@property (nonatomic, strong) UIImageView *nextImage;
@property (nonatomic, assign) NSInteger currentIndex;  //当前index
@property (nonatomic, assign) NSInteger nextIndex;     //下一张图index
@property (nonatomic, assign) NSInteger previousIndex; //上一张图index
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSTimer *changeImageTime; // 定时器
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation ForeverBannerView

- (instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)array{
    if (self == [super initWithFrame:frame]) {
        self.modelArray = [array mutableCopy];
        [self addAllPro];
        [self addAllImageviews];
    }
    return self;
}

- (void)addAllPro {
    _currentIndex = 0;
}

- (void)addAllImageviews {
    self.clipsToBounds = YES;// 超出的范围不显示
    _currentImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [self insertSubview:_currentImage atIndex:1];
    _currentImage.userInteractionEnabled = YES;
    _currentImage.contentMode = UIViewContentModeScaleToFill;
    _currentImage.clipsToBounds = YES;
    [_currentImage setImage:[self getImageForIndex:self.currentIndex]];
    
    _nextImage = [[UIImageView alloc] initWithFrame:self.bounds];
    _nextImage.contentMode = UIViewContentModeScaleToFill;
    _nextImage.clipsToBounds = YES;
    _nextImage.userInteractionEnabled = YES;
    [self insertSubview:_nextImage atIndex:0];
    
    
    if (self.modelArray.count > 1) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kHeight - 30, kWidth, 30)];
        [self addSubview:_pageControl];
        _pageControl.numberOfPages = self.modelArray.count;
        _pageControl.currentPage = 0;
        
        // 定时器
        [self addTime];

        //添加手势
        [self addPanGesture];
    }
    
    
    [self addTapGesture];
    
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    self.tap = tap;
}

- (void)addPanGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panChangeImage:)];
    self.pan = pan;
    [self addGestureRecognizer:pan];
}
- (void)addTime {
    _changeImageTime = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(changeActionForTime) userInfo:nil repeats:YES];
}

- (void)tap:(UITapGestureRecognizer*)tapGer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapImageView:)]) {
        [self.delegate tapImageView:self.modelArray[self.currentIndex]];
    }
}

- (void)panChangeImage:(UIPanGestureRecognizer*)panGer {
    //暂停定时器
    [self.changeImageTime invalidate];
    self.changeImageTime = nil;
    
    //获取位置
    CGPoint panOffset = [panGer translationInView:self];
    CGFloat changeX = panOffset.x;
    
    CGRect frame = self.currentImage.frame;
    // 清空手势的偏移量
    [self.pan setTranslation:CGPointZero inView:self];
    
    CGFloat resulet = frame.origin.x ;
    //  小于 0 就是向左滑动了 大于 0 就是向右 滑动 了
    resulet <= 0? [self leftScroll:changeX frame:frame] : [self rightScroll:changeX frame:frame];
    
}


// 当前照片左滑动  出现右侧照片
- (void)leftScroll:(float)offX frame:(CGRect)frame
{
    float tempX = frame.origin.x + offX;
    // 移动当前的图片
    self.currentImage.frame = CGRectMake(tempX, frame.origin.y, frame.size.width, frame.size.height);
    // 设置下一张照片
    [self.nextImage setImage:[self getImageForIndex:self.nextIndex]];
    
    self.nextImage.frame = CGRectOffset(self.currentImage.frame, kWidth, 0);
    
    // 收拾停止的时候
    if (self.pan.state == UIGestureRecognizerStateEnded)
    {
        // 恢复定时器
        [self addTime];
        // 判断手势停止的时候展示哪一个 照片
        MoveDirection result = tempX <= - kWidth / 2 ? [self leftOut:self.currentImage rightIn:self.nextImage duration:0.3f] : [self leftIn:self.currentImage rightOut:self.nextImage duration:0.3f];
        
        // 判断需要当先展示的是下张图片的时候  去操作
        if (result == MoveDirectionLeft)
        {
            self.currentIndex = self.nextIndex;// 改变当前展示的下标
            // 交换 _nextImage 和 _currentImage 指针指向，这样的话当前的指针指向就是展示在当前的界面的图片
            UIImageView *temp = self.nextImage;
            self.nextImage = self.currentImage;
            self.currentImage = temp;
            self.pageControl.currentPage = self.currentIndex;
        }
        
    }
    
    
}

// 当前图片右滑动 出现左侧照片
- (void)rightScroll:(float)offX frame:(CGRect)frame
{
    float tempX = frame.origin.x + offX;
    // 移动当前的图片
    self.currentImage.frame = CGRectMake(tempX, frame.origin.y, frame.size.width, frame.size.height);
    // 设置上一张照片
    [self.nextImage setImage:[self getImageForIndex:self.previousIndex]];
    
    self.nextImage.frame = CGRectOffset(self.currentImage.frame, -kWidth, 0);
    
    // 收拾停止的时候
    if (self.pan.state == UIGestureRecognizerStateEnded)
    {
        // 恢复定时器
        [self addTime];
        
        // 判断手势停止的时候展示哪一个 照片
        MoveDirection result = tempX <= kWidth / 2 ? [self leftOut:self.nextImage rightIn:self.currentImage duration:0.3f] : [self leftIn:self.nextImage rightOut:self.currentImage duration:0.3f];
        
        // 要展示上一张照片
        if (result == MoveDirectionRight)
        {
            self.currentIndex = self.previousIndex;
            UIImageView *temp = self.nextImage;
            self.nextImage = self.currentImage;
            self.currentImage = temp;
            self.pageControl.currentPage = self.currentIndex;
        }
    }
}

- (void)changeActionForTime {
    //下一张图片
    [self.nextImage setImage:[self getImageForIndex:self.nextIndex]];
    self.nextImage.frame = CGRectOffset(self.currentImage.frame, kWidth, 0);
    [self leftOut:self.currentImage rightIn:self.nextImage duration:0.5f];
    self.currentIndex = self.nextIndex;// 改变当前展示的下标
    // 交换 _nextImage 和 _currentImage 指针指向，这样的话当前的指针指向就是展示在当前的界面的图片
    UIImageView *temp = self.nextImage;
    self.nextImage = self.currentImage;
    self.currentImage = temp;
    self.pageControl.currentPage = self.currentIndex;
    
}

//展示左侧的图片
- (MoveDirection)leftIn:(UIImageView *)leftView rightOut:(UIImageView *)rightView duration:(NSTimeInterval)duration
{
    /*
     当手势结束的时候  展示位于左边的照片 右侧的看不见
     */
    [UIView animateWithDuration:duration animations:^{
        rightView.frame = CGRectOffset(self.bounds, kWidth, 0);
        leftView.frame = self.bounds;
    } completion:^(BOOL finished) {
        
    }];
    return MoveDirectionRight;
}

// 展示右侧的图片
- (MoveDirection)leftOut:(UIImageView *)leftView rightIn:(UIImageView *)rightView duration:(NSTimeInterval)duration
{
    /*
     当手势结束的时候  左边的 ImageView 滑出视线之外  右侧的 ImageView 占据整个屏幕
     */
    [UIView animateWithDuration:duration animations:^{
        leftView.frame = CGRectOffset(self.bounds, - kWidth, 0);
        rightView.frame = self.bounds;
    } completion:^(BOOL finished) {
    
    }];
    return MoveDirectionLeft;
}

// 获取当前下标下一个坐标
- (NSInteger)nextIndex
{
    return _currentIndex >= self.modelArray.count - 1 ? 0 : _currentIndex + 1;
}
// 获取当前下标的上一个坐标
- (NSInteger)previousIndex
{
    return _currentIndex == 0 ? self.modelArray.count - 1 : _currentIndex - 1;
}

// 根据下标取到照片
- (UIImage *)getImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@",_modelArray[index]]];
}

- (void)resetBanarViewWithArray:(NSMutableArray *)array {
//    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    __block id view;
    for ( view in self.subviews) {
        [view removeFromSuperview];
        view = nil;
    }
    [self.changeImageTime invalidate];
    self.changeImageTime = nil;
    
    [self removeGestureRecognizer:self.pan];
    self.pan = nil;
    
    self.modelArray = [array mutableCopy];
    [self addAllPro];
    [self addAllImageviews];
    
}

@end
