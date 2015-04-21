//
//  OwnTimeLineCell.m
//  TimeImprint
//
//  Created by Paul on 4/20/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "OwnTimeLineCell.h"
#import "ArticleEditingViewController.h"
#import <FPPopover/FPPopoverController.h>

@interface OwnTimeLineCell ()

@property (weak, nonatomic) IBOutlet UILabel *postDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;

@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;

@property FPPopoverController *popover;

@end

@implementation OwnTimeLineCell


- (void)awakeFromNib {
    // Initialization code
    NSArray *viewsToRemove = [self.imagesScrollView subviews];
    for (UIView *subviewElement in viewsToRemove) {
        [subviewElement removeFromSuperview];
    }
    
    UIImageView *img1= [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 120, 90)];
    img1.image=[UIImage imageNamed:@"spring"];
    [img1.image stretchableImageWithLeftCapWidth:120 topCapHeight:100];
    
    UIImageView *img2= [[UIImageView alloc] initWithFrame:CGRectMake(130, 12, 120, 90)];
    img2.image=[UIImage imageNamed:@"spring"];
    [img2.image stretchableImageWithLeftCapWidth:120 topCapHeight:100];
    
    UIImageView *img3= [[UIImageView alloc] initWithFrame:CGRectMake(260, 12, 120, 90)];
    img3.image=[UIImage imageNamed:@"spring"];
    [img3.image stretchableImageWithLeftCapWidth:120 topCapHeight:100];
    
    UIImageView *img4= [[UIImageView alloc] initWithFrame:CGRectMake(390, 12, 120, 90)];
    img4.image=[UIImage imageNamed:@"spring"];
    [img4.image stretchableImageWithLeftCapWidth:120 topCapHeight:100];
    
    UIImageView *img5= [[UIImageView alloc] initWithFrame:CGRectMake(520, 12, 120, 90)];
    img5.image=[UIImage imageNamed:@"spring"];
    [img5.image stretchableImageWithLeftCapWidth:120 topCapHeight:100];
    
    [self.imagesScrollView addSubview:img1];
    [self.imagesScrollView addSubview:img2];
    [self.imagesScrollView addSubview:img3];
    [self.imagesScrollView addSubview:img4];
    [self.imagesScrollView addSubview:img5];
    
    self.imagesScrollView.contentSize= CGSizeMake((self.imagesScrollView.frame.size.width*2) , self.imagesScrollView.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)optionTapped:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    ArticleEditingViewController *controller = (ArticleEditingViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ArticleEditingViewController"];
    controller.title = nil;
    //TODO: HAVE TO ADJUST POPOVER POSITION
    self.popover = [[FPPopoverController alloc] initWithViewController:controller];
    self.popover.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 200);
    self.popover.arrowDirection = FPPopoverArrowDirectionDown;
    self.popover.border = NO;
    self.popover.tint = FPPopoverWhiteTint;
    [self.popover presentPopoverFromView:self.optionButton];

}
- (void)dealloc{
    [self.popover dismissPopoverAnimated:YES];
}

+ (NSString *)reuseIdentifier {
    
    return @"OwnTimeLineCell";
    
}

@end
