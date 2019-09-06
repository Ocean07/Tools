//
//  SAHeaderBGView.h
//
//  Created by luomeng on 2018/9/5.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAHeaderBGView : UIView

@property (nonatomic, strong) UIColor *firstWaveColor;// 第一个波浪颜色
@property (nonatomic, strong) UIColor *secondWaveColor;// 第二个波浪颜色

- (void)startBGAnimation;

@end
