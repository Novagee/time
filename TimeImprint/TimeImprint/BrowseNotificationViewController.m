//
//  BrowseNotificationViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/15/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "BrowseNotificationViewController.h"
#import "UtilityViewController.h"
#import "UserAPIManager.h"
#import "GraphAPIManager.h"

@interface BrowseNotificationViewController ()

@property (strong, nonatomic) NSMutableArray *aNotifications;

@end

@implementation BrowseNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // hide back bar title
    [self initSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UserAPIManager *apiUser = [UserAPIManager sharedInstance];
    
    // get notifications
    [self getNotifications:apiUser];
}

- (void)initSetup {
    self.notificationTableView.dataSource = self;
    self.notificationTableView.delegate = self;
    
    self.aNotifications = [[NSMutableArray alloc] init];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

}

- (void)getNotifications:(UserAPIManager *)apiUser {
    [apiUser viewUserNotificationSuccess:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            NSDictionary *dictNotifications = successResponse;
            
            [self.aNotifications removeAllObjects];
            self.aNotifications = [dictNotifications objectForKey:@"notifications"];
            
            [self.notificationTableView reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: can't get notifications");
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.aNotifications count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *followIden = @"followCell";
    static NSString *likeIden = @"likeCell";
    static NSString *commentIden = @"commentCell";
    
    UITableViewCell *cell;
    
    NSDictionary *dictNotificaiton = [self.aNotifications objectAtIndex:indexPath.row];
    if(dictNotificaiton){
        NSString *strNotiType = [dictNotificaiton objectForKey:@"notification_type"];
        if([strNotiType isEqualToString:@"follow"]){
            cell = [tableView dequeueReusableCellWithIdentifier:followIden];
            
            [self setCellWithNotification:dictNotificaiton inCell:cell avatarTag:1011 nameTag:1012 createdTimeTag:1013];
            
            // set follow button
            UIButton *btnFollow = (UIButton *)[cell viewWithTag:4014];
            UIImage *image = [UIImage imageNamed:@"me_followed_24.png"];
            image = [UtilityViewController changeImage:image withColor:[UIColor blackColor]];
            [btnFollow setImage:image forState:UIControlStateSelected];
            [btnFollow addTarget:self action:@selector(onFollowFriend:) forControlEvents:UIControlEventTouchUpInside];
        }else if([strNotiType isEqualToString:@"like"]){
            cell = [tableView dequeueReusableCellWithIdentifier:likeIden];
            
            [self setCellWithNotification:dictNotificaiton inCell:cell avatarTag:1021 nameTag:1022 createdTimeTag:1023];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:commentIden];
            
            [self setCellWithNotification:dictNotificaiton inCell:cell avatarTag:1031 nameTag:1032 createdTimeTag:1033];
        }
    }

    return cell;
}

- (void)setCellWithNotification: (NSDictionary *)dictNotificaiton
                         inCell: (UITableViewCell *)cell
                      avatarTag: (NSInteger) tagAvatar
                        nameTag: (NSInteger) tagName
                 createdTimeTag: (NSInteger) tagCreatedTime {
    NSDictionary *dictFromUser = [dictNotificaiton objectForKey:@"from_user"];
    // get avatar
    NSString *strAvatar = [dictFromUser objectForKey:@"avatar_url"];
    NSURL *urlAvatar = [NSURL URLWithString:strAvatar];
    UIImage *imgAvatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlAvatar]];
    // get name
    NSString *strUsername = [dictFromUser objectForKey:@"user_name"];
    // get post time
    NSString *strCreatedTime = [dictNotificaiton objectForKey:@"created_at"];
    
    // set avatar
    UIImageView *imgvAvatar = (UIImageView *)[cell viewWithTag:tagAvatar];
    [UtilityViewController changeImgToCircle:imgvAvatar];
    imgvAvatar.image = imgAvatar;
    // set name
    UILabel *labelName = (UILabel *)[cell viewWithTag:tagName];
    labelName.text = strUsername;
    // set time
    UILabel *labelCreatedTime = (UILabel *)[cell viewWithTag:tagCreatedTime];
    labelCreatedTime.text = [self getTimeFromEpoch:strCreatedTime];
}

- (NSString *) getTimeFromEpoch: (NSString *)epochTime {
    NSTimeInterval seconds = [epochTime doubleValue];
    NSDate *dateEpoch = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDate *dateToday = [NSDate date];
    
    NSString *formatString;
    if([dateEpoch isEqualToDate:dateToday]){
        formatString = @"HH:mm";
    }else {
        formatString = @"MM/dd/YYYY";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    
    return [formatter stringFromDate:dateEpoch];
}


- (void) onFollowFriend: (UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    // get user ID
    NSDictionary *dictFollower = [[self.aNotifications objectAtIndex:sender.tag] objectForKey:@"from_user"];
    NSString *followerID = [dictFollower objectForKey:@"user_id"];
    
    // follow or unfollow another user
    if(button.selected){
        GraphAPIManager *apiGraph = [GraphAPIManager sharedInstance];
        [apiGraph followUser:followerID success:^(id successResponse) {
            NSLog(@"Successfully follow others");
        } failure:^(id failureResponse, NSError *error) {
            NSLog(@"Error: cannot follow other user");
        }];
    }else{
        GraphAPIManager *apiGraph = [GraphAPIManager sharedInstance];
        [apiGraph unfollowUser:followerID success:^(id successResponse) {
            NSLog(@"Successfully unfollow others");
        } failure:^(id failureResponse, NSError *error) {
            NSLog(@"Error: cannot unfollow other user");
        }];
    }

}


@end
