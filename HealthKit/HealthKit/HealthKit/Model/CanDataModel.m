//
//  CanDataModel.m
//  test-healthk-kit
//
//  Created by Jahan on 30/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//
#import "CanDataModel.h"
#define DEFAULT_MIN_SPEED_VALUE 0
#define DEFAULT_MAX_SPEED_VALUE 240

#define requestInterval 0.5
#define defaultUrlToUse urlLocalhost

#define urlLocalhost @"http://localhost:8888/i.php"


@interface CanDataModel()

@property(nonatomic, strong) NSDictionary* currentValue;
//@property BOOL waitingForRequest;


@end


@implementation CanDataModel


- (CanDataModel*) init {
    NSLog(@"init");
    if (self = [super init]) {
        //self.waitingForRequest = NO;
        self.currentValue = nil;
        [self scheduleNextServerRequest];
        
        // initialize configuration with defaults for sensor values
        self.minSpeedValue = DEFAULT_MIN_SPEED_VALUE;
        self.maxSpeedValue = DEFAULT_MAX_SPEED_VALUE;
        
        //set url for canDataModel
        self.urlToUse = defaultUrlToUse;
        [self loadSettings];
    }
    return self;
}

- (void)loadSettings {
    // get the url of server from the setting screen
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* healthKitURL = [defaults valueForKey:@"speedUrl"];
    if (healthKitURL != nil) {
        self.urlToUse = healthKitURL;
    }
}

/**************** Methods For Fetching And Parsing JSON File *********************************/

- (void)fetchData {
   /* if (self.waitingForRequest) {
        NSLog(@"Skipping scheduled request - another request is not finished yet");
        return;
    } */
    
    //self.waitingForRequest = YES;
   // NSLog(@"Fetching speed data from %@",self.urlToUse);
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL: [NSURL URLWithString: self.urlToUse]];
    [urlRequest setHTTPMethod: @"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *connError)
     {
         if ([responseData length] > 0 && connError == nil) {
             NSError* jsonError;
             NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:& jsonError];
             if (!json) {
                 NSLog(@"Error parsing JSON: %@", jsonError);
             } else {
                 NSLog(@"Data set received for canJson:%@", json);
                 id mps = [[json valueForKey:@"CAN"]valueForKey:@"MPS"];
                 NSLog(@"Mps value is:%@", mps);
                 if([json valueForKey:@"CAN"] != nil )
                     self.currentValue = [json valueForKey:@"CAN"];
                 else self.currentValue = 0;
             }
         }
         else if ([responseData length] == 0 && connError == nil) {
             NSLog(@"No data received");
         }
         else if (connError!= nil) {
             NSLog(@"Error: %@", connError);
             if (response != nil) {
                 NSLog(@"Response: %@", response);
             }
             if (responseData != nil) {
                 NSLog(@"ResponseData: %@", responseData);
             }
         }
         //self.waitingForRequest = NO;
     }];
} //end of fetchData


-(void) scheduleNextServerRequest {
    NSLog(@"scheduleNextServerRequest");
    NSTimer* timer = [NSTimer timerWithTimeInterval:requestInterval target:self selector: @selector(fetchData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: timer forMode:NSDefaultRunLoopMode];
}
/**************** End Of Methods Of Fetching And Parsing JSON File*******************/



- (float) getCurrentSpeedValue{
    if (self.currentValue == nil) {
        return self.minSpeedValue;
    } else {
        return [self mileToKilometer: [[self.currentValue valueForKey:@"MPS"] floatValue]];
    }
}

-(float)mileToKilometer:(float)mile{
    return  mile * 3.6;
}

@end
