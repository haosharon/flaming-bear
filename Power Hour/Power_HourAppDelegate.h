//
//  Power_HourAppDelegate.h
//  Power Hour
//
//  Created by Sharon Hao on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Power_HourViewController;

@interface Power_HourAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Power_HourViewController *viewController;

@end
