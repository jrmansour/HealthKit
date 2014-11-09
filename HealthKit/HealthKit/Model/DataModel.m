//
//  DataModel.m
//  test-healthk-kit
//
//  Created by macbook on 25.09.14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//comment

#define urlOfArduino @"http://192.168.0.16"
#define urlOfRaspbery @"http://192.168.178.14/rawData"]
#define urlLocalhost @"http://localhost:8888/index.php"
#define urlHomeComputer @"http://192.168.178.57/json/"



#define defaultUrlToUse urlLocalhost

#define requestInterval 0.1 //raspbery uses 0.1 to refresh sensor data

#import "DataModel.h"

#define DEFAULT_MIN_GSR_CON_VALUE 0
#define DEFAULT_MAX_GSR_CON_VALUE 1

#define DEFAULT_MIN_TEMP_VALUE 35 //degree
#define DEFAULT_MAX_TEMP_VALUE 45

#define DEFAULT_MIN_AIR_VALUE 0
#define DEFAULT_MAX_AIR_VALUE 1024

#define DEFAULT_MIN_EKG_VALUE 0
#define DEFAULT_MAX_EKG_VALUE 1// 0-5 for Raspbery, 0-1 for Arduino


@interface DataModel()

@property(nonatomic, strong) NSMutableArray* allValues;
@property BOOL waitingForRequest;

@end

@implementation DataModel

- (DataModel*) init {
    NSLog(@"init");
    if (self = [super init]) {
        self.waitingForRequest = NO;
        self.allValues = [NSMutableArray new];
        [self scheduleNextServerRequest];
        
        // initialize configuration with defaults for sensor values
        self.minGsrConValue = DEFAULT_MIN_GSR_CON_VALUE;
        self.maxGsrConValue = DEFAULT_MAX_GSR_CON_VALUE;
        self.minAirFlowValue = DEFAULT_MIN_AIR_VALUE;
        self.maxAirFlowValue = DEFAULT_MAX_AIR_VALUE;
        self.minEcgValues = DEFAULT_MIN_EKG_VALUE;
        self.maxEcgValue = DEFAULT_MAX_EKG_VALUE;
        self.minTempValue = DEFAULT_MIN_TEMP_VALUE;
        self.maxTempValue = DEFAULT_MAX_EKG_VALUE;
        
        self.urlToUse = defaultUrlToUse;
        [self loadSettings];
    }
    return self;
}

- (void)loadSettings {
    // get the url of server from the setting screen
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* healthKitURL = [defaults valueForKey:@"healthKitURL"];
    if (healthKitURL != nil) {
        self.urlToUse = healthKitURL;
    }
}

/**************** Methods For Fetching And Parsing JSON File *********************************/

- (void)fetchData {
   /* if (self.waitingForRequest) {
        //NSLog(@"Skipping scheduled request - another request is not finished yet");
        return;
    } */
    //self.waitingForRequest = YES;
    NSLog(@"Fetching data from %@", self.urlToUse);
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
                 NSDictionary* sensorsDict = [json valueForKey:@"Sensors"];
                 NSMutableDictionary* sensorsNew = [sensorsDict mutableCopy];
                 id time = [NSNumber numberWithDouble:[self getTimeInSec]];
                 [sensorsNew setValue:time forKey:@"time"];
                 NSLog(@"Data set received for Sensors: %@", sensorsNew);
                 [self.allValues addObject: sensorsNew];
                 
                 // cleanup old values from array
                 if([self.allValues count] > 600){
                     NSLog(@"size of allValue befor Release: %i", [self.allValues count]);

                     NSRange range = NSMakeRange(0, 500);
                     [self.allValues removeObjectsInRange: range];
                     
                     NSLog(@"size of allValue after Release: %i", [self.allValues count]);

                 }
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

-(NSTimeInterval) getTimeInSec {
    return [[NSDate date] timeIntervalSinceReferenceDate];
}

- (NSArray *) getLastestValues: (NSTimeInterval) timeInterval {
    NSTimeInterval currentTime = [self getTimeInSec];
    NSTimeInterval startTime = currentTime - timeInterval;
    NSMutableArray* selectedValues = [[NSMutableArray alloc] init];
    NSUInteger cnt = [self.allValues count];
    for (NSUInteger i = 0; i < cnt; ++i) {
        NSDictionary* dict = [self.allValues objectAtIndex:i];
        if ([[dict valueForKey: @"time"] doubleValue] > startTime) {
            [selectedValues addObject:dict];
        }
    }
    return selectedValues;
}


-(void) scheduleNextServerRequest {
    NSLog(@"scheduleNextServerRequest");
    NSTimer* timer = [NSTimer timerWithTimeInterval:requestInterval target:self selector: @selector(fetchData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: timer forMode:NSDefaultRunLoopMode];
}
/**************** Methods For Fetching And Parsing JSON File*******************/



/**************** Calculate Stress Level **************************************/
- (float) getMinStressValue {
    return 0.0;
}

- (float) getMaxStressValue {
    return 1.0;
}

//get current stress Values from sensors and normalize the value to calculate the average
- (float) getCurrentStressValue {
    NSDictionary* lastSensorValues = [self.allValues lastObject];
    float gsrValue = [[[lastSensorValues valueForKey:@"GSR"] valueForKey:@"Con"] floatValue];
    float normalizedGsrValue = [self normalizedValueFor:gsrValue withMin: self.minGsrConValue withMax: self.maxGsrConValue];
 /*
    float ecgValue =[[lastSensorValues valueForKey:@"KG"] floatValue];
    float normalizedEcgValue = [self normalizedValueFor:ecgValue withMin:self.minEcgValues withMax:self.maxTempValue]; */
    
    float tempValue = [[lastSensorValues valueForKey:@"TMP"]floatValue];
    float normalizedTempValue = [ self normalizedValueFor:tempValue withMin:self.minTempValue withMax:self.maxTempValue];
    
    //int airFlowValue = [[lastSensorValues valueForKey:@"AIR"]intValue];
    //float normalizedAirFlowValue = [self normalizedValueFor:airFlowValue withMin:self.minAirFlowValue withMax:self.maxAirFlowValue];
    
    
    
    return (normalizedGsrValue + normalizedTempValue) / 2;
    

}

- (float) normalizedValueFor:(float) value withMin: (float) minValue withMax: (float) maxValue {
    float normalizedValue = (value - minValue) / (maxValue - minValue);
    if (normalizedValue > 1) {
        normalizedValue = 1;
    }
    if (normalizedValue < 0) {
        normalizedValue = 0;
    }
    return normalizedValue;
}
/******************* End Of Calculate Stress Level******************************/



@end
