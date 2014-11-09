//
//  CanDataModel.h
//  test-healthk-kit
//
//  Created by Jahan on 30/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CanDataModel : NSObject

- (CanDataModel*) init;
- (float) getCurrentSpeedValue;
-(void)loadSettings;

// configuration
@property float minSpeedValue;
@property float maxSpeedValue;
@property (nonatomic, strong) NSString* urlToUse;

@end
