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

@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLocationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;

@property (weak, nonatomic) IBOutlet UIImageView *likeButtonImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeButtonLabel;

@property (weak, nonatomic) IBOutlet UIImageView *commentButtonImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) NSString *story_id;

@property FPPopoverController *popover;

@end

@implementation OwnTimeLineCell


- (void)awakeFromNib {
    // Initialization code

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

- (void)initStory:(Story *)story{
    self.story_id = story.story_id;
    self.postTitleLabel.text = story.title;
    self.postDescriptionLabel.text = story.content;
    self.postLocationLabel.text = story.location;
    //todo: load story image, download from storage
//    self.postImage.image =
    //missing: like count, review count
    self.likeButtonLabel.text = [NSString stringWithFormat:@"%i",story.like_count];
    self.commentButtonLabel.text = [NSString stringWithFormat:@"%i",story.comment_count];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd, LLL yyyy HH:mm:ss zzz"];
    NSDate *date = [dateFormatter dateFromString:story.shown_at];
    self.yearLabel.text = [self formatDate:date toFormat:@"yyyy年"];
    self.dayLabel.text =[self formatDate:date toFormat:@"M月dd日"];
}

- (NSString *) formatDate:(NSDate*)date toFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

- (void)setLiked:(BOOL)liked {
    
    if (liked) {
        
        _likeButtonImageView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        _likeButtonImageView.image = [UIImage imageNamed:@"liked"];
        
        [UIView animateWithDuration:0.2f animations:^{
            _likeButtonImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
        
    }
    else {
        _likeButtonImageView.image = [UIImage imageNamed:@"like"];
    }
    
    _liked = liked;
    
}

- (IBAction)likeButtonTapped:(id)sender {
    
    self.liked = !_liked;
    
    // You should put like API request here
    //
    if (self.liked) {
        
    }
    else {
        
    }
    
}

@end
