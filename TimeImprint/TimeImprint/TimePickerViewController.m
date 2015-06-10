//
//  TimePickerViewController.m
//  TimeImprint
//
//  Created by Peng Wan on 5/9/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "TimePickerViewController.h"

@interface TimePickerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation TimePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.happenedTime == PublishTime) {
        self.titleLabel.text = @"发布发生时间";
    } else
    {
        self.titleLabel.text = @"事件发生时间";
    }
}

- (IBAction)onClickDone:(id)sender {
    [self dismissViewControllerAnimated:self completion:nil];
    
    if (self.happenedTime == HappenTime) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"TimeDidFinishSetting" object:@{@"type":@0, @"date":self.datePicker.date}];
    } else {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"TimeDidFinishSetting" object:@{@"type":@1, @"date":self.datePicker.date}];

    }
}
- (IBAction)onClickCancel:(id)sender {
    [self dismissViewControllerAnimated:self completion:nil];
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

@end
