//
//  HamburgerViewController.m
//  mytwitter
//
//  Created by Savla, Sumit on 6/28/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "HamburgerViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "User.h"

@interface HamburgerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *options;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) TweetsViewController *homeViewController;
@property (nonatomic, strong) TweetsViewController *mentionsViewController;

@property (nonatomic, strong) ProfileViewController *profileViewController;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation HamburgerViewController

static float openMenuPosition = 250;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.homeViewController = [[TweetsViewController alloc] init];
        self.homeViewController.initType = HOME;
        self.mentionsViewController = [[TweetsViewController alloc] init];
        self.mentionsViewController.initType = MENTIONS;
        self.profileViewController  = [[ProfileViewController alloc] init];
    //    [self.profileViewController setUser:[User currentUser]];
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Menu viewDidLoad");
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    [self.contentView addSubview:self.navigationController.view];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onViewPan:)];
    [self.contentView addGestureRecognizer:panGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickMenu) name:@"clickMenu" object:nil];
    [self.menuTableView setSeparatorInset:UIEdgeInsetsZero];
    self.options = [NSMutableArray arrayWithObjects: @"Profile", @"Timeline", @"Mentions", @"Sign Out", nil];
    [self.menuTableView reloadData];
}

- (void)onViewPan:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint point    = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.origin = CGPointMake(point.x - self.contentView.frame.origin.x, point.y - self.contentView.frame.origin.y);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        float xPos = (point.x - self.origin.x);
        if (xPos < 0) {
            xPos = 0;
        }
        if (xPos > openMenuPosition) {
            xPos = openMenuPosition;
        }
        self.contentView.frame = CGRectMake( xPos, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        float destinationXPos = (velocity.x > 0) ? openMenuPosition : 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.contentView.frame = CGRectMake( destinationXPos, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        }];
        [self configEvents];
    }
}

- (void)configEvents{
    BOOL isMenuOpen = self.contentView.frame.origin.x == 0;
    [self.contentView.subviews[0] setUserInteractionEnabled:isMenuOpen];
    self.tapGestureRecognizer.enabled = !isMenuOpen;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.options[indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)clickMenu{
    if (self.tapGestureRecognizer == nil) {
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenu)];
        self.tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.contentView addGestureRecognizer:self.tapGestureRecognizer];
    }
    
    float xPos = (self.contentView.frame.origin.x == 0) ? openMenuPosition : 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.frame = CGRectMake( xPos, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }];
    [self configEvents];
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"%i", indexPath.row);
    
    switch (indexPath.row) {
        case 0:
            self.profileViewController.user = User.currentUser;
            
            [self.navigationController pushViewController:self.profileViewController animated:YES];
            break;
        case 1:
            [self.navigationController setViewControllers:@[self.homeViewController] animated:YES];
            break;
        case 2:
            [self.navigationController setViewControllers:@[self.mentionsViewController] animated:YES];
            break;
        case 3:
            break;
        default:
            break;
    }
    
    [self clickMenu];
    
}


@end
