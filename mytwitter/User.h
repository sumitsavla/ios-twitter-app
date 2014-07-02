//
//  User.h
//  mytwitter
//
//  Created by Savla, Sumit on 6/21/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) NSURL *profileBGImageUrl;
@property (nonatomic, strong) NSString *followersCount;
@property (nonatomic, strong) NSString *friendsCount;
@property (nonatomic, strong) NSString *tweetsCount;

+ (User *) currentUser;
+ (void) setCurrentUser:(User *) user;
+ (void) removeCurrentUser;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
