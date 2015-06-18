//
//  BrowseDetailViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "BrowseDetailViewController.h"
#import "JDFPeekabooCoordinator.h"
#import "FPPopoverController.h"
#import "UtilityViewController.h"

#import "BrowseDetailLikeViewController.h"
#import "BrowseDetailCommentViewController.h"
#import "BrowseDetailShareViewController.h"

#import "NotificationViewController.h"

#import "StoryAPIManager.h"

#import <objc/runtime.h>

@interface BrowseDetailViewController () <FPPopoverControllerDelegate>

@property (nonatomic, strong) NSMutableArray *imgsDetail;
@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
@property (nonatomic, strong) NSDictionary *dictStory;

@end

@implementation BrowseDetailViewController

- (void)viewDidLoad {
    [self initProps];
    [self setTableView];
    [self setScrollCoordinator];
}

- (void)initProps {
    self.imgsDetail = [[NSMutableArray alloc] init];
    self.dictStory = [[NSDictionary alloc] init];
}

- (void)setTableView {
    self.browseDetailTableView.delegate = self;
    self.browseDetailTableView.dataSource = self;
    self.browseDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setScrollCoordinator {
    self.topView.alpha = 0.8;
    self.bottomView.alpha = 0.8;
    
    self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
    self.scrollCoordinator.scrollView = self.browseDetailTableView;
    self.scrollCoordinator.bottomView = self.bottomView;
}

- (void)setVideoPlayer {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.player = [[VKVideoPlayer alloc] init];
    self.player.delegate = self;
    
    self.player.view.frame = CGRectMake(0, 54, width, 211);
    [self.view addSubview:self.player.view];
    
    [self playStream:[NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"]];

    self.player.forceRotate = YES;
    [self.player.view.fullscreenButton setHidden:NO];
    [self.player.view.rewindButton setHidden:NO];
    [self.player.view.videoQualityButton setHidden:NO];
    [self.player.view.topControlOverlay setHidden:YES];
    
}

- (void)playStream:(NSURL*)url {
    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
    track.hasNext = YES;
    [self.player loadVideoWithTrack:track];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    StoryAPIManager *apiStory = [StoryAPIManager sharedInstance];
    [self viewStory:apiStory];
}

- (void)viewStory: (StoryAPIManager *)apiStory {
    [apiStory viewStory:self.story_id success:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            self.dictStory = successResponse;
            [self updateImages:[self.dictStory objectForKeyedSubscript:@"photo"]];
            [self setVideoPlayer];
            [self updateTopView];
            [self updateBottomView];
            [self.browseDetailTableView reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: can't view a story");
    }];
}

- (void)updateImages:(NSArray *)imgURLs {
    [self.imgsDetail removeAllObjects];
    
    for(NSString *strURL in imgURLs){
        UIImage *image = [UtilityViewController getImageFromStringURL:strURL];
        [self.imgsDetail addObject:image];
    }
}

- (void)updateTopView {
    NSDictionary *dictUser = [self.dictStory objectForKey:@"user_profile"];
    // set name
    self.username = [dictUser objectForKey:@"user_name"];
    // set avatar
    NSURL *urlAvatar = [NSURL URLWithString:[dictUser objectForKey:@"avatar_url"]];
    self.imgAvatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlAvatar]];
    [UtilityViewController changeImgToCircle:self.imgAvatar];
    // set posted time
    NSString *strPostedDate = [self.dictStory objectForKey:@"shown_at"];
    NSString *strTime = [UtilityViewController getTimeFromEpoch:strPostedDate];
    self.postedDate.text = [NSString stringWithFormat:@"%@发布", strTime];
}

- (void)updateBottomView {
    self.likeCount.text = [[self.dictStory objectForKey:@"like_count"] stringValue];
    self.commentCount.text = [[self.dictStory objectForKey:@"comment_count"] stringValue];
    self.shareCount.text = [[self.dictStory objectForKey:@"share_count"] stringValue];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.imgsDetail != nil && [self.imgsDetail count] != 0){
        return [self.imgsDetail count] + 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return 254;
    }else{
        if(self.imgsDetail != nil && [self.imgsDetail count] != 0){
            UIImage *image = [self.imgsDetail objectAtIndex:indexPath.row - 1];
            return image.size.height/image.size.width * [UIScreen mainScreen].bounds.size.width;
        }else{
            return 254;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellTextIdentifier = @"browseDetailTextCell";
    static NSString *cellImageIdentifier = @"browseDetailImageCell";
    
    UITableViewCell *cell;
    
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:cellTextIdentifier];
        
        [self setTextCell:cell];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellImageIdentifier];
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1305];
        imageView.image = [self.imgsDetail objectAtIndex:indexPath.row - 1];
    }
    
    return cell;
}

- (void)setTextCell: (UITableViewCell *)cell {
    // questions and asker
    UILabel *qa = (UILabel *)[cell viewWithTag:1301];
    // title
    UILabel *title = (UILabel *)[cell viewWithTag:1302];
    // time and location
    UILabel *tl = (UILabel *)[cell viewWithTag:1303];
    // content
    UILabel *content = (UILabel *)[cell viewWithTag:1304];
    
    if(self.dictStory){
        NSString *question = [self.dictStory objectForKey:@"topic_content"];
        NSString *asker = [self.dictStory objectForKey:@"asker"];
        qa.text = [NSString stringWithFormat:@"“%@”@%@", question, asker];
        
        title.text = [self.dictStory objectForKey:@"title"];
        
        NSString *happened_at = [UtilityViewController getTimeFromEpoch:[self.dictStory objectForKey:@"happened_at"]];
        NSString *location = [self.dictStory objectForKey:@"location"];
        tl.text = [NSString stringWithFormat:@"%@·%@", happened_at, location];
        
        content.text = [self.dictStory objectForKey:@"content"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.browseDetailTableView){
        if(indexPath.row != 0){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:1305];
            
            UIImageView* ivExpand = [[UIImageView alloc] initWithImage: imageView.image];
            ivExpand.contentMode = imageView.contentMode;
            ivExpand.frame = [self.view convertRect: imageView.frame fromView: imageView.superview];
            
            ivExpand.userInteractionEnabled = YES;
            ivExpand.clipsToBounds = YES;
            
            objc_setAssociatedObject( ivExpand,
                                     "original_frame",
                                     [NSValue valueWithCGRect: ivExpand.frame],
                                     OBJC_ASSOCIATION_RETAIN);
            
            [UIView transitionWithView: self.view
                              duration: 1.0
                               options: UIViewAnimationOptionAllowAnimatedContent
                            animations:^{
                                [self.view addSubview: ivExpand];
                                ivExpand.frame = imageView.frame;
                                [ivExpand setCenter:self.view.center];
                                
                                [self.browseDetailTableView setHidden:YES];
                                [self.player.view setHidden:YES];
                                
                            } completion:^(BOOL finished) {
                                
                                UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector( onTap: )];
                                [ivExpand addGestureRecognizer: tgr];
                            }];
            
            
        }
    }
}

- (void) onTap: (UITapGestureRecognizer*) tgr
{
    [UIView animateWithDuration: 1.0
                     animations:^{
                         
                         tgr.view.frame = [objc_getAssociatedObject( tgr.view,
                                                                    "original_frame" ) CGRectValue];
                     } completion:^(BOOL finished) {
                         
                         [tgr.view removeFromSuperview];
                         [self.browseDetailTableView setHidden:NO];
                         [self.player.view setHidden:NO];
                     }];
}

- (void)showLikeView: (UIButton *)button {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BrowseDetailLikeViewController *likeView = [storyboard instantiateViewControllerWithIdentifier:@"BrowseDetailLikeView"];
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:likeView];
    
    [self setupPopoverView:popover];
    [popover presentPopoverFromView:button];
}

- (void)showCommentView: (UIButton *)button {
    BrowseDetailCommentViewController *commentView = [[BrowseDetailCommentViewController alloc] init];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:commentView];
    
    [self setupPopoverView:popover];
    [popover presentPopoverFromView:button];
}

- (void)showShareView: (UIButton *)button {
    BrowseDetailShareViewController *shareView = [[BrowseDetailShareViewController alloc] init];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:shareView];
    
    [self setupPopoverView:popover];
    [popover presentPopoverFromView:button];
}

- (void)setupPopoverView: (FPPopoverController *) popover {
    popover.contentSize = CGSizeMake(450, 580);
    popover.border = NO;
    popover.tint = FPPopoverWhiteTint;
}

- (IBAction)browseDetailLike:(UIButton *)sender {
    [self.browseDetailLikeBtn setBackgroundImage:[UIImage imageNamed:@"liked"] forState:UIControlStateHighlighted];
    [self showLikeView:self.browseDetailLikeBtn];
}

- (IBAction)browseDetailComment:(UIButton *)sender {
    [self showCommentView:self.browseDetailCommentBtn];
}

- (IBAction)browseDetailShare:(UIButton *)sender {
    [self showShareView:self.browseDetailShareBtn];
}

- (IBAction)goBackToNewsFeed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
