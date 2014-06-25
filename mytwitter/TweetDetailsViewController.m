//
//  TweetDetailsViewController.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/23/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import <UIImageView+AFNetworking.h>

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImg;
@property (weak, nonatomic) IBOutlet UILabel *tweetLbl;
@property (weak, nonatomic) IBOutlet UILabel *tweetTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *favCountLbl;
@property (weak, nonatomic) IBOutlet UIImageView *replyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *retweetBtn;
@property (weak, nonatomic) IBOutlet UIImageView *favBtn;

@end

@implementation TweetDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.userProfileImg setImageWithURL:self.selectedTweet.profileImageUrl];
    
    self.userProfileImg.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.userProfileImg.layer.borderWidth = 1.5;
    self.userProfileImg.layer.cornerRadius = 7.0;
    self.userNameLbl.text = self.selectedTweet.name;
    self.userHandleLbl.text = self.selectedTweet.screenName;
    self.tweetLbl.text = self.selectedTweet.tweetText;
    self.navigationItem.title = @"Tweet";
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
