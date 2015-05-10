//
//  AppDelegate.m
//  Beginning OpenGL ES 2
//
//  Created by Jhonathan Wyterlin on 10/05/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>

@interface AppDelegate ()<GLKViewDelegate,GLKViewControllerDelegate> {
    
    float _curRed;
    BOOL _increasing;
    
}

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    EAGLContext * context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.context = context;
    view.delegate = self;
    
    _increasing = YES;
    _curRed = 0.0;
    
    GLKViewController * viewController = [[GLKViewController alloc] initWithNibName:nil bundle:nil];
    viewController.view = view;
    viewController.delegate = self;
    viewController.preferredFramesPerSecond = 60;
    self.window.rootViewController = viewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

-(void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - GLKViewDelegate methods

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(_curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
}

#pragma mark - GLKViewControllerDelegate methods

-(void)glkViewControllerUpdate:(GLKViewController *)controller {
    
    if ( _increasing ) {
        _curRed += 1.0 * controller.timeSinceLastUpdate;
    } else {
        _curRed -= 1.0 * controller.timeSinceLastUpdate;
    }
    
    if ( _curRed >= 1.0 ) {
        _curRed = 1.0;
        _increasing = NO;
    }
    
    if ( _curRed <= 0.0 ) {
        _curRed = 0.0;
        _increasing = YES;
    }
    
}

@end
