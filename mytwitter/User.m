//
//  User.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/21/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

@implementation User

static User* _currentUser = nil;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.screenName forKey:@"screenName"];
    [encoder encodeObject:self.profileImageUrl forKey:@"profileImageURL"];
    [encoder encodeObject:self.profileBGImageUrl forKey:@"profileBGImageUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.screenName = [decoder decodeObjectForKey:@"screenName"];
        self.profileImageUrl = [decoder decodeObjectForKey:@"profileImageURL"];
        self.profileBGImageUrl = [decoder decodeObjectForKey:@"profileBGImageUrl"];
    }
    return self;
}

+ (User *) currentUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(!_currentUser){
        NSData *data = [defaults dataForKey:@"current_user"];
        if (data) {
            User *currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            _currentUser = currentUser;
        }
    }
    return _currentUser;
}


+ (void) setCurrentUser:(User *) user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(!_currentUser){
        _currentUser = user;
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:user];
        [defaults setObject:data forKey:@"current_user"];
        [defaults synchronize];
    } else{ 
        [self removeCurrentUser];
    }
    
    [defaults synchronize];
}

+ (void)removeCurrentUser{
    _currentUser = nil;
    [[TwitterClient instance]removeAccessToken];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"current_user"];
    [defaults synchronize];
}

@end


