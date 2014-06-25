//
//  Tweet.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/21/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)tweet {
    self = [super init];
    if (self) {
        self.name = tweet[@"user"][@"name"];
        self.screenName =  [NSString stringWithFormat:@"@%@", tweet[@"user"][@"screen_name"]];
        self.profileImageUrl = [NSURL URLWithString:tweet[@"user"][@"profile_image_url"]];
        self.tweetText = tweet[@"text"];
        self.favourited = [tweet[@"favorited"] boolValue];
        self.retweeted = [tweet[@"retweeted"] boolValue];
        self.tweetid = tweet[@"id_str"];
        self.retweetCount = [NSString stringWithFormat:@"%@", tweet[@"retweet_count"]];
        self.favCount = [NSString stringWithFormat:@"%@", tweet[@"favorite_count"]];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"E MMM dd HH:mm:ss Z yyyy"];
        NSDate *date = [df dateFromString: tweet[@"created_at"]];
        self.createdAt = date;
    }
    
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    
    return tweets;
}


@end
