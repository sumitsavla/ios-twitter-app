//
//  TwitterClient.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/20/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+ (TwitterClient *) instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"dwJwjg9iwKowfEMC9wHcNTFR3" consumerSecret:@"tfJ7lxJlaoM0NmHRZdDJIHZHmSh5dYEqtdxY28EYWQZAJqmbG6"];
    });
    
    return instance;
}

- (void) login {
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"mytwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Req token success");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Req token failuer %@", error);
    }];
}

- (AFHTTPRequestOperation *) homeTimelineWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"count": @"20", @"exclude_replies" : @true};

    return [self GET:@"1.1/statuses/home_timeline.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *) userInfoWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *) postStatus:(NSString *)status success: (void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSDictionary *parameters = @{@"status": status};

    return [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}

@end
