//
//  TwitterClient.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/20/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

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

- (AFHTTPRequestOperation *) mentionsTimelineWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"count": @"20"};
    
    return [self GET:@"1.1/statuses/mentions_timeline.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *) userTimelineWithSuccess:(NSString *)screenName success: (void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *parameters = @{@"screen_name": screenName};
    
    return [self GET:@"1.1/statuses/user_timeline.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *) userInfoWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *) postStatus:(NSString *)status success: (void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSDictionary *parameters = @{@"status": status};

    return [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *) retweet:(NSString *)tweetid success: (void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetid] parameters:nil success:success failure:failure];
}

- (void) removeAccessToken {
    [self.requestSerializer removeAccessToken];
}

- (AFHTTPRequestOperation *) favoriteOn:(NSString *)tweetid success: (void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSNumberFormatter * tid = [[NSNumberFormatter alloc] init];
    [tid setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * tweetIdNo = [tid numberFromString:tweetid];
    NSDictionary *parameters = @{@"id": tweetIdNo};
    
    
    return [self POST:@"1.1/favorites/create.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *) favoriteOff:(NSString *)tweetid success: (void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSNumberFormatter * tid = [[NSNumberFormatter alloc] init];
    [tid setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * tweetIdNo = [tid numberFromString:tweetid];
    NSDictionary *parameters = @{@"id": tweetIdNo};
    
    
    return [self POST:@"1.1/favorites/destroy.json" parameters:parameters success:success failure:failure];
}

@end
