//
//  FollowingViewController.m
//  TimeImprint
//
//  Created by Paul on 4/23/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "FolloweeViewController.h"
#import "FollowingCell.h"
#import "NSObject+MJKeyValue.h"
#import "GraphAPIManager.h"
#import "Profile.h"

@interface FolloweeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *followees;
@property (strong, nonatomic) NSArray *followers;

@end

@implementation FolloweeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [_tableView registerNib:[UINib nibWithNibName:@"FollowingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[FollowingCell reuseIdentifier]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    GraphAPIManager *api = [GraphAPIManager sharedInstance];
    [api getFollowees:TEST_USER_ID
                start:[NSNumber numberWithInt:0]
                limit:[NSNumber numberWithInt:10]
              success:^(id successResponse) {
        //        NSLog(@"resp:%@",successResponse);
        if ([successResponse isKindOfClass:[NSArray class]]) {
            self.followees = [Profile objectArrayWithKeyValuesArray:successResponse];
            [self.tableView reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"err:%@",failureResponse);
    }];
    
    [api getFollowers:TEST_USER_ID start:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:10] success:^(id successResponse) {
        //        NSLog(@"resp:%@",successResponse);
        if ([successResponse isKindOfClass:[NSArray class]]) {
            self.followers = [Profile objectArrayWithKeyValuesArray:successResponse];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"err:%@",failureResponse);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.followees.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FollowingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[FollowingCell reuseIdentifier] forIndexPath:indexPath];
    Profile* followee = [self.followees objectAtIndex:indexPath.row];
    [cell initFollowing:followee];
    // Handle add button actions
    //
    
    bool isFollower = false;
    for (Profile* follower in self.followers) {
        if([followee.user_id isEqualToString:follower.user_id]){
            isFollower = YES;
        }
    }
    [cell.followButton setTag:indexPath.row];
    if(isFollower){
        cell.followButton.hidden = YES;
    }else{
        [cell.followButton addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    }
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

- (void)follow:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    Profile *profile = [self.followees objectAtIndex:indexPath.row];
    GraphAPIManager* api = [GraphAPIManager sharedInstance];
    [api followUser:profile.user_id success:^(id successResponse) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                           message:[NSString stringWithFormat:@"You are following %@",profile.user_name]
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];

    } failure:^(id failureResponse, NSError *error) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Fail"
                                                           message:failureResponse
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];

    }];
}

- (IBAction)backButtonTouchUpInside:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];    
    
}

@end
