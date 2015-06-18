//
//  BrowseFollowViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "BrowseFollowViewController.h"
#import "UtilityViewController.h"
#import "GraphAPIManager.h"

@interface BrowseFollowViewController ()

@property (nonatomic, strong) NSMutableArray *aTimeimprintFollowers;
@property (nonatomic, strong) NSMutableArray *aWechatFolloers;
@property (nonatomic, strong) NSString *strUserID;

@end

@implementation BrowseFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.strUserID = @"019d34ec15524c99babc2b560dbd1d72";
    
    [self initSet];
    
    // hide back bar title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [self setupSegmentedCtrl];
    [self segmentedShowHideView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // get followers
    GraphAPIManager *apiGraph = [GraphAPIManager sharedInstance];
    [apiGraph getFollowers:self.strUserID start:@0 limit:@10 filter_followed:true filter_unfollowed:false success:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            NSDictionary *dictTimeimprintFollowers = successResponse;
            // every time refresh
            [self.aTimeimprintFollowers removeAllObjects];
            [self.aTimeimprintFollowers addObjectsFromArray:[dictTimeimprintFollowers objectForKey:@"followers"]];
            
            [self.followTableView reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: cannot get followers");
    }];
    
}

// init properties and set table delegate
- (void)initSet {
    // init properties
    self.aTimeimprintFollowers = [[NSMutableArray alloc] init];
    self.aWechatFolloers = [[NSMutableArray alloc] init];
    
    // set table delegate
    self.followTableView.delegate = self;
    self.followTableView.dataSource = self;
    self.wechatTableView.delegate = self;
    self.wechatTableView.dataSource = self;
}

- (void)setupSegmentedCtrl {
    // set font
    UIFont *font = [UIFont fontWithName:@"NotoSansCJKsc-Regular" size:18.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
    
    [self.followSegCtrl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    // set border
    self.followSegCtrl.layer.borderWidth = 0.5f;
    [self.followSegCtrl.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    self.followSegCtrl.layer.cornerRadius = 0.0;
    
    // initial selected value
    UIColor *tintcolor=[UIColor redColor];
    [[self.followSegCtrl.subviews objectAtIndex:1] setTintColor:tintcolor];
}

- (void)segmentedShowHideView {
    if([[self.followSegCtrl.subviews objectAtIndex: 1]isSelected]) {
        [self.wechatTableView setHidden:YES];
        [self.wechatInviteBtn setHidden:YES];
        [self.followTableView setHidden:NO];
    }else{
        [self.wechatTableView setHidden:NO];
        [self.wechatInviteBtn setHidden:NO];
        [self.followTableView setHidden:YES];
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
            [[self.followSegCtrl.subviews objectAtIndex: i] setTintColor:nil];
        }
    }
    
}

// table view
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.followTableView){
        return [self.aTimeimprintFollowers count];
    }else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"followViewCell";
    static NSString *wechatCellIdentifier = @"wechatCell";
    
    UITableViewCell *cell;
    UIImageView *imageViewAvatar;
    UILabel *labelName;
    UIButton *btnFollow;
    
    if(tableView == self.followTableView){
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(self.aTimeimprintFollowers && [self.aTimeimprintFollowers count] != 0){
            NSDictionary *dictFollower = [self.aTimeimprintFollowers objectAtIndex:indexPath.row];
            
            if(dictFollower){
                // get image
                NSURL *url = [NSURL URLWithString:[dictFollower objectForKey:@"profile_pic_url"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *imgAvatar = [[UIImage alloc] initWithData:data];
                
                // get name
                NSString *strName = [dictFollower objectForKey:@"user_name"];
                
                // set avatar
                if(imgAvatar != nil){
                    imageViewAvatar = (UIImageView *)[cell viewWithTag:1103];
                    [UtilityViewController changeImgToCircle:imageViewAvatar];
                    imageViewAvatar.image = imgAvatar;
                }
                
                // set name
                if(strName != nil){
                    labelName = (UILabel *)[cell viewWithTag:1102];
                    labelName.text = strName;
                }
                
                // set follow button
                btnFollow = (UIButton *)[cell viewWithTag:1101];
                btnFollow.tag = indexPath.row;
                
                UIImage *image = [UIImage imageNamed:@"me_followed_24.png"];
                image = [UtilityViewController changeImage:image withColor:[UIColor blackColor]];
                [btnFollow setImage:image forState:UIControlStateSelected];
                
                [btnFollow addTarget:self action:@selector(onFollowFriend:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:wechatCellIdentifier];
    }
    
    return cell;
}

- (void)onFollowFriend:(UIButton *)sender {
    // set UI
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    // get user ID
    NSDictionary *dictFollower = [self.aTimeimprintFollowers objectAtIndex:sender.tag];
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


- (IBAction)changeSource:(UISegmentedControl *)sender {
    [self changeSegmentedControlColor];
    
    [self segmentedShowHideView];
}
@end
