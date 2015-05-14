//
//  NewStoryViewController.m
//  TimeImprint
//
//  Created by Peng Wan on 5/9/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "NewStoryViewController.h"
#import "LocationPickerViewController.h"
#import "TimePickerViewController.h"
#import "MainViewController.h"

@interface NewStoryViewController ()

@end

@implementation NewStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ((MainViewController *)self.tabBarController).lockScreenRotation = NO;
    [self rotateDeviceOrientation:UIInterfaceOrientationPortrait];

}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)onClickLocation:(id)sender {
    LocationPickerViewController *locationPickerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"location_picker"];
    [self.navigationController pushViewController:locationPickerViewController animated:YES];

}
- (IBAction)onClickOccurTime:(id)sender {
    TimePickerViewController *timePickerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"time_picker"];
    [self.navigationController pushViewController:timePickerViewController animated:YES];
}
- (IBAction)onClickPublicTime:(id)sender {
    TimePickerViewController *timePickerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"time_picker"];
    timePickerViewController.title = @"发布发生时间";
    [self.navigationController pushViewController:timePickerViewController animated:YES];
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

- (void)rotateDeviceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    [[UIDevice currentDevice]setValue:@(interfaceOrientation) forKey:@"orientation"];
    [[UIApplication sharedApplication]setStatusBarOrientation:interfaceOrientation];
    
}

@end
