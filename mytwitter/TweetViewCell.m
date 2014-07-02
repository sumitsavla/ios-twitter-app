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
#import "TwitterClient.h"
#import "ComposeTweetViewController.h"
#import "ProfileViewController.h"

@interface TweetViewCell ()
@property (strong, nonatomic) TwitterClient *client;
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
    if (self.tweet.retweeted) {
        [self.retweetBtn setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    }
    if (self.tweet.favourited) {
        [self.favBtn setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    }
    
    [self.retweetBtn addTarget:self action:@selector(retweetButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.favBtn addTarget:self action:@selector(favButtonClicked:) forControlEvents:UIControlEventTouchDown];
    
}

- (void) retweetButtonClicked:(id)sender {
    TwitterClient *client = [TwitterClient instance];
    [client retweet:self.tweet.tweetid success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.retweetBtn setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
        self.tweet.retweeted = !self.tweet.retweeted;
        NSLog(@"ReTweet Success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(self.tweet.retweeted){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Already Retweeted"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
            [alert show];
        }
        NSLog(@"ReTweet Failure");
    }];
}

- (void) favButtonClicked: (id)sender {
    if(!self.tweet.favourited){
        TwitterClient *client = [TwitterClient instance];
        [client favoriteOn:self.tweet.tweetid success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.favBtn setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
            self.tweet.favourited = !self.tweet.favourited;
            NSLog(@"favoriteOn Success");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favoriteOn Failure");
        }];
    } else {
        TwitterClient *client = [TwitterClient instance];
        [client favoriteOff:self.tweet.tweetid success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.favBtn setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
            self.tweet.favourited = !self.tweet.favourited;
            NSLog(@"favoriteOff Success");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favoriteOff Failure");
        }];
    }
}


@end
