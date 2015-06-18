//
//  TopicsViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 5/10/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "TopicsViewController.h"
#import "AskWhoViewController.h"
#import "TopicAPIManager.h"
#import "CameraViewController.h"
#import "UIContants.h"

@interface TopicsViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textFieldCustomTopics;

@property (nonatomic, strong) NSMutableArray *aHottestTopics;
@property (nonatomic, strong) NSMutableArray *aFamilysTopics;
@property (nonatomic, strong) NSMutableArray *aFriendsTopics;
@property (nonatomic, strong) NSMutableArray *aLoveTopics;
@property (nonatomic, strong) NSMutableArray *aSelfTopics;

@property (nonatomic, strong) NSMutableArray *aTopics;

@end

@implementation TopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextField];
    [self setupSegmentedControl];
    
    [self initSet];
    
    // hide keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TopicAPIManager *apiTopic = [TopicAPIManager sharedInstance];
    
    // get hottest topics
    [self getHottestTopics:apiTopic];
    // get family topics
    [self getFamilyTopics:apiTopic];
    // get friends topics
    [self getFriendTopics:apiTopic];
    // get love topics
    [self getLoveTopics:apiTopic];
    // get Self topics
    [self getSelfTopics:apiTopic];
}

- (void)getHottestTopics:(TopicAPIManager *)apiTopic {
    [apiTopic getTopics:TOPIC_TREND start:@0 limit:@10 success:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            [self.aHottestTopics removeAllObjects];
            [self.aHottestTopics addObjectsFromArray: [successResponse objectForKey:@"topics"]];
            
            [self loadTopics:@"热门" questions:self.aHottestTopics];
            [self.topicsTable reloadData];
        }
    }failure:^(id failureResponse, NSError *error){
        NSLog(@"Error: cannot get hottest topics");
    }];
}

- (void)getFamilyTopics:(TopicAPIManager *)apiTopic {
    [apiTopic getTopics:TOPIC_FAMILY start:@0 limit:@10 success:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            [self.aFamilysTopics removeAllObjects];
            [self.aFamilysTopics addObjectsFromArray: [successResponse objectForKey:@"topics"]];
            
            [self loadTopics:@"亲人" questions:self.aFamilysTopics];
            [self.topicsTable reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: cannot get family topics");
    }];
}

- (void)getFriendTopics:(TopicAPIManager *)apiTopic {
    [apiTopic getTopics:TOPIC_FRIEND start:@0 limit:@10 success:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            [self.aFriendsTopics removeAllObjects];
            [self.aFriendsTopics addObjectsFromArray: [successResponse objectForKey:@"topics"]];
            
            [self loadTopics:@"朋友" questions:self.aFriendsTopics];
            [self.topicsTable reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: cannot get friend topics");
    }];
}

- (void)getLoveTopics:(TopicAPIManager *)apiTopic {
    [apiTopic getTopics:TOPIC_LOVE start:@0 limit:@10 success:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            [self.aLoveTopics removeAllObjects];
            [self.aLoveTopics addObjectsFromArray: [successResponse objectForKey:@"topics"]];
            
            [self loadTopics:@"爱情" questions:self.aLoveTopics];
            [self.topicsTable reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: cannot get love topics");
    }];
}

- (void)getSelfTopics:(TopicAPIManager *)apiTopic {
    [apiTopic getTopics:TOPIC_SELF start:@0 limit:@10 success:^(id successResponse) {
        if([successResponse isKindOfClass:[NSDictionary class]]){
            [self.aSelfTopics removeAllObjects];
            [self.aSelfTopics addObjectsFromArray: [successResponse objectForKey:@"topics"]];
            
            [self loadTopics:@"自己" questions:self.aSelfTopics];
            [self.topicsTable reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: cannot get self topics");
    }];
}


// init properties and set table delegate
- (void)initSet {
    // init properties
    self.aHottestTopics = [[NSMutableArray alloc] init];
    self.aFamilysTopics = [[NSMutableArray alloc] init];
    self.aFriendsTopics = [[NSMutableArray alloc] init];
    self.aLoveTopics = [[NSMutableArray alloc] init];
    self.aSelfTopics = [[NSMutableArray alloc] init];
    
    self.aTopics = [[NSMutableArray alloc] init];
    
    // set table delegate
    self.topicsTable.delegate = self;
    self.topicsTable.dataSource = self;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

// text field
- (void)setupTextField {
    // set location
    self.textFieldCustomTopics = [[UITextField alloc] initWithFrame:CGRectMake(15, 75, [[UIScreen mainScreen] bounds].size.width - 130, 37)];
    
    self.textFieldCustomTopics.delegate = self;
    
    // set left view
    self.textFieldCustomTopics.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(21, 81, 32, 30)];
    imageView.image = [UIImage imageNamed:@"write_24.png"];
    self.textFieldCustomTopics.leftView = imageView;
    
    // set back ground color and placeholder
    self.textFieldCustomTopics.backgroundColor = [UIColor whiteColor];
    self.textFieldCustomTopics.placeholder = @"自定义话题";
    
    [self.view addSubview:self.textFieldCustomTopics];
}

// segmented view
- (void) setupSegmentedControl {
    // set font
    UIFont *font = [UIFont fontWithName:@"NotoSansCJKsc-Light" size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    
    [self.segmentedTopics setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    // set border
    self.segmentedTopics.layer.borderWidth = 0.5;
    [self.segmentedTopics.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    // initial selected value
    UIColor *tintcolor=[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
    [[self.segmentedTopics.subviews objectAtIndex:4] setTintColor:tintcolor];
}


// table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.aTopics count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"topicCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(self.aTopics != nil && [self.aTopics count] != 0){
        NSDictionary *dictTopic = [self.aTopics objectAtIndex:indexPath.row];
        
        if(dictTopic){
            // get content
            NSString *strTopicContent = [dictTopic objectForKey:@"content"];
            
            UILabel *labelTopic = (UILabel *)[cell viewWithTag:2001];
            labelTopic.text = strTopicContent;
            
            // get send button
            UIButton *btnSendTopic = (UIButton *)[cell viewWithTag:2002];
            btnSendTopic.tag = indexPath.row + 10000;
            
            
            // get record button
            UIButton *btnRecord = (UIButton *)[cell viewWithTag:2003];
            btnRecord.tag = indexPath.row + 20000;
        }
    }
    
    return cell;
}

- (IBAction)segmentedTopicChange:(UISegmentedControl *)sender {
    NSString *strTopic = @"热门";
    
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
    strTopic = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    
    [self.aTopics removeAllObjects];
    
    if([strTopic isEqualToString:@"自己"]){
        [self.aTopics addObjectsFromArray:self.aSelfTopics];
    }else if([strTopic isEqualToString:@"爱情"]){
        [self.aTopics addObjectsFromArray:self.aLoveTopics];
    }else if([strTopic isEqualToString:@"朋友"]){
        [self.aTopics addObjectsFromArray:self.aFriendsTopics];
    }else if([strTopic isEqualToString:@"亲人"]){
        [self.aTopics addObjectsFromArray:self.aFamilysTopics];
    }else{
        [self.aTopics addObjectsFromArray:self.aHottestTopics];
    }
    
    [self.topicsTable reloadData];
}

- (void)loadTopics: (NSString *)strTopic
         questions: (NSMutableArray *)aQuestions{
    NSString *selectedTopic = [self.segmentedTopics titleForSegmentAtIndex:self.segmentedTopics.selectedSegmentIndex];
    
    if([selectedTopic isEqualToString:strTopic]){
        [self.aTopics removeAllObjects];
        [self.aTopics addObjectsFromArray:aQuestions];
    }
}

// pass data though segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showAskWho"]) {
        AskWhoViewController *askWhoViewController = (AskWhoViewController *)segue.destinationViewController;
        askWhoViewController.strTopic = self.textFieldCustomTopics.text;
    }else if([segue.identifier isEqualToString:@"showRecord"]){
        CameraViewController *cameraViewController = (CameraViewController *)segue.destinationViewController;
        cameraViewController.strTopic = self.textFieldCustomTopics.text;
    }else if([segue.identifier isEqualToString:@"cellShowAskWho"]) {
        UIButton *btnSendTopic = (UIButton *)sender;
        
        NSDictionary *dictTopic = [self.aTopics objectAtIndex:btnSendTopic.tag - 10000];
        if(dictTopic){
            NSString *strTopicContent = [dictTopic objectForKey:@"content"];
            
            AskWhoViewController *askWhoViewController = (AskWhoViewController *)segue.destinationViewController;
            askWhoViewController.strTopic = strTopicContent;
        }
    }else if([segue.identifier isEqualToString:@"cellShowRecord"]) {
        UIButton *btnRecord = (UIButton *)sender;
        
        NSDictionary *dictTopic = [self.aTopics objectAtIndex:btnRecord.tag - 20000];
        if(dictTopic){
            NSString *strTopicContent = [dictTopic objectForKey:@"content"];
            
            CameraViewController *cameraViewController = (CameraViewController *)segue.destinationViewController;
            cameraViewController.strTopic = strTopicContent;
        }
    }
}

@end
