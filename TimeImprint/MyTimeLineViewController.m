//
//  MyTimeLineViewController.m
//  TimeImprint
//
//  Created by Paul on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "MyTimeLineViewController.h"
#import "CALayer+StoryBoardExtention.h"

#import "OwnTimeLineCell.h"

typedef NS_ENUM(NSInteger, kImagePickerTarget) {
    
    kImagePickerTargetAvatar = 0,
    kImagePickerTargetBackground = 1
};

typedef NS_ENUM(NSInteger, kMainViewType) {
    
    kMainViewTypeMe = 0,
    kMainViewTypeAtMe = 1
    
};

@interface MyTimeLineViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *atMeMainView;
@property (weak, nonatomic) IBOutlet UIView *meMainView;
@property (assign, nonatomic) kMainViewType *mainViewType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

#pragma mark - Table View Header

@property (weak, nonatomic) IBOutlet UIButton *switchBackgroundButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *switchAvatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarImageViewCenterConstrain;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (assign, nonatomic) kImagePickerTarget imagePickerTarget;
@property (assign, nonatomic, getter=isEditingProfile) BOOL editingProfile;

@end

@implementation MyTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_tableView registerNib:[UINib nibWithNibName:@"OwnTimeLineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[OwnTimeLineCell reuseIdentifier]];
    
    [self configurePickerView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure Editing Status

- (void)setEditingProfile:(BOOL)editingProfile {
    
    if (editingProfile) {
        
        _switchAvatarButton.hidden = NO;
        _switchBackgroundButton.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            _switchAvatarButton.alpha = 1.0f;
            _switchBackgroundButton.alpha = 1.0f;
        
            _avatarImageViewCenterConstrain.constant = 30;
            [self.view layoutIfNeeded];
            
        }];
        
        _userNameTextField.userInteractionEnabled = YES;
        
        [_editButton setTitle:@"完成" forState:UIControlStateNormal];
        
    }
    else {
        
        _switchAvatarButton.hidden = YES;
        _switchBackgroundButton.hidden = YES;
        _userNameTextField.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.3f animations:^{
            _switchAvatarButton.alpha = 0.0f;
            _switchBackgroundButton.alpha = 0.0f;
        
            _avatarImageViewCenterConstrain.constant = 0;
            [self.view layoutIfNeeded];
            
        }];
        
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        
    }
    
    _editingProfile = editingProfile;
    
}

#pragma mark - Action Sheet Stuff

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    _imagePickerController.sourceType = buttonIndex == 0?
    UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}

- (void)showImagePickerSheet {
    
    UIActionSheet *imagePickerSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [imagePickerSheet showInView:self.view];
    
}

#pragma mark - Image Picker Stuff

- (void)configurePickerView {
    
    _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    if (self.imagePickerTarget == kImagePickerTargetAvatar) {
        _avatarImageView.image = image;
    }
    else {
        _backgroundImageView.image = image;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Table View Data Source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 380.0f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OwnTimeLineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[OwnTimeLineCell reuseIdentifier] forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Control's Actions

- (IBAction)editButtonTouchUpInside:(id)sender {
    
    self.editingProfile = !_editingProfile;
    
}

- (IBAction)switchAvatarButtonTouchUpInside:(id)sender {
    
    _imagePickerTarget = kImagePickerTargetAvatar;
    
    [self showImagePickerSheet];
    
}

- (IBAction)switchBackgroundButtonTouchUpInside:(id)sender {
    
    _imagePickerTarget = kImagePickerTargetBackground;
    
    [self showImagePickerSheet];
    
}

- (IBAction)segmentSwitched:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == kMainViewTypeAtMe) {
        _atMeMainView.hidden = NO;
        _meMainView.hidden = YES;
    }
    else {
        _atMeMainView.hidden = YES;
        _meMainView.hidden = NO;
    }
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
