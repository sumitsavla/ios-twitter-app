//
//  AppDelegate.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/20/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "AppDelegate.h"
#import "loginViewController.h"
#import "HamburgerViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "TweetsViewController.h"

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    
    return dictionary;
}

@end

@interface AppDelegate()

@property (nonatomic) UINavigationController *navigationController;
@property UIBarButtonItem *leftButton;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if(User.currentUser == nil){
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[loginViewController alloc]init]];
        self.window.rootViewController = self.navigationController;

    } else {
        self.window.rootViewController = [[HamburgerViewController alloc]init];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) getCurrentUser {
    TwitterClient *client = [TwitterClient instance];
    
    [client userInfoWithSuccess:^(AFHTTPRequestOperation *operation, id response){
        User *user = [[User alloc]init];
        user = [[User alloc]init];
        user.name = response[@"name"];
        user.screenName = response[@"screen_name"];
        user.profileImageUrl = [NSURL URLWithString:response[@"profile_image_url"]];
        user.profileBGImageUrl = [NSURL URLWithString:response[@"profile_banner_url"]];
        [User setCurrentUser:user];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"userInfoWithSuccess response err");
    }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"mytwitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]){
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    NSLog(@"access token");
                    [self getCurrentUser];
                    [client.requestSerializer saveAccessToken:accessToken];
                    TweetsViewController *tvc = [[TweetsViewController alloc] init];
                    [self.navigationController pushViewController:tvc animated:YES];
                } failure:^(NSError *error) {
                    NSLog(@"access token error");
                }];
            }
        }
                 
        return YES;
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
