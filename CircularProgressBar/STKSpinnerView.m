//
//  STKSpinnerView.m
//  Spyndle
//
//  Created by Joe Conway on 4/19/13.
//

#import "STKSpinnerView.h"
#import <QuartzCore/QuartzCore.h>

#define kPer 100

@interface STKSpinnerView ()
@property (nonatomic, assign) CALayer *imageLayer;
@property (nonatomic, assign) CALayer *maskLayer;
@property (nonatomic, assign) CAShapeLayer *wellLayer;
@property (nonatomic, assign) CAShapeLayer *spinLayer;
@property (nonatomic, assign) CAShapeLayer *spin2Layer;
@end

@implementation STKSpinnerView
@dynamic image;
@synthesize percentageLabel;

- (void)_commonInit
{
    CALayer *l = [CALayer layer];
    [[self layer] addSublayer:l];
    [self setImageLayer:l];
    
    CALayer *m = [CALayer layer];
    [[self imageLayer] setMask:m];
    [self setMaskLayer:m];
    
    
    CAShapeLayer *w = [CAShapeLayer layer];
    [[self layer] addSublayer:w];
    [w setStrokeColor:[[UIColor lightGrayColor] CGColor]];
    [w setFillColor:[[UIColor clearColor] CGColor]];
    [w setShadowColor:[[UIColor darkGrayColor] CGColor]];
//    [w setShadowRadius:2];
//    [w setShadowOpacity:1];
//    [w setShadowOffset:CGSizeZero];

    [self setWellLayer:w];
    
    CAShapeLayer *s = [CAShapeLayer layer];
    [s setFillColor:[[UIColor clearColor] CGColor]];
    [[self layer] addSublayer:s];
    [self setSpinLayer:s];
    
    CAShapeLayer *s2 = [CAShapeLayer layer];
    [s2 setFillColor:[[UIColor clearColor] CGColor]];
    [[self layer] addSublayer:s2];
    [self setSpin2Layer:s2];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setWellThickness:15.0];
    [self setColor:(__bridge UIColor * _Nullable)((__bridge CGColorRef _Nullable)([UIColor colorWithRed:87/255 green:136/255 blue:156/255 alpha:1]))];
    [self setProgress:_progress];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self _commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

#pragma mark - setLabelWithPercentage
-(void)setLabelWithPercentage:(NSString *)msg{

    percentageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-25,
                                                               self.frame.size.height/2-25,
                                                               25,
                                                               25)];
    
    percentageLabel.textColor = [UIColor grayColor];
    [percentageLabel setText:msg];
    
    
    [percentageLabel setTextAlignment:NSTextAlignmentCenter];
    [percentageLabel setBackgroundColor:[UIColor clearColor]];
   // [self addSubview:percentageLabel];
    [self changeValue:_progress];
}
#pragma mark - changeValue
-(void)changeValue:(float)val{
    [percentageLabel setText:[NSString stringWithFormat:@"%0.f%@",val,@"%"]];
}

- (void)setImage:(UIImage *)image
{
    [[self imageLayer] setContents:(id)[image CGImage]];
}

- (UIImage *)image
{
    return [UIImage imageWithCGImage:(CGImageRef)[[self imageLayer] contents]];
}

- (void)setWellThickness:(float)wellThickness
{
    _wellThickness = wellThickness;
    [[self spinLayer] setLineWidth:_wellThickness];
    [[self spin2Layer] setLineWidth:_wellThickness];
    [[self wellLayer] setLineWidth:_wellThickness];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [[self spinLayer] setStrokeColor:[_color CGColor]];
    [[self spin2Layer] setStrokeColor:[_color CGColor]];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    float currentProgress = _progress;
    _progress = progress;
    [self changeValue:_progress];
    [CATransaction begin];
    if(animated) {
        float delta = fabs(_progress*2 - currentProgress);
        [CATransaction setAnimationDuration:MAX(0.2, delta * 0.3)];
    } else {
        [CATransaction setDisableActions:YES];
    }
    [[self spinLayer] setStrokeEnd:_progress];
    [[self spin2Layer] setStrokeEnd:_progress];
    [CATransaction commit];
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (float)radius
{
    CGRect r = CGRectInset([self bounds], [self wellThickness] / 2.0, [self wellThickness] / 2.0);
    float w = r.size.width;
    float h = r.size.height;
    if(w > h)
        return h / 2.0;
    
    return w / 2.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [self bounds];
    float wt = [self wellThickness];
    CGRect outer = CGRectInset([self bounds], wt / 2.0, wt / 2.0);
    CGRect inner = CGRectInset([self bounds], wt, wt);
    
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:inner];
    
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(outer), CGRectGetMidY(outer))
                                                             radius:[self radius]
                                                         startAngle:-M_PI_2
                                                           endAngle:(2.0 * M_PI - M_PI_2)
                                                          clockwise:YES];
    [[self wellLayer] setPath:[outerPath CGPath]];
    
    UIBezierPath *outerPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(outer), CGRectGetMidY(outer))
                                                              radius:[self radius]
                                                          startAngle:M_PI
                                                            endAngle:(1.0 * M_PI + M_PI)
                                                           clockwise:YES];
    
    [[self spinLayer] setPath:[outerPath1 CGPath]];
    
//    UIBezierPath *outerPath2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(outer), CGRectGetMidY(outer))
//                                                              radius:[self radius]
//                                                          startAngle:-M_PI_2
//                                                            endAngle:(2.0 * M_PI - M_PI_2)
//                                                           clockwise:NO];
//    
//    [[self spin2Layer] setPath:[outerPath2 CGPath]];
    
    
    [[self imageLayer] setFrame:bounds];
    [[self maskLayer] setFrame:bounds];
    [[self spinLayer] setFrame:bounds];
    [[self spin2Layer] setFrame:bounds];
    
    [self changeValue:self.progress];
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [[UIScreen mainScreen] scale]);
    [innerPath fill];
    [[self maskLayer] setContents:(id)[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
    
    UIGraphicsEndImageContext();
}


@end
