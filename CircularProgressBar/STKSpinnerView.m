



//
//  BBCircleProgressView.m
//  bienban-ios
//
//  Created by Quy on 12/7/15.
//  Copyright © 2015 TrenteVietNam. All rights reserved.
//

#import "STKSpinnerView.h"
#import <QuartzCore/QuartzCore.h>


@interface STKSpinnerView ()
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) CALayer *maskLayer;


@end

@implementation STKSpinnerView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpCirle];
}

- (void)setUpCirle
{
    CALayer *l = [CALayer layer];
    [self.layer addSublayer:l];
    [self setImageLayer:l];
    
    CALayer *m = [CALayer layer];
    [self.imageLayer setMask:m];
    [self setMaskLayer:m];
    
    
    CAShapeLayer *w = [CAShapeLayer layer];
    [[self layer] addSublayer:w];
    [w setStrokeColor:[[UIColor lightGrayColor] CGColor]];
    [w setFillColor:[[UIColor clearColor] CGColor]];
    
    [self setFirstCircleLayer:w];
    
    CAShapeLayer *s = [CAShapeLayer layer];
    [s setFillColor:[[UIColor clearColor] CGColor]];
    [self.layer addSublayer:s];
    [self setSecondCircleLayer:s];
    
    
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setWellThickness:10];
    [self setColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.0 alpha:1]];
    [self setProgress:_progress];
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCirle];
    }
    return self;
}

#pragma mark - setLabelWithPercentage
-(void)setLabelWithPercent:(NSString *)msg{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(makeCirle:) userInfo:msg repeats:YES];
    
    _percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-25,
                                                             self.frame.size.height/2-25,
                                                             50,
                                                             50)];
    
    _percentLabel.textColor = [UIColor blackColor];
    [_percentLabel setText:msg];
    [_percentLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [_percentLabel setTextAlignment:NSTextAlignmentCenter];
    [_percentLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_percentLabel];
    [self changeValue:_progress];
}
- (void)makeCirle:(NSTimer *)timer
{
    NSString *timerUserInfo = (NSString*)[timer userInfo];
    float maxValue = [timerUserInfo floatValue] / 100;
    static float progress = 0.0;
    progress += 0.03;
    if(progress >= maxValue) {
        progress = maxValue;
        [timer invalidate];
    }
    [self  setProgress:progress animated:YES];
    
}

#pragma mark - changeValue
-(void)changeValue:(float)val{
    [_percentLabel setText:[NSString stringWithFormat:@"%.0f%@",_progress*100,@"%"]];
}

- (void)setImage:(UIImage *)image
{
    [self.imageLayer setContents:(id)[image CGImage]];
}

- (UIImage *)image
{
    return [UIImage imageWithCGImage:(CGImageRef)[[self imageLayer] contents]];
}

- (void)setWellThickness:(float)circleThickness
{
    _circleThickness = circleThickness;
    [self.secondCircleLayer setLineWidth:_circleThickness];
    
    [self.firstCircleLayer setLineWidth:_circleThickness];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self.secondCircleLayer setStrokeColor:[_color CGColor]];
    
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    float currentProgress = _progress;
    _progress = progress;
    [self changeValue:_progress];
    [CATransaction begin];
    if(animated) {
        float delta = fabs(_progress*2 - currentProgress);
        [CATransaction setAnimationDuration:MAX(0.2, delta * 1.0)];
    } else {
        [CATransaction setDisableActions:YES];
    }
    [self.secondCircleLayer setStrokeEnd:_progress];
    
    [CATransaction commit];
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (float)radius
{
    CGRect r = CGRectInset(self.bounds, self.circleThickness / 2.0, self.circleThickness / 2.0);
    float w = r.size.width;
    float h = r.size.height;
    if(w > h)
        return h / 2.0;
    
    return w / 2.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    float wt = self.circleThickness;
    CGRect outer = CGRectInset(self.bounds, wt / 2.0, wt / 2.0);
    CGRect inner = CGRectInset(self.bounds, wt, wt);
    
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:inner];
    
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(outer), CGRectGetMidY(outer))
                                                             radius:[self radius]
                                                         startAngle:-M_PI_2
                                                           endAngle:(2.0 * M_PI - M_PI_2)
                                                          clockwise:YES];
    [self.firstCircleLayer setPath:[outerPath CGPath]];
    
    UIBezierPath *outerPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(outer), CGRectGetMidY(outer))
                                                              radius:[self radius]
                                                          startAngle:M_PI
                                                            endAngle:(2.0 * M_PI + M_PI)
                                                           clockwise:YES];
    
    [self.secondCircleLayer setPath:[outerPath1 CGPath]];
    
    
    
    
    [self.imageLayer setFrame:bounds];
    [self.maskLayer setFrame:bounds];
    [self.secondCircleLayer setFrame:bounds];
    
    
    [self changeValue:self.progress];
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [[UIScreen mainScreen] scale]);
    [innerPath fill];
    [self.maskLayer setContents:(id)[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
    
    UIGraphicsEndImageContext();
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
