//
//  ComposeTweetViewController.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/22/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"

@interface ComposeTweetViewController ()
{
    UIBarButtonItem *tweetButton;
}
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *userScreenLbl;
@property (weak, nonatomic) IBOutlet UITextView *textViewLbl;

@end

@implementation ComposeTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.userImg setImageWithURL:self.user.profileImageUrl];
    
    self.userImg.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.userImg.layer.borderWidth = 1.5;
    self.userImg.layer.cornerRadius = 7.0;
    self.userNameLbl.text = self.user.name;
    self.userScreenLbl.text = self.user.screenName;
    [self.textViewLbl becomeFirstResponder];

}

- (IBAction)onTweetButton:(id)sender {
    TwitterClient *client = [TwitterClient instance];
    [client postStatus:self.textViewLbl.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Tweet Success");
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Tweet Failure");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
