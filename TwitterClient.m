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

- (void)toggleFavoriteForTweet:(Tweet *)tweet success:(void (^)(Tweet *))success failure:(void (^)(NSError *))failure
{
    NSString* resource;
    if (!tweet.favourited) {
        resource = @"1.1/favorites/destroy.json";
        
    } else {
        resource = @"1.1/favorites/create.json";
        
    }
    
    NSNumberFormatter * tId = [[NSNumberFormatter alloc] init];
    [tId setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * tweetIDnum = [tId numberFromString:tweet.tweetid];
    NSDictionary *params = @{@"id":tweetIDnum };
    
    
    
    [self POST:resource parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if (success) success(tweet);
        }
        else {
            if (failure) failure([NSError errorWithDomain:@"Post Tweet" code:400 userInfo:nil]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}

@end
