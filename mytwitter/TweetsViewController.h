//
//  TweetsViewController.h
//  mytwitter
//
//  Created by Savla, Sumit on 6/21/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import <UIKit/UIKit.h>

enum TimelineType {
    HOME,
    MENTIONS
};
typedef enum TimelineType initType;

@interface TweetsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) enum TimelineType initType;

@end
