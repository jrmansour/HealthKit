//
//  GraphViewController.h
//  test-healthk-kit
//
//  Created by Jahan on 28/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController<CPTPlotDataSource, UIActionSheetDelegate>

@property (weak, nonatomic) CPTGraphHostingView *graphHostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;


- (NSNumber*) getYValueFromDict: (NSDictionary*)dict;
- (CPTPlotRange*) getYPlotRange;
- (void)doThemeTapped:(id)sender;
-(CPTColor*)getLineColor;
-(CPTColor*)getAreaColorTop;
-(CPTColor*)getAreaColorBottom;

-(NSDecimal)getAreaBaseValue;
-(NSDecimal)getAreaBaseValue2;

@end
