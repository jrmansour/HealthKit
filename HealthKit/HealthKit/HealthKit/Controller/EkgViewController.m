//
//  EkgViewController.m
//  
//
//  Created by Jahan on 10/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import "EkgViewController.h"
#import "AppDelegate.h"

@interface EkgViewController ()

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *themeButton;

-(IBAction)themeTapped:(id)sender;

@end

@implementation EkgViewController

-(void)viewDidAppear:(BOOL)animated {
    self.graphHostView = self.hostView;
    [super viewDidAppear:animated];
}

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
    return  [CPTColor redColor];
    
}

-(CPTColor*)getAreaColorTop{
    return [CPTColor colorWithComponentRed:1.13 green:0.0 blue:0.129 alpha:0.9];

}
-(CPTColor*)getAreaColorBottom{
    return [CPTColor colorWithComponentRed:1.13 green:0.0 blue:0.129 alpha:0.6];

}


//top shadow
-(NSDecimal)getAreaBaseValue2{
    return CPTDecimalFromDouble(5.0);
}

//bottom shadow
-(NSDecimal)getAreaBaseValue{
    return CPTDecimalFromDouble(-1);
}


#pragma mark - IBActions
-(IBAction)themeTapped:(id)sender {
    [self doThemeTapped: sender];
}

- (NSNumber*) getYValueFromDict: (NSDictionary*)dict {
    return [dict valueForKey:@"ECG"];
}

- (CPTPlotRange*) getYPlotRange {
    return [CPTPlotRange plotRangeWithLocation: CPTDecimalFromDouble(-1) length: CPTDecimalFromDouble(7)];
}

@end
