//
//  TempViewController.m
//  test-healthk-kit
//
//  Created by Jahan on 29/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import "TempViewController.h"

@interface TempViewController ()
@property (nonatomic, strong) IBOutlet UIBarButtonItem *themeButton;
-(IBAction)themeTapped:(id)sender;
@property (strong, nonatomic)   IBOutlet CPTGraphHostingView *hostView;

@end

@implementation TempViewController


-(void)viewDidLoad{
    self.graphHostView = self.hostView;
    [super viewDidLoad];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.graphHostView = self.hostView;
    }
    return self;
}

-(CPTColor*)getLineColor{
    return  [CPTColor colorWithComponentRed:0.93 green:0.55 blue:0.30 alpha:1];
    
}

-(CPTColor*)getAreaColorTop{
    return [CPTColor colorWithComponentRed:0.93 green:0.55 blue:0.30 alpha:0.9];
    
}
-(CPTColor*)getAreaColorBottom{
    return [CPTColor colorWithComponentRed:0.93 green:0.55 blue:0.30 alpha:0.5];
    
}


-(NSDecimal)getAreaBaseValue{
    return CPTDecimalFromDouble(0.0);
    
    
}
-(NSDecimal)getAreaBaseValue2{
    return CPTDecimalFromDouble(50.0);
}



#pragma mark - IBActions
-(IBAction)themeTapped:(id)sender {
    [self doThemeTapped: sender];
}

- (NSNumber*) getYValueFromDict: (NSDictionary*)dict {
    return [dict valueForKey:@"TMP"];
}

- (CPTPlotRange*) getYPlotRange {
    return [CPTPlotRange plotRangeWithLocation: CPTDecimalFromDouble(-1) length: CPTDecimalFromDouble(50)];
}

@end
