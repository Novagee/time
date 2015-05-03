//
//  RecordingViewController.m
//  TimeImprint
//
//  Created by Paul on 5/3/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "RecordingViewController.h"

@interface RecordingViewController ()

@property (weak, nonatomic) IBOutlet UIView *maskView;

@end

@implementation RecordingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Add Oberserver for screen oriation change
    //
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(interfaceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

#pragma mark - Interface Orientation Methods

- (void)interfaceOrientationChanged:(NSNotification *)notification {
    
    UIDevice *device = notification.object;
    
    if (device.orientation == UIDeviceOrientationLandscapeLeft) {
        
//        [UIView animateWithDuration:1 - 0.618f
//                         animations:^{
//                             
//                             _maskView.alpha = 0.0f;
//                             
//                         }
//                         completion:^(BOOL finished) {
//            
//                             _maskView.hidden = YES;
//                             
//                         }];
        
    }
    
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        CATransition *transition = [[CATransition alloc]init];
        transition.duration = 3.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type = kCATransitionFade;
        
        [self.maskView.layer addAnimation:transition forKey:@""];
        
    }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     

                                     
                                 }];
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {

    return UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
    
}

#pragma mark - Control's Action

- (IBAction)closeButtonTouchUpInside:(id)sender {

    self.tabBarController.tabBar.hidden = NO;
    
    [self.tabBarController setSelectedIndex:0];
    
}

@end
