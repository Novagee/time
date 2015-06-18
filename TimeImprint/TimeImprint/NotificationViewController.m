//
//  NotificationViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 5/15/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "NotificationViewController.h"
#import "UtilityViewController.h"
#import "QuestionAPIManager.h"
#import "UserAPIManager.h"
#import "GraphAPIManager.h"
#import "UtilityViewController.h"

@interface NotificationViewController ()

@property (strong, nonatomic) NSMutableArray *aQAQuestions;
@property (strong, nonatomic) NSMutableArray *aNotifications;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSegmentedControl];
    
    [self initSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    QuestionAPIManager *apiQuestion = [QuestionAPIManager sharedInstance];
    UserAPIManager *apiUser = [UserAPIManager sharedInstance];
    
    NSString *strStart = [NSString stringWithFormat:@"%d", 0];
    NSString *strLimit = [NSString stringWithFormat:@"%d", 10];
    
    // get questions asking me and asked by me
    [self getQAQuestions:apiQuestion start:strStart limit:strLimit];
    
    // get notifications
    [self getNotifications:apiUser];
}

- (void)initSetup {
    self.tableNotification.delegate = self;
    self.tableNotification.dataSource = self;
    
    self.aNotifications = [[NSMutableArray alloc] init];
    self.aQAQuestions = [[NSMutableArray alloc] init];
}

- (void)getQAQuestions:(QuestionAPIManager *)apiQuestion
                 start:(NSString *)start
                 limit:(NSString *)limit {
    [apiQuestion allbounds:start limit:limit type:@"unread" success:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            NSDictionary *dictMeAskQuestions = successResponse;
            
            [self.aQAQuestions removeAllObjects];
            [self.aQAQuestions addObjectsFromArray: [dictMeAskQuestions objectForKey:@"questions"]];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: can't get questions");
    }];
}

- (void)getNotifications:(UserAPIManager *)apiUser {
    [apiUser viewUserNotificationSuccess:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            NSDictionary *dictNotifications = successResponse;
            
            [self.aNotifications removeAllObjects];
            [self.aNotifications addObjectsFromArray:[dictNotifications objectForKey:@"notifications"]];
            
            [self.tableNotification reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: can't get notifications");
    }];
}

// segmented view
- (void) setupSegmentedControl {
    // set font
    UIFont *font = [UIFont fontWithName:@"NotoSansCJKsc-Regular" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    
    [self.segmentedNotification setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    // set border
    self.segmentedNotification.layer.borderWidth = 0.5;
    [self.segmentedNotification.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    // initial selected value
    UIColor *tintcolor=[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
    [[self.segmentedNotification.subviews objectAtIndex:1] setTintColor:tintcolor];
}


// table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([[self.segmentedNotification.subviews objectAtIndex:0] isSelected]){
        return [self.aNotifications count];
    }else {
        
        return [self.aQAQuestions count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[self.segmentedNotification.subviews objectAtIndex:0] isSelected]){
        return 100;
    }else {
        return 72;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *followIden = @"notiFollowCell";
    NSString *likeIden = @"notiLikeCell";
    NSString *commentIden = @"notiCommentCell";
    NSString *qaIden = @"notiQACell";
    
    UITableViewCell *cell;
    
    if([[self.segmentedNotification.subviews objectAtIndex:0] isSelected]){
        NSDictionary *dictNotificaiton = [self.aNotifications objectAtIndex:indexPath.row];
        if(dictNotificaiton){
            NSString *strNotiType = [dictNotificaiton objectForKey:@"notification_type"];
            if([strNotiType isEqualToString:@"follow"]){
                cell = [tableView dequeueReusableCellWithIdentifier:followIden];
                
                [self setCellWithNotification:dictNotificaiton inCell:cell avatarTag:4011 nameTag:4012 createdTimeTag:4013];
                
                // set follow button
                UIButton *btnFollow = (UIButton *)[cell viewWithTag:4014];
                UIImage *image = [UIImage imageNamed:@"me_followed_24.png"];
                image = [UtilityViewController changeImage:image withColor:[UIColor blackColor]];
                [btnFollow setImage:image forState:UIControlStateSelected];
                [btnFollow addTarget:self action:@selector(onFollowFriend:) forControlEvents:UIControlEventTouchUpInside];
            }else if([strNotiType isEqualToString:@"like"]){
                cell = [tableView dequeueReusableCellWithIdentifier:likeIden];
                
                [self setCellWithNotification:dictNotificaiton inCell:cell avatarTag:4021 nameTag:4022 createdTimeTag:4023];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:commentIden];
                
                [self setCellWithNotification:dictNotificaiton inCell:cell avatarTag:4031 nameTag:4032 createdTimeTag:4033];
            }
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:qaIden];
        
        NSDictionary *dictQuestion = [self.aQAQuestions objectAtIndex:indexPath.row];
        
        if(dictQuestion){
            NSString *strAvatarURL = [dictQuestion objectForKey:@"user_url"];
            
            NSString *strName = [dictQuestion objectForKey:@"user_name"];
            
            bool bQA = [dictQuestion objectForKey:@"is_my_question"];
            NSString *strQA = bQA? @"答": @"问";
            
            NSString *strTime = [self getTimeFromEpoch:[dictQuestion objectForKey:@"timestamp"]];
            
            NSString *strTopic = [dictQuestion objectForKey:@"topic_content"];
            
            bool bIsRecord = [dictQuestion objectForKey:@"is_answered"];
            NSString *strImgName = bIsRecord?@"play_24" :@"record_24";
            
            NSDictionary *dictQA = [self setDictionary:strAvatarURL name:strName qa:strQA time:strTime topic:strTopic isRecord:strImgName];
            
            [self setQACell:cell avatarTag:4040 nameTag:4041 qaTag:4042 timeTag:4043 topicTag:4044 recordTag:4045 withDictionary:dictQA];
        }
    }
    return cell;
}

- (NSDictionary *) setDictionary:(NSString *)avatar
                            name:(NSString *)name
                              qa:(NSString *)qa
                            time:(NSString *)time
                           topic:(NSString *)topic
                        isRecord:(NSString *)isRecord
{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"avatar", @"name", @"qa", @"time", @"topic", @"isRecord", nil];
    NSArray *objs = [[NSArray alloc] initWithObjects:avatar, name, qa, time, topic, isRecord, nil];
    
    NSDictionary *dictPeopleQA = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    return dictPeopleQA;
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

- (void)setCellWithNotification: (NSDictionary *)dictNotificaiton
                         inCell: (UITableViewCell *)cell
                      avatarTag: (NSInteger) tagAvatar
                        nameTag: (NSInteger) tagName
                 createdTimeTag: (NSInteger) tagCreatedTime {
    NSDictionary *dictFromUser = [dictNotificaiton objectForKey:@"from_user"];
    // get avatar
    NSString *strAvatar = [dictFromUser objectForKey:@"avatar_url"];
    NSURL *urlAvatar = [NSURL URLWithString:strAvatar];
    // get name
    NSString *strUsername = [dictFromUser objectForKey:@"user_name"];
    // get post time
    NSString *strCreatedTime = [dictNotificaiton objectForKey:@"created_at"];
    
    // set avatar
    UIImageView *imgvAvatar = (UIImageView *)[cell viewWithTag:tagAvatar];
    [UtilityViewController changeImgToCircle:imgvAvatar];
    imgvAvatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlAvatar]];
    // set name
    UILabel *labelName = (UILabel *)[cell viewWithTag:tagName];
    labelName.text = strUsername;
    // set time
    UILabel *labelCreatedTime = (UILabel *)[cell viewWithTag:tagCreatedTime];
    labelCreatedTime.text = [self getTimeFromEpoch:strCreatedTime];
}


- (void) setQACell:(UITableViewCell *)cell
         avatarTag:(NSInteger)profileTag
           nameTag:(NSInteger)nameTag
             qaTag:(NSInteger)qaTag
           timeTag:(NSInteger)timeTag
          topicTag:(NSInteger)topicTag
         recordTag:(NSInteger)recordTag
    withDictionary:(NSDictionary *)dictionaryPeopleQA
{
    NSString *strImgUrl = [dictionaryPeopleQA objectForKey:@"avatar"];
    NSString *strName = [dictionaryPeopleQA objectForKey:@"name"];
    NSString *strQA = [dictionaryPeopleQA objectForKey:@"qa"];
    NSString *strTime = [dictionaryPeopleQA objectForKey:@"time"];
    NSString *strTopic = [dictionaryPeopleQA objectForKey:@"topic"];
    NSString* isRecord = [dictionaryPeopleQA objectForKey:@"isRecord"];
    
    // set profile image
    NSURL *urlImg = [NSURL URLWithString:strImgUrl];
    UIImage *imgAvatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImg]];
    
    UIImageView *imageProfile = (UIImageView *) [cell viewWithTag:profileTag];
    [UtilityViewController changeImgToCircle:imageProfile];
    imageProfile.image = imgAvatar;
    
    // set name
    UILabel *labelName = (UILabel *) [cell viewWithTag:nameTag];
    labelName.text = strName;
    
    // set ask or answer
    UILabel *labelQA = (UILabel *) [cell viewWithTag:qaTag];
    labelQA.text = strQA;
    
    // set time
    UILabel *labelTime = (UILabel *) [cell viewWithTag:timeTag];
    labelTime.text = strTime;
    
    // set topic
    UILabel *labelTopic = (UILabel *) [cell viewWithTag:topicTag];
    labelTopic.text = strTopic;
    
    // set record image
    UIImageView *imageRecord = (UIImageView *) [cell viewWithTag:recordTag];
    imageRecord.image = [UIImage imageNamed:isRecord];
}


- (IBAction)segmentQAChange:(UISegmentedControl *)sender {
    // change tint color
    for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i] isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
        else
        {
            [[sender.subviews objectAtIndex:i] setTintColor:nil];
        }
    }
    
    [self.tableNotification reloadData];
}
@end
