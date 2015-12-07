#import <UIKit/UIKit.h>

@interface STKSpinnerView : UIView
@property (nonatomic) float progress;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) float circleThickness;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic,strong) UILabel *percentLabel;
@property (nonatomic, strong) CAShapeLayer *firstCircleLayer;
@property (nonatomic, strong) CAShapeLayer *secondCircleLayer;
- (void)setProgress:(float)progress animated:(BOOL)animated;

-(void)setLabelWithPercent:(NSString *)msg;


@end
