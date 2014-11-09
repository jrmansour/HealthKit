//
//  RootViewController.m
//  
//
//  Created by Jahan on 21/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import "RootViewController.h"
#import "RESideMenu.h"

@implementation RootViewController

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.backgroundImage = [UIImage imageNamed:@"BackgroundMenu"];
    if (self.backgroundImage == nil) {
        NSLog(@"Failed to load background image");
    }
    self.delegate = self;
    
}
@end
