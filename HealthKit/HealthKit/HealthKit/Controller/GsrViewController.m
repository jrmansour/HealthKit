//
//  GsrViewController.m
//  test-healthk-kit
//
//  Created by Jahan on 29/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import "GsrViewController.h"

@interface GsrViewController ()

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *themeButton;

-(IBAction)themeTapped:(id)sender;

@end

@implementation GsrViewController

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
    return  [CPTColor colorWithComponentRed:0 green:1 blue:0.305 alpha:1];
    
}

-(CPTColor*)getAreaColorTop{
    return [CPTColor colorWithComponentRed:0.16 green:0.68 blue:0.305 alpha:0.8];
    
}
-(CPTColor*)getAreaColorBottom{
    return [CPTColor colorWithComponentRed:0.16 green:0.68 blue:0.305 alpha:0.5];
    
}


-(NSDecimal)getAreaBaseValue{
    return CPTDecimalFromDouble(-1.5);
    
    
}
-(NSDecimal)getAreaBaseValue2{
    return CPTDecimalFromDouble(1.5);
}



#pragma mark - IBActions
-(IBAction)themeTapped:(id)sender {
    [self doThemeTapped: sender];
}

- (NSNumber*) getYValueFromDict: (NSDictionary*)dict {
   NSDictionary* conDic = [dict valueForKey:@"GSR"];
    //NSLog(@"value for cond:%@",[conDic valueForKey:@"Con"]);
    return [conDic valueForKey:@"Con"];
}

- (CPTPlotRange*) getYPlotRange {
    return [CPTPlotRange plotRangeWithLocation: CPTDecimalFromDouble(-1) length: CPTDecimalFromDouble(2)];
}

@end
