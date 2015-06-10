//
//  BrowseViewController.h
//  TimeImprint
//
//  Created by Yi Gu on 4/12/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *browseTableView;

@end
