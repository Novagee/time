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

#import "BrowseDetailLikeViewController.h"
#import "BrowseDetailCommentViewController.h"
#import "BrowseDetailShareViewController.h"

#import "NotificationViewController.h"

#import <objc/runtime.h>

@interface BrowseDetailViewController () <FPPopoverControllerDelegate>

@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
@property (nonatomic, strong) NSMutableArray *imageNames;

@end

@implementation BrowseDetailViewController

- (void)viewDidLoad {
    [self setTableView];
    [self setScrollCoordinator];
    [self setVideoPlayer];
    
    self.imageNames = [[NSMutableArray alloc] initWithObjects:@"photo01.png", @"photo02.png", @"photo03.png", @"photo04.png", nil];
}

- (void)setVideoPlayer {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.player = [[VKVideoPlayer alloc] init];
    self.player.delegate = self;
    
    self.player.view.frame = CGRectMake(0, 0, width, 211);
    [self.view addSubview:self.player.view];
    
    [self playStream:[NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/VfE_html5.mp4"]];
    
    [self.player.view.rewindButton setHidden:NO];
    [self.player.view.videoQualityButton setHidden:NO];
    [self.player.view.topControlOverlay setHidden:YES];
    
    // put under topview
    [[self view] insertSubview:self.player.view belowSubview:self.topView];
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

- (void)setTableView {
    self.browseDetailTableView.delegate = self;
    self.browseDetailTableView.dataSource = self;
    self.browseDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setScrollCoordinator {
    self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
    self.scrollCoordinator.scrollView = self.browseDetailTableView;
    self.scrollCoordinator.topView = self.topView;
    self.scrollCoordinator.bottomView = self.bottomView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.browseDetailTableView) {
        return [self.imageNames count] + 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.browseDetailTableView){
        if(indexPath.row == 0) {
            return 254;
        }else{
            UIImage *image = [UIImage imageNamed:[self.imageNames objectAtIndex:(indexPath.row - 1)]];
            return image.size.height;
        }
    }else if(tableView == self.topView) {
        return 54;
    }else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellTextIdentifier = @"browseDetailTextCell";
    static NSString *cellImageIdentifier = @"browseDetailImageCell";
    
    UITableViewCell *cell;
    
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:cellTextIdentifier];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellImageIdentifier];
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1201];
        imageView.image = [UIImage imageNamed:[self.imageNames objectAtIndex:(indexPath.row - 1)]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.browseDetailTableView){
        if(indexPath.row != 0){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:1201];
            
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
