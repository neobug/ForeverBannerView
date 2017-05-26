//
//  ForeverBanarView.h
//  wuxianlunbo
//
//  Created by bug neo on 2017/5/25.
//  Copyright © 2017年 bug neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForeverBannerViewDelegate <NSObject>

- (void)tapImageView:(id)model;

@end

@interface ForeverBannerView : UIView

@property (nonatomic, weak) id<ForeverBannerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray*)array;

- (void)resetBanarViewWithArray:(NSMutableArray*)array;

@end
