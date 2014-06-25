//
//  TweetsViewController.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/21/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetViewCell.h"
#import "TweetDetailsViewController.h"
#import "ComposeTweetViewController.h"
#import "TwitterClient.h"
#import "User.h"

@interface TweetsViewController ()
{
    UIRefreshControl *refreshControl;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *postButton;
}

@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) User *user;
@property (nonatomic, strong) TweetViewCell *prototypeCell;

@end

@implementation TweetsViewController

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
    
    leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLeftButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(onPostButton:)];
    self.navigationItem.rightBarButtonItem = postButton;
    self.navigationItem.title = @"Home";
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading Latest Tweets..."];
    [refreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];
    [self.tweetsTableView addSubview:refreshControl];

}

- (void) viewDidAppear:(BOOL)animated {
    [self loadTweets];
    
    TwitterClient *client = [TwitterClient instance];
    [client userInfoWithSuccess:^(AFHTTPRequestOperation *operation, id response){
    //    NSLog(@"userInfoWithSuccess response %@", response);
        self.user = [[User alloc]init];
        self.user.name = response[@"name"];
        self.user.screenName = response[@"screen_name"];
        self.user.profileImageUrl = [NSURL URLWithString:response[@"profile_image_url"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"userInfoWithSuccess response err");
    }];
}

- (void) loadTweets {
    TwitterClient *client = [TwitterClient instance];
    [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id response){
            NSLog(@"homeTimelineWithSuccess response %@", response);
        NSLog(@"NO. of tweets ... %i",self.tweets.count);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tweetsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"homeTimelineWithSuccess response err");
    }];
}

- (void)refreshTweets {
    [refreshControl endRefreshing];
    [self loadTweets];
}

- (IBAction)onLeftButton:(id)sender {
    
    
}

- (IBAction)onPostButton:(id)sender {
    ComposeTweetViewController *ctvc = [[ComposeTweetViewController alloc] init];
    ctvc.user = self.user;
    [self.navigationController pushViewController:ctvc animated:YES];
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
}

@end
