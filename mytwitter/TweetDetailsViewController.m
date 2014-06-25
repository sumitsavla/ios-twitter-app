//
//  TweetDetailsViewController.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/23/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"
#import "ComposeTweetViewController.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImg;
@property (weak, nonatomic) IBOutlet UILabel *tweetLbl;
@property (weak, nonatomic) IBOutlet UILabel *tweetTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *favCountLbl;

@property (weak, nonatomic) IBOutlet UIButton *retwtBtn;
@property (weak, nonatomic) IBOutlet UIButton *favBtn;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;

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
    self.retweetCountLbl.text = self.selectedTweet.retweetCount;
    self.favCountLbl.text = self.selectedTweet.favCount;
    self.navigationItem.title = @"Tweet";
    
    if (self.selectedTweet.retweeted) {
        [self.retwtBtn setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    }
    if (self.selectedTweet.favourited) {
        [self.favBtn setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    }

}
- (IBAction)favAction:(id)sender {
    TwitterClient *client = [TwitterClient instance];
    if(!self.selectedTweet.favourited){
        [client favoriteOn:self.selectedTweet.tweetid success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.favBtn setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
            self.selectedTweet.favourited = !self.selectedTweet.favourited;
            NSLog(@"favoriteOn Success");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favoriteOn Failure");
        }];
    } else {
        [client favoriteOff:self.selectedTweet.tweetid success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self.favBtn setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
                self.selectedTweet.favourited = !self.selectedTweet.favourited;
                NSLog(@"favoriteOn Success");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favoriteOn Failure");
        }];
    }
}
- (IBAction)replyAction:(id)sender {
    ComposeTweetViewController *ctvc = [[ComposeTweetViewController alloc] init];
    ctvc.replyTo = self.selectedTweet.screenName;
    [self.navigationController pushViewController:ctvc animated:YES];

}

- (IBAction)retweetAction:(id)sender {
    TwitterClient *client = [TwitterClient instance];
    [client retweet:self.selectedTweet.tweetid success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.retwtBtn setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
        self.selectedTweet.retweeted = !self.selectedTweet.retweeted;
        NSLog(@"ReTweet Success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(self.selectedTweet.retweeted){
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
