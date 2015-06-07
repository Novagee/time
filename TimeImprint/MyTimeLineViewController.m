//
//  MyTimeLineViewController.m
//  TimeImprint
//
//  Created by Paul on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "MyTimeLineViewController.h"
#import "SettingViewController.h"
#import "TimeMechineViewController.h"

#import "FolloweeViewController.h"
#import "FollowerViewController.h"

#import "OwnTimeLineCell.h"

#import "UserAPIManager.h"
#import "TimelineAPIManager.h"
#import "NSObject+MJKeyValue.h"
#import "Story.h"
#import "Profile.h"

typedef NS_ENUM(NSInteger, kImagePickerTarget) {
    
    kImagePickerTargetAvatar = 0,
    kImagePickerTargetBackground = 1
    
};

@interface MyTimeLineViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *meMainView;

@property (weak, nonatomic) IBOutlet UIView *navigationBarBottom;
@property (weak, nonatomic) IBOutlet UIImageView *tinyAvatar;

#pragma Self Size Cell

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *stories;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

#pragma mark - Table View Header

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (assign, nonatomic) kImagePickerTarget imagePickerTarget;

@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerLabel;

@end

@implementation MyTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_tableView registerNib:[UINib nibWithNibName:@"OwnTimeLineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[OwnTimeLineCell reuseIdentifier]];
    
    [self configurePickerView];
    
    //todo: load user details: background image, avater, name, followees, followers
    UserAPIManager *api = [UserAPIManager sharedInstance];
    [api viewProfileWithID:TEST_USER_ID success:^(id successResponse) {
        Profile *profile = [Profile objectWithKeyValues:successResponse];
        //todo: load image, place holder
//        self.backgroundImageView.image =
//        self.avatarImageView.image =
        self.userNameTextField.text = profile.user_name;
        self.followerLabel.text = [NSString stringWithFormat:@"关注 %i",profile.followers] ;
        self.followingLabel.text = [NSString stringWithFormat:@"粉丝 %i",profile.following];
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"err:%@",failureResponse);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TimelineAPIManager *api = [TimelineAPIManager sharedInstance];
    [api getTimelineWithUser:TEST_USER_ID storyId:@"" limit:[NSNumber numberWithInt:10] success:^(id successResponse) {
//        NSLog(@"resp:%@",successResponse);
        if ([successResponse isKindOfClass:[NSArray class]]) {
            self.stories = [Story objectArrayWithKeyValuesArray:successResponse];
            [self.tableView reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"err:%@",failureResponse);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Sheet Stuff

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 2) {
        return ;
    }
    
    _imagePickerTarget = buttonIndex;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}

- (void)showImagePickerSheet {
    
    UIActionSheet *imagePickerSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"更改头像", @"更改背景", nil];
    [imagePickerSheet showInView:self.view];
    
}

#pragma mark - Image Picker Stuff

- (void)configurePickerView {
    
    _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    if (self.imagePickerTarget == kImagePickerTargetAvatar) {
        _avatarImageView.image = image;
        _tinyAvatar.image = image;
    }
    else {
        _backgroundImageView.image = image;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - NavigationBar Animation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat basicRate = (scrollView.contentOffset.y/42.0f < 1.0f? scrollView.contentOffset.y/42.0f : 1.0f);
    
    _tinyAvatar.hidden = !(scrollView.contentOffset.y >= 41.5f);
    _navigationBarBottom.alpha = basicRate;
    
    CGFloat scaleRate = (1.0f - (0.5f * basicRate)) > 1.0f? 1.0f : 1.0f - (0.5f * basicRate);
    _avatarImageView.transform = CGAffineTransformMakeScale(scaleRate, scaleRate);
    _avatarImageView.hidden = (scaleRate == 0.5f);
    
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"story count:%lu",(unsigned long)self.stories.count);
    return self.stories.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OwnTimeLineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[OwnTimeLineCell reuseIdentifier] forIndexPath:indexPath];
    
    Story* story = [self.stories objectAtIndex:indexPath.row];
    [cell initStory:story];
    
    // Handle comments button
    UIButton *comments = (UIButton *)[cell viewWithTag:1002];
    [comments addTarget:self action:@selector(commentsButtonTappedWithCell:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // I can figure out why the cell height is incorrect when I invoke the "systemLayoutSizeFittingSize"
    // So here I use the screen's width to configure the cell's height
    // when the App run in different device, aka iPhone 6 or iPhone 6 plus
    //
    return 296.0f * self.view.bounds.size.width/320.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
}

#pragma mark - Actions of Cell

- (void)likeButtonTappedWithCell:(OwnTimeLineCell *)cell {
    
    cell.liked = !cell.liked;
    
}

- (void)commentsButtonTappedWithCell:(OwnTimeLineCell *)cell {
    
    
    
}

#pragma mark - Control's Actions

- (IBAction)settingButtonTouchUpInside:(id)sender {
    
    UINavigationController *settingNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingNavigationView"];
    [self presentViewController:settingNavigationController animated:YES completion:nil];
    
}
- (IBAction)timeMechineButtonTouchUpInside:(id)sender {
    
    TimeMechineViewController *timeMechineViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"timeMechineView"];
    [self.navigationController pushViewController:timeMechineViewController animated:YES];
    
}

- (IBAction)followerButtonTouchUpInside:(id)sender {
    
    FollowerViewController *followerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"followerView"];
    [self.navigationController pushViewController:followerViewController animated:YES];
//    [self presentViewController:followerViewController animated:YES completion:nil];
    
}

- (IBAction)followingButtonTouchUpInside:(id)sender {
    
    FolloweeViewController *followeeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"followeeView"];
        [self.navigationController pushViewController:followeeViewController animated:YES];
//    [self presentViewController:followeeViewController animated:YES completion:nil];
    
}

- (IBAction)changeAvatarOrBackgroundButtonTouchUpInside:(id)sender {
    
    [self showImagePickerSheet];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
