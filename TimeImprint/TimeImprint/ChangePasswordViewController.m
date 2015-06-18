//
//  ChangePasswordViewController.m
//  TimeImprint
//
//  Created by Paul on 4/23/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UserAPIManager.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *changedPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_oldPasswordField becomeFirstResponder];
    
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
    if(![self.changedPasswordField.text isEqualToString:self.confirmPasswordField.text]){
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"失败"
                                                           message:@"验证密码不一致"
                                                          delegate:self
                                                 cancelButtonTitle:@"关闭"
                                                 otherButtonTitles:nil];
        [theAlert show];
        return;
    }
    UserAPIManager *api = [UserAPIManager sharedInstance];
    [api changePassword:self.changedPasswordField.text withUserID:TEST_USER_ID success:^(id successResponse) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"成功"
                                                           message:@"您的密码已经更新成功！"
                                                          delegate:self
                                                 cancelButtonTitle:@"知道啦"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id failureResponse, NSError *error) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Fail"
                                                           message:failureResponse
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }];
}

@end
