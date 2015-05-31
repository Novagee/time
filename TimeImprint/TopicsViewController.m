//
//  TopicsViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 5/10/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "TopicsViewController.h"
#import "AskWhoViewController.h"

@interface TopicsViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSString *strTopic;
@property (nonatomic, strong) UITextField *textFieldCustomTopics;

@end

@implementation TopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextField];
    [self setupSegmentedControl];
    
    self.topicsTable.delegate = self;
    self.topicsTable.dataSource = self;
    
    // hide keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(21, 81, 35, 30)];
    imageView.image = [UIImage imageNamed:@"write_24.png"];
    self.textFieldCustomTopics.leftView = imageView;
    
    // set back ground color and placeholder
    self.textFieldCustomTopics.backgroundColor = [UIColor whiteColor];
    self.textFieldCustomTopics.placeholder = @"自定义话题";
        
    [self.view addSubview:self.textFieldCustomTopics];
    
    self.strTopic = @"10秒内即将消失的时刻";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"topicCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *labelTopic = (UILabel *)[cell viewWithTag:2001];
    labelTopic.text = self.strTopic;
    
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
    
    if([strTopic isEqualToString:@"同事"]){
        self.strTopic = @"一句话证明你喜欢我们公司";
    }else if([strTopic isEqualToString:@"爱情"]){
        self.strTopic = @"一句话对ta表白";
    }else if([strTopic isEqualToString:@"朋友"]){
        self.strTopic = @"一句话证明你是最屌的屌丝";
    }else if([strTopic isEqualToString:@"亲人"]){
        self.strTopic = @"一句话总结对奶奶的映像";
    }else{
        self.strTopic = @"10秒内即将消失的时刻";
    }
    
    [self.topicsTable reloadData];
}

// pass data though segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showAskWho"]) {
        AskWhoViewController *askWhoViewController = (AskWhoViewController *)segue.destinationViewController;
        askWhoViewController.strTopic = self.textFieldCustomTopics.text;
    }else if([segue.identifier isEqualToString:@"cellShowAskWho"]) {
        AskWhoViewController *askWhoViewController = (AskWhoViewController *)segue.destinationViewController;
        askWhoViewController.strTopic = self.strTopic;
    }
}

@end
