//
//  DataModel.h
//  test-healthk-kit
//
//  Created by macbook on 25.09.14.
//  Copyright (c) 2014 Jahan. All rights reserved.

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

- (DataModel*) init;
- (NSArray *) getLastestValues: (NSTimeInterval) timeInterval;
- (NSTimeInterval) getTimeInSec;

- (float) getCurrentStressValue;
- (float) getMinStressValue;
- (float) getMaxStressValue;

- (void) loadSettings;

// configuration
@property (nonatomic, strong) NSString* urlToUse;

@property float minGsrConValue;
@property float maxGsrConValue;

@property float minEcgValues;
@property float maxEcgValue;

@property float minTempValue;
@property float maxTempValue;

@property int minAirFlowValue;
@property int maxAirFlowValue;

@end
