//
//  AirFlowViewController.m
//
//
//  Created by Jahan on 10/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import "AirFlowViewController.h"

@interface AirFlowViewController ()

@property (nonatomic, strong) IBOutlet UIBarButtonItem *themeButton;
-(IBAction)themeTapped:(id)sender;
@property (strong, nonatomic)   IBOutlet CPTGraphHostingView *hostView;

@end

@implementation AirFlowViewController

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
    //return  [CPTColor colorWithComponentRed:0.345 green:0.741 blue:0.949 alpha:1];
    return [CPTColor whiteColor];
    
}

-(CPTColor*)getAreaColorTop{
    return [CPTColor colorWithComponentRed:0.145 green:0.741 blue:0.949 alpha:0.8];;
    
}
-(CPTColor*)getAreaColorBottom{
    return [CPTColor colorWithComponentRed:0.145 green:0.741 blue:0.949 alpha:0.6];;
    
}



#pragma mark - IBActions
-(IBAction)themeTapped:(id)sender {
    [self doThemeTapped: sender];
}

- (NSNumber*) getYValueFromDict: (NSDictionary*)dict {
    return [dict valueForKey:@"AIR"];
}

- (CPTPlotRange*) getYPlotRange {
    return [CPTPlotRange plotRangeWithLocation: CPTDecimalFromDouble(-1) length: CPTDecimalFromDouble(1100)];
}

//top shadow
-(NSDecimal)getAreaBaseValue{
    return CPTDecimalFromDouble(0);
    
    
}

//under shadow
-(NSDecimal)getAreaBaseValue2{
    return CPTDecimalFromDouble(1000);
}





@end
