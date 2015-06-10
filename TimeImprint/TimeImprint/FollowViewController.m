//
//  FollowViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "FollowViewController.h"
#import "UtilityViewController.h"

@interface FollowViewController ()

@property (nonatomic, strong) NSMutableArray *names;
@property (nonatomic, strong) NSMutableArray *wechatNames;

@end

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.names = [[NSMutableArray alloc] initWithObjects:@"林宇翔", @"Jason", nil];
    self.wechatNames = [[NSMutableArray alloc] initWithObjects:@"Joy", @"Peter", nil];
    
    self.followTableView.delegate = self;
    self.followTableView.dataSource = self;
    
    self.wechatTableView.delegate = self;
    self.wechatTableView.dataSource = self;
    
    // hide back bar title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [self setupSegmentedCtrl];
    
    [self segmentedShowHideView];
    
    // set up button
    [UtilityViewController setupButton:self.wechatInviteBtn];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // hide the search bar
    [self.wechatTableView setContentOffset:CGPointMake(0, 44)];
    [self.followTableView setContentOffset:CGPointMake(0, 44)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSegmentedCtrl {
    [self changeSegmentedControlColor];
    [UtilityViewController setupSegmentedControl:self.followSegCtrl];
}

- (void)segmentedShowHideView {
    if([[self.followSegCtrl.subviews objectAtIndex: 1]isSelected]) {
        [self.wechatTableView setHidden:YES];
        [self.wechatInviteBtn setHidden:YES];
        [self.followTableView setHidden:NO];
        
        [self.followTableView setContentOffset:CGPointMake(0, 44)];
    }else{
        [self.wechatTableView setHidden:NO];
        [self.wechatInviteBtn setHidden:NO];
        [self.followTableView setHidden:YES];
        
        [self.wechatTableView setContentOffset:CGPointMake(0, 44)];
    }
}



- (void)changeSegmentedControlColor {
    for (int i = 0; i < [self.followSegCtrl.subviews count]; i++)
    {
        if ([[self.followSegCtrl.subviews objectAtIndex: i]isSelected] )
        {
            UIColor *tintcolor = [UIColor redColor];
            [[self.followSegCtrl.subviews objectAtIndex: i] setTintColor: tintcolor];
        }
        else
        {
            [[self.followSegCtrl.subviews objectAtIndex:i] setTintColor:nil];
        }
    }

}


// table view
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"followViewCell";
    static NSString *wechatCellIdentifier = @"wechatCell";
    
    UITableViewCell *cell;
    UIButton *followBtn;
    UILabel *nameLabel;
    
    if(tableView == self.followTableView){
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
        // set up button
        followBtn = (UIButton *)[cell viewWithTag:1101];
        [UtilityViewController setupButton:followBtn];
    
        // set up name
        nameLabel = (UILabel *)[cell viewWithTag:1102];
        nameLabel.text = [self.names objectAtIndex:indexPath.row];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:wechatCellIdentifier];
        
        // set up button
        followBtn = (UIButton *)[cell viewWithTag:1111];
        [UtilityViewController setupButton:followBtn];
        
        // set up name
        nameLabel = (UILabel *)[cell viewWithTag:1112];
        nameLabel.text = [self.wechatNames objectAtIndex:indexPath.row];
    }
    
    return cell;
}


- (IBAction)changeSource:(UISegmentedControl *)sender {
    [self changeSegmentedControlColor];
    
    [self segmentedShowHideView];
}
@end
