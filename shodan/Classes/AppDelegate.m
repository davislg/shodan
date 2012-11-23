//
//  AppDelegate.m
//  Shodan
//
//  Created by Erran Carey on 5/6/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import "AppDelegate.h"
#import "AppSpecificValues.h"
#import "BannerViewController.h"
#import "DetailViewController.h"
#import "MasterViewController.h"

@implementation AppDelegate{
    UISplitViewController *_splitViewController;
    BannerViewController *_bannerViewController;
}

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSString* model = [NSString stringWithFormat:@"%@",[UIDevice currentDevice].model];
    if ([model isEqualToString:@"iPad"]){
		self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
        self.window.backgroundColor = [UIColor blackColor];
        
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];

        MasterViewController *masterViewController = [sb instantiateViewControllerWithIdentifier:@"master"];
        UINavigationController *masterNavigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController]autorelease];
        
        DetailViewController *detailViewController = [sb instantiateViewControllerWithIdentifier:@"detail"];
        UINavigationController *detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:detailViewController]autorelease];
        
        masterViewController.navigationController.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"carbon_bg"]];
        detailViewController.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        
        masterViewController.detailViewController = detailViewController;
        
        _splitViewController = [[[UISplitViewController alloc]init]autorelease];
        _splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        //_splitViewController.delegate = self;
        _splitViewController.delegate = detailViewController;
        
        _bannerViewController = [[BannerViewController alloc] initWithContentViewController:_splitViewController];
        self.window.rootViewController = _bannerViewController;
        [self.window makeKeyAndVisible];
        return YES;
    }
    else {
        return NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	MasterViewController *mvc = [[[MasterViewController alloc] init]autorelease];

	[mvc performSelectorInBackground:@selector(queryAPI) withObject:mvc];//	[self performSelectorInBackground:@selector(searchShodan) withObject:self];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	MasterViewController *mvc = [[[MasterViewController alloc] init]autorelease];

	[mvc performSelectorInBackground:@selector(queryAPI) withObject:mvc];//	[self performSelectorInBackground:@selector(searchShodan) withObject:self];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end