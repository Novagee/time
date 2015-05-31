//
//  NotificationViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 5/15/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "NotificationViewController.h"
#import "UtilityViewController.h"

@interface NotificationViewController ()

@property (strong, nonatomic) NSDictionary *dictJason;
@property (strong, nonatomic) NSDictionary *dictHockey;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSegmentedControl];
    
    self.tableNotification.delegate = self;
    self.tableNotification.dataSource = self;
    
    self.dictJason = [[NSDictionary alloc] init];
    self.dictHockey = [[NSDictionary alloc] init];
    self.dictJason = [self setDictionary:@"Jason" :@"答" :@"12:34AM" :@"一句话证明你是最屌的屌丝" :@"play_24"];
    self.dictHockey = [self setDictionary:@"hockey" :@"问" :@"4月26日" :@"你对另一半做的最浪漫的事情" :@"record_24"];
}

- (NSDictionary *) setDictionary:(NSString *)name
                      :(NSString *)qa
                      :(NSString *)time
                      :(NSString *)topic
                      :(NSString *)isRecord
{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"name", @"qa", @"time", @"topic", @"isRecord", nil];
    NSArray *objs = [[NSArray alloc] initWithObjects:name, qa, time, topic, isRecord, nil];
    
    NSDictionary *dictPeopleQA = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    return dictPeopleQA;
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
        return 3;
    }else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[self.segmentedNotification.subviews objectAtIndex:0] isSelected]){
        switch (indexPath.row) {
            case 0:
                return 80;
                break;
            case 1:
                return 80;
            default:
                return 100;
                break;
        }
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
        if(indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:followIden];
            
            UIButton *btnFollow = (UIButton *)[cell viewWithTag:4014];
            [btnFollow setImage:[UIImage imageNamed:@"follow_18.png"] forState:UIControlStateNormal];
            
            UIImage *image = [UIImage imageNamed:@"me_followed_24.png"];
            image = [UtilityViewController changeImage:image withColor:[UIColor blackColor]];
            [btnFollow setImage:image forState:UIControlStateSelected];
            [btnFollow addTarget:self action:@selector(onFollowFriend:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if(indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:likeIden];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:commentIden];
        }
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:qaIden];
        if(indexPath.row == 0){
            [self setQACell:cell :4040 :4041 :4042 :4043 :4044 :4045 withDictionary:self.dictJason];
        }else{
            [self setQACell:cell :4040 :4041 :4042 :4043 :4044 :4045 withDictionary:self.dictHockey];
        }
    }
    
    return cell;
}

- (void) onFollowFriend: (UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (void) setQACell:(UITableViewCell *)cell
                  :(NSInteger)profileTag
                  :(NSInteger)nameTag
                  :(NSInteger)qaTag
                  :(NSInteger)timeTag
                  :(NSInteger)topicTag
                  :(NSInteger)recordTag
    withDictionary:(NSDictionary *)dictionaryPeopleQA
{
    NSString *strName = [dictionaryPeopleQA objectForKey:@"name"];
    NSString *strQA = [dictionaryPeopleQA objectForKey:@"qa"];
    NSString *strTime = [dictionaryPeopleQA objectForKey:@"time"];
    NSString *strTopic = [dictionaryPeopleQA objectForKey:@"topic"];
    NSString* isRecord = [dictionaryPeopleQA objectForKey:@"isRecord"];
    
    // set profile image
    UIImageView *imageProfile = (UIImageView *) [cell viewWithTag:profileTag];
    imageProfile.image = [UIImage imageNamed:strName];
    
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
//    NSString *strImageName = isRecord? @"play_24" :@"record_24";
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
