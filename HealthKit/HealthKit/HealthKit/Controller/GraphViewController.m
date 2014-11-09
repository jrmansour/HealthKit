//
//  GraphViewController.m
//  test-healthk-kit
//
//  Created by Jahan on 28/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import "GraphViewController.h"
#import "AppDelegate.h"

@interface GraphViewController ()

@property NSArray* selectedValues;
@property (nonatomic, strong) NSTimer* chartUpdateTimer;

@end

@implementation GraphViewController

#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initPlot];
    self.chartUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    [self.chartUpdateTimer fire];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.chartUpdateTimer invalidate];
}

-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - IBActions
-(void)doThemeTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Apply a Theme" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:CPDThemeNameDarkGradient, CPDThemeNamePlainBlack, CPDThemeNamePlainWhite, CPDThemeNameSlate, CPDThemeNameStocks, nil];
   
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [actionSheet showInView:self.view];
    } else {
        [actionSheet showInView:window];
    }
    
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    [self loadData];
    
}

-(CPTPlotRange*)getYPlotRange {
    return nil; // to be implemented by subclasses;
}

-(void)loadData {
    NSTimeInterval timeInterval = 5;
    
    // get new values from the data model
    self.selectedValues = [dataModel getLastestValues: timeInterval];
    //NSLog(@"Selected values size %lu", (unsigned long)[self.selectedValues count]);
    
    // update the graph
    CPTGraph* graph = self.graphHostView.hostedGraph;
    [graph reloadData];
    
    // update the X-range of the graph
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval currentTime = [dataModel getTimeInSec];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(currentTime - timeInterval) length:CPTDecimalFromDouble(timeInterval)];
    
    // update the Y-range of the graph
    plotSpace.yRange = [self getYPlotRange];
}

-(void)configureGraph {
    // Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.graphHostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.graphHostView.hostedGraph = graph;
    
    // Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:40.0f];
    [graph.plotAreaFrame setPaddingBottom:10.0f];
    [graph.plotAreaFrame setPaddingTop:10.0f];
}


-(CPTColor*)getLineColor{
    return nil;//must be implemented in subclass
}

-(CPTColor*)getAreaColorTop{
    return nil;//must be implemented in subclass
}


-(CPTColor*)getAreaColorBottom{
    return nil;//must be implemented in subclass
}

-(void)configurePlots {
    // Get graph and plot space
    CPTGraph *graph = self.graphHostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    // Create the plot
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
    plot.dataSource = self;
    plot.identifier = @"EKGPlot";
    [graph addPlot:plot toPlotSpace:plotSpace];
    
    // Setup line style for the plot
    CPTMutableLineStyle *plotLineStyle = [plot.dataLineStyle mutableCopy];
    plotLineStyle.lineWidth = 3;
    plotLineStyle.lineColor = [self getLineColor];
    plot.dataLineStyle = plotLineStyle;
    
    // Setup gradient fill for the plot
    CPTColor *areaColor       = [self getAreaColorBottom];

    
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    areaGradient.angle = -90.0;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    plot.areaFill      = areaGradientFill;
    plot.areaBaseValue = [self getAreaBaseValue];
    
    areaColor                         = [self getAreaColorTop];
    
    areaGradient                      = [CPTGradient gradientWithBeginningColor:[CPTColor clearColor] endingColor:areaColor];
    areaGradient.angle                = -90.0;
    areaGradientFill                  = [CPTFill fillWithGradient:areaGradient];
    plot.areaFill2      = areaGradientFill;
    plot.areaBaseValue2 = [self getAreaBaseValue2];
}

-(NSDecimal)getAreaBaseValue{
    return CPTDecimalFromCGFloat(0.0);// must be implemented in subclass
}
-(NSDecimal)getAreaBaseValue2{
    return CPTDecimalFromCGFloat(0.0); //must be implemented in subclass
}

-(void)configureAxes {
    // Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.graphHostView.hostedGraph.axisSet;
    
    // Hide X axis
    CPTAxis *x = axisSet.xAxis;
    x.hidden = YES;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    // Configure Y axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    y.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
    y.minorTicksPerInterval       = 3;
    y.labelOffset                 = 5.0;
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];
    
    // Y label formatting
    NSNumberFormatter *Yformatter = [[NSNumberFormatter alloc] init];
    [Yformatter setGeneratesDecimalNumbers:NO];
    [Yformatter setNumberStyle:NSNumberFormatterDecimalStyle];
    y.labelFormatter = Yformatter;
}


#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.selectedValues count];
}

- (NSNumber*) getYValueFromDict: dict {
    return nil; // to be implemented in subclasses
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSDictionary* entry = [self.selectedValues objectAtIndex:index];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
        return [entry valueForKey:@"time"];
        
        case CPTScatterPlotFieldY:
        return [self getYValueFromDict: entry];
    }
    return [NSDecimalNumber zero];
}


#pragma mark - UIActionSheetDelegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 1 - Get title of tapped button
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    // 2 - Get theme identifier based on user tap
    NSString *themeName = kCPTPlainWhiteTheme;
    if ([title isEqualToString:CPDThemeNameDarkGradient] == YES) {
        themeName = kCPTDarkGradientTheme;
    } else if ([title isEqualToString:CPDThemeNamePlainBlack] == YES) {
        themeName = kCPTPlainBlackTheme;
    } else if ([title isEqualToString:CPDThemeNamePlainWhite] == YES) {
        themeName = kCPTPlainWhiteTheme;
    } else if ([title isEqualToString:CPDThemeNameSlate] == YES) {
        themeName = kCPTSlateTheme;
    } else if ([title isEqualToString:CPDThemeNameStocks] == YES) {
        themeName = kCPTStocksTheme;
    }
    // 3 - Apply new theme
    [self.graphHostView.hostedGraph applyTheme:[CPTTheme themeNamed:themeName]];
}


@end
