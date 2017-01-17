//
//  CLTRoundView.m
//  customRoundView
//
//  Created by xindongyuan on 2016/12/13.
//  Copyright © 2016年 clt. All rights reserved.
//

#import "CLTRoundView.h"




#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式


static CGFloat  lineWidth = 25;   // 线宽

static CGFloat  progressLineWidth = 3;  // 外圆进度的线宽




@interface CLTRoundView ()

@property (nonatomic,strong) CAShapeLayer *bottomShapeLayer; // 外圆的底层layer

@property (nonatomic,strong)CAShapeLayer *upperShapeLayer;  // 外圆的更新的layer
@property (nonatomic,strong)CAGradientLayer *gradientLayer;  // 外圆的颜色渐变layer

@property (nonatomic,assign)CGFloat startAngle;  // 开始的弧度
@property (nonatomic,assign)CGFloat endAngle;  // 结束的弧度
@property (nonatomic,assign)CGFloat radius; // 开始角度
@property (nonatomic,assign)CGFloat progressRadius; // 外层的开始角度

@property (nonatomic,assign)CGFloat centerX;  // 中心点 x
@property (nonatomic,assign)CGFloat centerY;  // 中心点 y

@property (nonatomic,strong)UILabel *progressView;  //  进度文字

@property (nonatomic,strong)CAShapeLayer *progressBottomLayer; // 底部进度条的layer
@property (nonatomic,strong)CAShapeLayer *progressLayer;  // 小的进度progressLayer
@property (nonatomic,strong)CAGradientLayer *progressGradientLayer; // 小的进度渐变颜色


@property (nonatomic,assign) int ratio;  // 记录百分比 用于数字跳动

@end

@implementation CLTRoundView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self  drawLayers];
        
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        [self drawLayers];
        
    }
    return self;
}

- (void)drawLayers
{
    self.backgroundColor = [UIColor blackColor];
    
    
    _startAngle = - 220;  // 启始角度
    _endAngle = 45;  // 结束角度
    
    _centerX = self.frame.size.width / 2;  // 控制圆盘的X轴坐标
    _centerY = self.frame.size.height / 2  + 20; // 控制圆盘的Y轴坐标
    
    _radius = (self.bounds.size.width - 100 - lineWidth) / 2;  // 内圆的角度
    _progressRadius = (self.bounds.size.width - 100 - progressLineWidth + 30) / 2; // 外圆的角度
    
    [self drawBottomLayer];  // 绘制底部灰色填充layer
    [self drawUpperLayer]; // 绘制底部进度显示 layer
    [self drawGradientLayer];  // 绘制颜色渐变 layer
    [_bottomShapeLayer addSublayer:_gradientLayer]; // 将进度渐变layer 添加到 底部layer 上
    [_gradientLayer setMask:_upperShapeLayer]; // 设置进度layer 颜色 渐变
    
    [self.layer addSublayer:_bottomShapeLayer];  // 添加到底层的layer 上
    
    
    
    [self drawProgressBottomLayer];  // 绘制外圆的底层layer
    
    [self drawProgressLayer];   // 绘制外圆的更新的layer
    
    [self drawProgressGradientLayer]; //  绘制渐变色
    
    [_progressBottomLayer addSublayer:_progressGradientLayer];  // 把更新的layer 添加到 底部的layer 上
    [_progressGradientLayer setMask:_progressLayer]; // 设置渐变色的蒙版为更新的layer
    [self.layer addSublayer:_progressBottomLayer ];  // 把bottomlayer 加到自己的layer 上
    
    
    [self addSubview:self.progressView];
}

- (UILabel *)progressView
{
    if (!_progressView) {
        
        _progressView = [[UILabel alloc]init];
        
        CGFloat width = 160;
        CGFloat height = 60;
        _progressView.frame = CGRectMake((self.frame.size.width - width) / 2, _centerY - height / 2, width, height);
        _progressView.font = [UIFont systemFontOfSize:60];
        //        _progressView.backgroundColor = [UIColor greenColor];
        _progressView.textAlignment = NSTextAlignmentCenter;
        _progressView.textColor = [UIColor whiteColor];
        _progressView.text = @"0%";
    }
    
    return _progressView;
}


// 绘制底部的layer
- (CAShapeLayer *)drawBottomLayer
{
    _bottomShapeLayer                 = [[CAShapeLayer alloc] init];
    _bottomShapeLayer.frame           = self.bounds;
    
    
    UIBezierPath *path                = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_radius startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle) clockwise:YES];
    
    
    _bottomShapeLayer.path            = path.CGPath;
    _bottomShapeLayer.lineCap = kCALineCapButt;
    _bottomShapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:10], nil];
    _bottomShapeLayer.lineWidth = lineWidth;
    _bottomShapeLayer.strokeColor     = [UIColor lightGrayColor].CGColor;
    _bottomShapeLayer.fillColor       = [UIColor clearColor].CGColor;
    return _bottomShapeLayer;
}


// 绘制进度的layer
- (CAShapeLayer *)drawUpperLayer
{
    _upperShapeLayer                 = [[CAShapeLayer alloc] init];
    _upperShapeLayer.frame           = self.bounds;
    
    
    
    UIBezierPath *path                = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_radius  startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle) clockwise:YES];
    
    
    
    _upperShapeLayer.path            = path.CGPath;
    _upperShapeLayer.strokeStart = 0;
    _upperShapeLayer.strokeEnd =   0;
    //    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0.3];
    _upperShapeLayer.lineWidth = lineWidth;
    _upperShapeLayer.lineCap = kCALineCapButt;
    _upperShapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:10], nil];
    _upperShapeLayer.strokeColor     = [UIColor redColor].CGColor;
    _upperShapeLayer.fillColor       = [UIColor clearColor].CGColor;
    
    
    return _upperShapeLayer;
}

//  绘制渐变色的layer
- (CAGradientLayer *)drawGradientLayer
{
    
    
    UIBezierPath *path                = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_radius  startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle) clockwise:YES];
    
    NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)[UIColor greenColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor purpleColor].CGColor,(id)[UIColor redColor].CGColor, nil];
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.shadowPath = path.CGPath;
    _gradientLayer.frame = self.bounds;
    _gradientLayer.startPoint = CGPointMake(0, 1);
    _gradientLayer.endPoint = CGPointMake(1, 0);
    [_gradientLayer setColors:colors];
    
    return _gradientLayer;
}

- (CAShapeLayer *)drawProgressBottomLayer
{
    
    
    _progressBottomLayer                 = [[CAShapeLayer alloc] init];
    _progressBottomLayer.frame           = self.bounds;
    UIBezierPath *path                = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_progressRadius  startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle - 5) clockwise:YES];
    _progressBottomLayer.path = path.CGPath;
#pragma mark - 如果想显示为齿轮状态，则打开这段代码
    //    _progressBottomLayer.lineCap = kCALineCapButt;
    //    _progressBottomLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:5], nil];
    
#pragma mark - 线段的开头为圆角
    _progressBottomLayer.lineCap = kCALineCapRound;
    
    _progressBottomLayer.lineWidth = progressLineWidth;
    _progressBottomLayer.strokeColor     = [UIColor clearColor].CGColor;
    _progressBottomLayer.fillColor       = [UIColor clearColor].CGColor;
    return _progressBottomLayer;
}

- (CAShapeLayer *)drawProgressLayer
{
    
    
    
    _progressLayer                 = [[CAShapeLayer alloc] init];
    _progressLayer.frame           = self.bounds;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY ) radius:_progressRadius  startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle - 5)  clockwise:YES];
    _progressLayer.path            = bezierPath.CGPath;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd =   0;
    //    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0.3];
    _progressLayer.lineWidth = progressLineWidth;
    
    
#pragma mark - 如果想显示为齿轮状态，则打开这段代码
    //    _progressLayer.lineCap = kCALineCapButt;
    //    _progressLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:5], nil];
    
#pragma mark - 线段的开头为圆角
    _progressLayer.lineCap = kCALineCapRound;
    
    _progressLayer.strokeColor     = [UIColor blueColor].CGColor;
    _progressLayer.fillColor       = [UIColor clearColor].CGColor;
    return _progressLayer;
    
}

- (CAGradientLayer *)drawProgressGradientLayer
{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY ) radius:_progressRadius  startAngle:degreesToRadians(_startAngle)  endAngle:degreesToRadians(_endAngle - 5)  clockwise:YES];
    
    _progressGradientLayer = [CAGradientLayer layer];
    _progressGradientLayer.frame = self.bounds;
    _progressLayer.shadowPath = bezierPath.CGPath;
    
    _progressGradientLayer.colors =  [NSMutableArray arrayWithObjects:(id)[UIColor greenColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor purpleColor].CGColor,(id)[UIColor redColor].CGColor, nil];
    
    
    //    [_progressGradientLayer setLocations:@[@0.2, @0.5, @0.7, @1]];
    [_progressGradientLayer setStartPoint:CGPointMake(0, 1)];
    [_progressGradientLayer setEndPoint:CGPointMake(1, 0)];
    
    
    return _progressGradientLayer;
}

@synthesize percent = _percent;
- (CGFloat )percent
{
    return _percent;
}
- (void)setPercent:(CGFloat)percent
{
    _percent = percent;
    
    if (percent > 1) {
        percent = 1;
    }else if (percent < 0){
        percent = 0;
    }
    
    
    self.ratio = percent * 100;
    
    
    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0];
    
}

- (void)shapeChange
{
    
    // 复原
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0];
    _upperShapeLayer.strokeEnd = 0 ;
    _progressLayer.strokeEnd = 0 ;
    
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:2.f];
    _upperShapeLayer.strokeEnd = _percent;;
    _progressLayer.strokeEnd = _percent;;
    [CATransaction commit];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_percent * 0.02 target:self selector:@selector(updateLabl:) userInfo:nil repeats:YES];
    
}

- (void)updateLabl:(NSTimer *)sender
{
    static int flag = 0;
    
    if (flag   == self.ratio) {
        
        
        [sender invalidate];
        sender = nil;
        
        self.progressView.text = [NSString stringWithFormat:@"%d%%",flag];
        
        flag = 0;
        
        
    }
    else
    {
        self.progressView.text = [NSString stringWithFormat:@"%d%%",flag];
        
    }
    
    flag ++;
    
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
