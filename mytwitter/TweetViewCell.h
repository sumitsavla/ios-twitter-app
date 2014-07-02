//
//  TweetViewCell.h
//  mytwitter
//
//  Created by Savla, Sumit on 6/21/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetViewCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *screenLbl;
@property (weak, nonatomic) IBOutlet UILabel *tweetLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *retweetBtn;
@property (weak, nonatomic) IBOutlet UIButton *favBtn;

@end
