//
//  BrowseDetailLikeViewController.h
//  TimeImprint
//
//  Created by Yi Gu on 4/24/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseDetailLikeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *browseDetailLikeTableView;

@end
