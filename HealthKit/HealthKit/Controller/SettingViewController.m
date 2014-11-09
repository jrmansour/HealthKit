//
//  SettingsViewController.m
//  test-healthk-kit
//
//  Created by Soh on 29.09.14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingViewController.h"
#import "AppDelegate.h"
//#import "CanDataModel.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ipInput;
@property (strong, nonatomic) IBOutlet UITextField *canUrl;


@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@end

@implementation SettingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.loader startAnimating];
    
    self.loadingView.clipsToBounds = YES;
    self.loadingView.layer.masksToBounds = YES;
    self.loadingView.layer.cornerRadius = 5;
    self.loadingView.hidden = YES;
    
    NSString* healthKitURL = [dataModel urlToUse];
    NSString* canUrl = [canDataModel urlToUse];
    if(healthKitURL != nil) {
        self.ipInput.text = healthKitURL;
        self.canUrl.text = canUrl;
    }
}
- (IBAction)cancel:(id)sender {
    [self.ipInput resignFirstResponder];
    self.loadingView.hidden = YES;
}

- (IBAction)saveSettings:(id)sender {
    if([self.ipInput.text rangeOfString:@"http://"].location == NSNotFound){
        UIAlertView *wrongUrl = [[UIAlertView alloc] initWithTitle:@"Wrong Url"
            message:@"The ip adress should begin with http://" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [wrongUrl show];
    } else {
        self.loadingView.hidden = NO;
        [[NSUserDefaults standardUserDefaults] setValue:self.ipInput.text forKey:@"healthKitURL"];
        [[NSUserDefaults standardUserDefaults] setValue:self.canUrl.text forKey:@"speedUrl"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
            self.loadingView.alpha = 0;
        } completion:nil];
        [dataModel loadSettings];
        [canDataModel loadSettings];
    }
}


@end
