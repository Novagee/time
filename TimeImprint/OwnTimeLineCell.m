//
//  OwnTimeLineCell.m
//  TimeImprint
//
//  Created by Paul on 4/20/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "OwnTimeLineCell.h"

@interface OwnTimeLineCell ()

@property (weak, nonatomic) IBOutlet UILabel *postDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLocationLabel;

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
    
}

+ (NSString *)reuseIdentifier {
    
    return @"OwnTimeLineCell";
    
}

@end
