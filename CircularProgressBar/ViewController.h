//
//  ViewController.h
//  CircularProgressBar
//
//  Created by Manish Verma on 2/18/14.
//  Copyright (c) 2014 Manish Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STKSpinnerView.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet STKSpinnerView *spinnerView;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@end
