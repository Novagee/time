//
//  BrowseDetailLikeViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/24/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "BrowseDetailLikeViewController.h"

@interface BrowseDetailLikeViewController()

@end

@implementation BrowseDetailLikeViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"browseLikeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

@end
