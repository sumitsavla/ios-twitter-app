//
//  TweetViewCell.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/21/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "TweetViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "MHPrettyDate.h"

@interface TweetViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *screenLbl;
@property (weak, nonatomic) IBOutlet UILabel *tweetLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (strong, nonatomic) NSCalendar* calendar;

@end


@implementation TweetViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
    [self reloadData];
}

- (void)reloadData
{
    self.profileImage.image = nil;
    
    [self.profileImage setImageWithURL:self.tweet.profileImageUrl];
    
    self.profileImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.profileImage.layer.borderWidth = 1.5;
    // Set image corner radius
    self.profileImage.layer.cornerRadius = 7.0;
    // To enable corners to be "clipped"
    [self.profileImage setClipsToBounds:YES];
    
    self.nameLbl.text = self.tweet.name;
    self.screenLbl.text = self.tweet.screenName;
    self.tweetLbl.text = self.tweet.tweetText;
    self.timeLbl.text = [MHPrettyDate prettyDateFromDate:self.tweet.createdAt withFormat:MHPrettyDateShortRelativeTime];

}

@end
