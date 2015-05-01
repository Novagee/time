//
//  FollowerViewController.m
//  TimeImprint
//
//  Created by Paul on 4/23/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "FollowerViewController.h"
#import "FollowingCell.h"

@interface FollowerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *nameField;

@end

@implementation FollowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_tableView registerNib:[UINib nibWithNibName:@"FollowingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[FollowingCell reuseIdentifier]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 24;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FollowingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[FollowingCell reuseIdentifier] forIndexPath:indexPath];
    
    // Handle add button actions
    //
    UIButton *addButton = (UIButton *)[cell viewWithTag:1001];
    [addButton addTarget:self action:@selector(addButtonWithCellInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 64.0f;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addButtonWithCellInfo:(id)cellInfo {
    
    NSLog(@"Ok");
    
}

- (IBAction)backButtonTouchUpInside:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];

}

@end
