//
//  BrowseViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/12/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "BrowseViewController.h"

#import "MainViewController.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.browseTableView.delegate = self;
    self.browseTableView.dataSource = self;
    
    // dismiss the separator line
    self.browseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    ((MainViewController *)self.tabBarController).lockScreenRotation = YES;    
    
    [self rotateDeviceOrientation:UIInterfaceOrientationPortrait];
    
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation Methods

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationPortrait;
    
}

- (void)rotateDeviceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    [[UIDevice currentDevice]setValue:@(interfaceOrientation) forKey:@"orientation"];
    [[UIApplication sharedApplication]setStatusBarOrientation:interfaceOrientation];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"browseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}





@end
