//
//  FirstViewController.m
//  
//
//  Created by Jahan on 10/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"

#import "F3BarGauge.h"
#import "WMGaugeView.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface FirstViewController ()

@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView;
@property (strong, nonatomic) IBOutlet F3BarGauge *verticalBar;
@property (nonatomic, strong) NSTimer* updateTimer;

@end


@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // configure the stress level bar
    self.verticalBar.minLimit = [dataModel getMinStressValue];
    self.verticalBar.maxLimit = [dataModel getMaxStressValue];
    
    // setup the speedometer
    self.gaugeView.minValue = canDataModel.minSpeedValue;
    self.gaugeView.maxValue = canDataModel.maxSpeedValue;
    self.gaugeView.rangeValues = @[ [NSNumber numberWithFloat: canDataModel.maxSpeedValue] ];
    self.gaugeView.rangeColors = @[ RGB(170, 170, 170) ];
    self.gaugeView.showRangeLabels = YES;
    self.gaugeView.unitOfMeasurement = @"Speed";
    self.gaugeView.showUnitOfMeasurement = YES;
    self.gaugeView.scaleDivisionsWidth = 0.008;
    self.gaugeView.scaleSubdivisionsWidth = 0.006;
    self.gaugeView.rangeLabelsFontColor = [UIColor blackColor];
    self.gaugeView.rangeLabelsWidth = 0.04;
    self.gaugeView.rangeLabelsFont = [UIFont fontWithName:@"Helvetica" size:0.04];
    
    //self.gaugeView.showInnerBackground = YES;
    self.gaugeView.showInnerRim = YES;
    self.gaugeView.showScale = YES;
    self.gaugeView.showScaleShadow = YES;
}

//the updateTimer get activated to call the updateData function, initialized with timeInterval 1(every 1seconds)
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
    [self.updateTimer fire];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.updateTimer invalidate];
}

//This method calls the
-(void)updateData {
    // update the stress level
    self.verticalBar.value = [dataModel getCurrentStressValue];
    
    // update the speedometer
    self.gaugeView.value = [canDataModel getCurrentSpeedValue];
    NSLog(@"current value for Stress: %f", [dataModel getCurrentStressValue]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}




@end
