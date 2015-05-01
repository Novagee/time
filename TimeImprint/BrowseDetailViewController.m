//
//  BrowseDetailViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "BrowseDetailViewController.h"
#import "JDFPeekabooCoordinator.h"
#import "GUIPlayerView.h"
#import "FPPopoverController.h"

#import "BrowseDetailLikeViewController.h"
#import "BrowseDetailCommentViewController.h"
#import "BrowseDetailShareViewController.h"

#import "NotificationViewController.h"

#import <objc/runtime.h>

@interface BrowseDetailViewController () <GUIPlayerViewDelegate>

@property (nonatomic, strong) GUIPlayerView *playerView;
@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
@property (nonatomic, strong) NSMutableArray *imageNames;

@end

@implementation BrowseDetailViewController

- (void)viewDidLoad {
    self.browseDetailTableView.delegate = self;
    self.browseDetailTableView.dataSource = self;
    
    self.topView.delegate = self;
    self.topView.dataSource = self;
    
    self.topView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.browseDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
    self.scrollCoordinator.scrollView = self.browseDetailTableView;
    self.scrollCoordinator.topView = self.topView;
    self.scrollCoordinator.bottomView = self.bottomView;
    
    self.imageNames = [[NSMutableArray alloc] initWithObjects:@"photo01.png", @"photo02.png", @"photo03.png", @"photo04.png", nil];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.playerView = [[GUIPlayerView alloc] initWithFrame:CGRectMake(0, 0, width, 211)];
    [self.playerView setDelegate:self];
    
    [[self view] insertSubview:self.playerView belowSubview:self.topView];
    
    NSURL *URL = [NSURL URLWithString:@"http://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4"];
    [self.playerView setVideoURL:URL];
    [self.playerView prepareAndPlayAutomatically:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
    static NSString *topCellIdentifier = @"topViewCell";
    
    UITableViewCell *cell;
    if (tableView == self.browseDetailTableView){
        if(indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:cellTextIdentifier];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:cellImageIdentifier];
            
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:1201];
            imageView.image = [UIImage imageNamed:[self.imageNames objectAtIndex:(indexPath.row - 1)]];
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:topCellIdentifier];
        
        UIButton *backBtn = (UIButton *)[cell viewWithTag:1210];
        [backBtn addTarget:self action:@selector(goBackToBrowseView) forControlEvents:UIControlEventTouchUpInside];
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
                                [self.playerView setHidden:YES];
                                
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
                         [self.playerView setHidden:NO];
                     }];
}

- (void)showLikeView: (UIButton *)button {
    BrowseDetailLikeViewController *likeView = [[BrowseDetailLikeViewController alloc] init];
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

- (void)goBackToBrowseView {
    [self.playerView stop];
    [self.playerView setDelegate:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
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
@end
