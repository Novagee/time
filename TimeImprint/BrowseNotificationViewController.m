//
//  BrowseNotificationViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/15/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "BrowseNotificationViewController.h"
#import "UtilityViewController.h"

@interface BrowseNotificationViewController ()

@end

@implementation BrowseNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.notificationTableView.dataSource = self;
    self.notificationTableView.delegate = self;
    
    // hide back bar title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 80;
            break;
        case 1:
            return 80;
        default:
            return 100;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *followIden = @"followCell";
    static NSString *likeIden = @"likeCell";
    static NSString *commentIden = @"commentCell";
    
    UITableViewCell *cell;
    
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:followIden];
    }else if(indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:likeIden];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:commentIden];
    }
    
    return cell;
}

@end
