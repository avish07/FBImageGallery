//
//  AppDelegate.h
//  FBImageGallery
//
//  Created by gh on 4/13/17.
//  Copyright © 2017 Slack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL isPan;
@property (nonatomic) NSInteger imgIndex;

+(AppDelegate *)appDelegate;

@end

