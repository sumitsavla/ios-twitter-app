//
//  ProfileViewController.h
//  mytwitter
//
//  Created by Savla, Sumit on 6/28/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) User *user;

@end
