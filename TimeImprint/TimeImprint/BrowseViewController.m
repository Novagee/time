//
//  BrowseViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/12/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "BrowseViewController.h"
#import "MainViewController.h"
#import "UtilityViewController.h"
#import "TimelineAPIManager.h"
#import "StoryAPIManager.h"

@interface BrowseViewController ()

@property (strong, nonatomic) NSNumber *numFeeds;
@property (strong, nonatomic) NSMutableArray *aStories;

@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.browseTableView.delegate = self;
    self.browseTableView.dataSource = self;
    
    // dismiss the separator line
    self.browseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.aStories = [[NSMutableArray alloc] init];
    self.numFeeds = @5;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TimelineAPIManager *apiTimeline = [TimelineAPIManager sharedInstance];
    [self getNewsFeed:apiTimeline];
}

- (void)getNewsFeed:(TimelineAPIManager *)apiTimeline {
    [apiTimeline getNewsFeedWithStoryId:@"" limit:self.numFeeds success:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            [self.aStories removeAllObjects];
            [self.aStories addObjectsFromArray:[successResponse objectForKey:@"stories"]];
            
            [self.browseTableView reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Get news feed failure");
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    ((MainViewController *)self.tabBarController).lockScreenRotation = YES;    
    
    [self rotateDeviceOrientation:UIInterfaceOrientationPortrait];
    
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark - Rotation Methods

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

- (void)rotateDeviceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[UIDevice currentDevice]setValue:@(interfaceOrientation) forKey:@"orientation"];
    [[UIApplication sharedApplication]setStatusBarOrientation:interfaceOrientation];
}

// table view
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.aStories count];
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"browseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *dictStory = [self.aStories objectAtIndex:indexPath.row];
    
    if(dictStory){
        [self setCell:cell withStory:dictStory];
    }
    
    return cell;
}

- (void)setCell: (UITableViewCell *) cell
      withStory: (NSDictionary *) dictStory {
    // get UI components from storyboard
    UILabel *title = (UILabel *)[cell viewWithTag:1101];
    UIImageView *imgVideoPreview = (UIImageView *)[cell viewWithTag:1102];
    UILabel *content = (UILabel *)[cell viewWithTag:1103];
    UIButton *btnUser = (UIButton *)[cell viewWithTag:1104];
    UIButton *btnLike = (UIButton *)[cell viewWithTag:1105];
    UILabel *likeCount = (UILabel *)[cell viewWithTag:1106];
    UILabel *commentCount = (UILabel *)[cell viewWithTag:1107];
    UILabel *userName = (UILabel *)[cell viewWithTag:1108];
    
    // set UI components with story
    title.text = [dictStory objectForKey:@"title"];
    
    content.text = [dictStory objectForKey:@"content"];
    likeCount.text = [[dictStory objectForKey:@"like_count"] stringValue];
    commentCount.text = [[dictStory objectForKey:@"comment_count"] stringValue];
    
    // set user info
    NSDictionary *dictUser = [dictStory objectForKey:@"user_profile"];
    if(dictUser){
        NSURL *urlAvatar = [NSURL URLWithString:[dictUser objectForKey:@"avatar_url"]];
        UIImage *imgAvatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlAvatar]];
        [btnUser setImage:imgAvatar forState:UIControlStateNormal];
        [UtilityViewController changeBtnToCircle:btnUser];
        userName.text = [dictUser objectForKey:@"user_name"];
    }
    
    NSIndexPath *indexPath = [self.browseTableView indexPathForCell:cell];
    
    // set like button
    UIImage *imgLike = [UIImage imageNamed:@"like.png"];
    [btnLike setImage:imgLike forState:UIControlStateNormal];
    UIImage *imgLiked = [UIImage imageNamed:@"liked.png"];
    [btnLike setImage:imgLiked forState:UIControlStateSelected];
    btnLike.tag = btnLike.tag + indexPath.row;
    [btnLike addTarget:self action:@selector(onLikeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onLikeButtonPress:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    NSInteger index = sender.tag - 1105;
    
    NSString *storyID = [[self.aStories objectAtIndex:index] objectForKey:@"story_id"];
    StoryAPIManager *apiStory = [StoryAPIManager sharedInstance];
    
    UITableViewCell *cell = [self.browseTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UILabel *likeCount = (UILabel *)[cell viewWithTag:1106];
    NSInteger nLikeCount = [likeCount.text integerValue];
    
    if(button.selected){
        [self likeStory:storyID withAPI:apiStory];
        likeCount.text = [NSString stringWithFormat:@"%ld", nLikeCount + 1];
    }else{
        [self unlikeStory:storyID withAPI:apiStory];
        likeCount.text = [NSString stringWithFormat:@"%ld", nLikeCount - 1];
    }
}

- (void)likeStory: (NSString *)storyID
           withAPI: (StoryAPIManager *) apiStory {
    [apiStory likeStory:storyID success:^(id successResponse) {
        NSLog(@"Successfully like a story");
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: can't like a story");
    }];
}

- (void)unlikeStory :(NSString *)storyID
        withAPI: (StoryAPIManager *) apiStory {
    [apiStory unlikeStory:storyID success:^(id successResponse) {
        NSLog(@"Successfully unlike a story");
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: can't unlike a story");
    }];
}

@end
