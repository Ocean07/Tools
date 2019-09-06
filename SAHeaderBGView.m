//
//  SAHeaderBGView.m
//
//  Created by luomeng on 2018/9/5.
//  Copyright © 2018年 . All rights reserved.
//

#import "SAHeaderBGView.h"

@interface SAHeaderBGView ()
@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, strong) CAShapeLayer  *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer  *secondWaveLayer;
@end

@implementation SAHeaderBGView {
    CGFloat waveAmplitude;  // 波纹振幅
    CGFloat waveCycle;      // 波纹周期
    CGFloat waveSpeed;      // 波纹速度
    
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;           // 波浪x位移
    CGFloat currentWavePointY; // 当前波浪上市高度Y（高度从大到小 坐标系向下增长）
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CAGradientLayer *layer = [[CAGradientLayer alloc] init];
        layer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0, 1);
        layer.colors = @[
                         (id)UIColorFromRGBA(0, 198, 251, 1).CGColor,
                         (id)UIColorFromRGBA(0, 91, 236, 1).CGColor
                         ];
        [self.layer addSublayer:layer];
        
        self.layer.masksToBounds = YES;
        [self configDetaultProperty];
        
        self.secondWaveLayer.hidden = YES;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self configDetaultProperty];
    }
    return self;
}

- (void)dealloc {
    [self reset];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self resetProperty];
}

- (void)configDetaultProperty {
    
    _firstWaveColor = [UIColor colorWithRed:125/255.0 green:177/255.0 blue:255/255.0 alpha:0.46];
    _secondWaveColor = [UIColor colorWithRed:236/255.0f green:90/255.0f blue:66/255.0f alpha:1];
    
    waveSpeed = 0.04/M_PI;
    waveAmplitude = 10;
    
    [self resetProperty];
}

- (void)resetProperty {
    waterWaveHeight = self.frame.size.height/2;
    waterWaveWidth  = self.frame.size.width;
    if (waterWaveWidth > 0) {
        waveCycle =  1.29 * M_PI / waterWaveWidth;
    }
    
    currentWavePointY = self.frame.size.height - 60;
    offsetX = 0;
}

- (void)setFirstWaveColor:(UIColor *)firstWaveColor {
    _firstWaveColor = firstWaveColor;
    _firstWaveLayer.fillColor = firstWaveColor.CGColor;
}

- (void)setSecondWaveColor:(UIColor *)secondWaveColor {
    _secondWaveColor = secondWaveColor;
    _secondWaveLayer.fillColor = secondWaveColor.CGColor;
}

- (void)startBGAnimation {
    [self resetProperty];
    
    if (_firstWaveLayer == nil) {
        // 创建第一个波浪Layer
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
        [self.layer addSublayer:_firstWaveLayer];
    }
    
    if (_secondWaveLayer == nil) {
//        // 创建第二个波浪Layer
//        _secondWaveLayer = [CAShapeLayer layer];
//        _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
//        [self.layer addSublayer:_secondWaveLayer];
    }
    
    if (_waveDisplaylink) {
        [self stopBGWaveAnimation];
    }
    
    // 启动定时调用
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWaveAnimation:)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)stopBGWaveAnimation {
    [_waveDisplaylink invalidate];
    _waveDisplaylink = nil;
}

- (void)reset {
    [_waveDisplaylink invalidate];
    _waveDisplaylink = nil;
    
    [self resetProperty];
    
    [_firstWaveLayer removeFromSuperlayer];
    _firstWaveLayer = nil;
    [_secondWaveLayer removeFromSuperlayer];
    _secondWaveLayer = nil;
}

- (void)updateWaveAnimation:(CADisplayLink *)displayLink {
    // 波浪位移
    offsetX += waveSpeed;
    
    [self configFirstWaveLayerPath]; // 一条
//    [self configSecondWaveLayerPath];  // 两条
}

-(void)configFirstWaveLayerPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 正弦波浪公式
        y = waveAmplitude * sin(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _firstWaveLayer.path = path;
    CGPathRelease(path);
}

-(void)configSecondWaveLayerPath {
    
    if (_secondWaveLayer == nil) {
        return;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 余弦波浪公式
        y = waveAmplitude * cos(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _secondWaveLayer.path = path;
    CGPathRelease(path);
}

@end
