//
//  STKSpinnerView.m
//  Spyndle
//
//  Created by Joe Conway on 4/19/13.
//

#import "STKSpinnerView.h"
#import <QuartzCore/QuartzCore.h>
//
//  ViewController.m
//  CircularProgressBar
//
//  Created by Manish Verma on 2/18/14.
//  Copyright (c) 2014 Manish Verma. All rights reserved.
//

#import "ViewController.h"
#import "CircularView.h"

@interface ViewController () {
    CircularView* m_CircularView;
    NSTimer* m_timer;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    // Init our view
    [super viewDidLoad];
    //    m_CircularView = [[CircularView alloc] initWithFrame:self.spinnerView.bounds];
    //    m_CircularView.percent = 100;
    //    [self.view addSubview:m_CircularView];
    [self.spinnerView  setLabelWithPercent:@"50"];
    // [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(spinit:) userInfo:nil repeats:YES];
}

- (void)spinit:(NSTimer *)timer
{
    static float prog = 0.0;
    prog += 0.03;
    if(prog >= 0.7) {
        prog = 0.7;
        [timer invalidate];
    }
    [[self spinnerView] setProgress:prog animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // Kick off a timer to count it down
    //    m_timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(decrementSpin) userInfo:nil repeats:YES];
}

- (void)decrementSpin
{
    // If we can decrement our percentage, do so, and redraw the view
    if (m_CircularView.percent > 0) {
        m_CircularView.percent = m_CircularView.percent - 1;
        [m_CircularView setNeedsDisplay];
    }
    else {
        [m_timer invalidate];
        m_timer = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



