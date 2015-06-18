//
//  ChangeNameViewController.m
//  TimeImprint
//
//  Created by Paul on 4/23/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "UserAPIManager.h"
#import "Session.h"
@interface ChangeNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nameField.text = [Session sharedInstance].user.user_name;
    [_nameField becomeFirstResponder];
    
    //todo load user info from storage
    //todo no update password api
    
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

- (IBAction)cancelButtonTouchUpInside:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)saveButtonTouchUpInside:(id)sender {
    UserAPIManager *api = [UserAPIManager sharedInstance];
    [api updateProfileWithID:TEST_USER_ID username:self.nameField.text gender:nil bio:nil avatar:nil profilePic:nil success:^(id successResponse) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"成功"
                                                           message:@"您的用户名已经更新成功！"
                                                          delegate:self
                                                 cancelButtonTitle:@"知道啦"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [Session sharedInstance].user.user_name = self.nameField.text;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id failureResponse, NSError *error) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"失败"
                                                           message:failureResponse
                                                          delegate:self
                                                 cancelButtonTitle:@"关闭"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }];
}

@end
