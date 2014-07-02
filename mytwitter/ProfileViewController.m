//
//  ProfileViewController.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/28/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetViewCell.h"
#import "TwitterClient.h"
#import "TweetDetailsViewController.h"
#import <UIImageView+AFNetworking.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *screenLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong, nonatomic) NSArray *tweets;
@property (nonatomic, strong) TweetViewCell *prototypeCell;

@end

@implementation ProfileViewController

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
    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;
    [self.tweetsTableView registerNib:[UINib nibWithNibName:@"TweetViewCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.prototypeCell = [self.tweetsTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    [self.profileImg setImageWithURL:self.user.profileImageUrl];
    self.profileImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImg.layer.borderWidth = 5.0;
    // Set image corner radius
    self.profileImg.layer.cornerRadius = 25.0;
    // To enable corners to be "clipped"
    [self.profileImg setClipsToBounds:YES];
    if(self.user.profileBGImageUrl != nil){
        [self.bgImg setImageWithURL:self.user.profileBGImageUrl];
    } else {
        [self.nameLbl setTextColor: [UIColor blackColor]];
        [self.screenLbl setTextColor: [UIColor blackColor]];
    }
    self.nameLbl.text = self.user.name;
    self.screenLbl.text = self.user.screenName;
    
    [self loadTweets];
}

- (void) loadTweets {
    TwitterClient *client = [TwitterClient instance];
    [client userTimelineWithSuccess:self.user.screenName success:^(AFHTTPRequestOperation *operation, id response){
        //   NSLog(@"userTimelineWithSuccess response %@", response);
        NSLog(@"NO. of tweets ... %i",self.tweets.count);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tweetsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"userTimelineWithSuccess response err");
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    Tweet *tweet = self.tweets[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TweetDetailsViewController *tdvc = [[TweetDetailsViewController alloc]init];
    tdvc.selectedTweet = tweet;
    [self.navigationController pushViewController:tdvc animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.prototypeCell.tweet = self.tweets[indexPath.row];
    [self.prototypeCell layoutSubviews];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
