//
//  LMErrorKitExample_iOSAppDelegate.h
//  LMErrorKitExample_iOS
//
//  Created by Jose Vazquez on 4/19/11.
//  Copyright 2011 Little Mustard LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMErrorKitExample_iOSViewController;

@interface LMErrorKitExample_iOSAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet LMErrorKitExample_iOSViewController *viewController;

@end
