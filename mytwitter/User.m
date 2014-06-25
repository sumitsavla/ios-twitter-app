//
//  User.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/21/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;

+ (User *) currentUser {
    if (currentUser == nil) {
        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        if (dictionary) {
//            currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return currentUser;
}

+ (void) setCurrentUser:(User *) user {
    currentUser = user;
}
@end
