//
//  SuggestionViewController.m
//  TimeImprint
//
//  Created by Paul on 4/23/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "SuggestionViewController.h"

@interface SuggestionViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *annotationView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    _annotationView.hidden = YES;
    
}

- (IBAction)cancelButtonTouchUpInside:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)sendButtonTouchUpInside:(id)sender {
    
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"成功"
                                                       message:@"您的宝贵意见已经发送成功！"
                                                      delegate:self
                                             cancelButtonTitle:@"知道啦"
                                             otherButtonTitles:nil];
    [theAlert show];
    [self.navigationController popViewControllerAnimated:YES];
    
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
