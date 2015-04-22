//
//  SettingViewController.m
//  TimeImprint
//
//  Created by Paul on 4/22/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "SettingViewController.h"

#import "ChangeAccountViewController.h"
#import "ChangeNameViewController.h"
#import "ChangePasswordViewController.h"
#import "SuggestionViewController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTouchUpInside:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)suggestButtonTouchUpInside:(id)sender {
    
    SuggestionViewController *suggestionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"suggestionView"];
    [self.navigationController pushViewController:suggestionViewController animated:YES];
    
}

- (IBAction)changePasswordButtonTouchUpInside:(id)sender {
    
    ChangePasswordViewController *changePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"changePasswordView"];
    [self.navigationController pushViewController:changePasswordViewController animated:YES];
    
}

- (IBAction)accountButtonTouchUpInside:(id)sender {

    ChangeAccountViewController *changeAccountViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"changeAccountView"];
    [self.navigationController pushViewController:changeAccountViewController animated:YES];
    
}

- (IBAction)nameButtonTouchUpInside:(id)sender {

    ChangeNameViewController *changeNameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"changeNameView"];
    [self.navigationController pushViewController:changeNameViewController animated:YES];

    
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
