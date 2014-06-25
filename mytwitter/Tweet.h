//
//  Tweet.h
//  mytwitter
//
//  Created by Savla, Sumit on 6/21/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tweetid;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic) BOOL favourited;
@property (nonatomic) BOOL retweeted;
@property (nonatomic, strong) NSString *tweetText;
@property (nonatomic, strong) NSDate *createdAt;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
