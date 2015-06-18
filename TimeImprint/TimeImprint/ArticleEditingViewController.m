//
//  ArticleEditingViewController.m
//  TimeImprint
//
//  Created by Peng Wan on 4/20/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "ArticleEditingViewController.h"
#import "StoryAPIManager.h"
#import "Session.h"

@interface ArticleEditingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
@property (assign, nonatomic) BOOL isPrivacy;
@end

@implementation ArticleEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)editStory:(id)sender {
    
}
- (IBAction)putStory:(id)sender {
    [Session sharedInstance].user.deleted_story_count +=1;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"DeleteStoryNotificaiton"
     object:self
     userInfo:@{@"story_id":self.story_id}];
}
- (IBAction)deleteStory:(id)sender {
    [Session sharedInstance].user.deleted_story_count +=1;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"DeleteStoryNotificaiton"
     object:self
     userInfo:@{@"story_id":self.story_id}];
    //    StoryAPIManager *api = [StoryAPIManager sharedInstance];
    //    [api deleteWithId:self.story_id success:^(id successResponse) {
    //        [[NSNotificationCenter defaultCenter]
    //         postNotificationName:@"DeleteStoryNotificaiton"
    //         object:self.story_id];
    //    } failure:^(id failureResponse, NSError *error) {
    //        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Fail"
    //                                                           message:failureResponse
    //                                                          delegate:self
    //                                                 cancelButtonTitle:@"OK"
    //                                                 otherButtonTitles:nil];
    //        [theAlert show];
    //    }];
}
- (IBAction)setPrivacy:(id)sender {
    self.isPrivacy = !self.isPrivacy;
    UIImage *btnImage = [UIImage imageNamed:@"privacy_open_15"];
    if(self.isPrivacy){
        btnImage = [UIImage imageNamed:@"privacy_private_15"];
    }
    [self.privacyButton setImage:btnImage forState:UIControlStateNormal];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
