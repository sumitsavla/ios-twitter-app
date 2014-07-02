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
#import "loginViewController.h"
#import "ProfileViewController.h"
#import "User.h"

@interface TweetsViewController ()
{
    UIRefreshControl *refreshControl;
    UIBarButtonItem *menuButton;
    UIBarButtonItem *postButton;
}

@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong, nonatomic) NSArray *tweets;
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
    
    menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButton:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(onPostButton:)];
    self.navigationItem.rightBarButtonItem = postButton;
    self.navigationItem.title = @"Home";
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading Latest Tweets..."];
    [refreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];
    [self.tweetsTableView addSubview:refreshControl];
    
    [self loadTweets];

}

- (void) loadTweets {
    TwitterClient *client = [TwitterClient instance];
    if (self.initType == HOME) {
        [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id response){
         //   NSLog(@"homeTimelineWithSuccess response %@", response);
            NSLog(@"NO. of tweets ... %i",self.tweets.count);
            self.tweets = [Tweet tweetsWithArray:response];
            [self.tweetsTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"homeTimelineWithSuccess response err %@", error);
        }];
    } else if (self.initType == MENTIONS) {
        [client mentionsTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id response){
         //   NSLog(@"mentionsTimelineWithSuccess response %@", response);
            NSLog(@"NO. of tweets ... %i",self.tweets.count);
            self.tweets = [Tweet tweetsWithArray:response];
            [self.tweetsTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"mentionsTimelineWithSuccess response err");
        }];

    }
}

- (void)refreshTweets {
    [refreshControl endRefreshing];
    [self loadTweets];
}

- (IBAction)onMenuButton:(id)sender {
    NSLog(@"on Menu");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickMenu" object:nil];
}

- (void) signoutUser {
    [User removeCurrentUser];
    loginViewController *lvc = [[loginViewController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (IBAction)onPostButton:(id)sender {
    ComposeTweetViewController *ctvc = [[ComposeTweetViewController alloc] init];
    ctvc.user = [User currentUser];
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

-(IBAction)onProfileImgTap:(UITapGestureRecognizer *)tap{
    Tweet *tweetUser = self.tweets[tap.view.tag];
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.userInfo = tweetUser;
    [self.navigationController pushViewController:pvc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileImgTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    cell.profileImage.tag = indexPath.row;
    [cell.profileImage addGestureRecognizer:tapGestureRecognizer];
    
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
