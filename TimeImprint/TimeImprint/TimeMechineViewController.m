//
//  TimeMechineViewController.m
//  TimeImprint
//
//  Created by Paul on 4/23/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "TimeMechineViewController.h"
#import "Session.h"

@interface TimeMechineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *storyCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deletedStoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *deletedStoryLabel;

@end

@implementation TimeMechineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.storyCountLabel.text = [NSString stringWithFormat:@"%i",[Session sharedInstance].user.story_count];
    self.deletedStoryLabel.text = [NSString stringWithFormat:@"%i",[Session sharedInstance].user.deleted_story_count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)backButtonTouchUpInside:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
