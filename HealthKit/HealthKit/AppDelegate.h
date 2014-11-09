//
//  AppDelegate.h
//  
//
//  Created by Jahan on 10/09/14.
//  Copyright (c) 2014 Jahan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "CanDataModel.h"

//singleton Objects
DataModel* dataModel;
CanDataModel* canDataModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
