//
//  DCImagePickerController.m
//  DCImagePicker
//
//  Created by Paul on 4/24/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#import "DCImagePickerController.h"
#import "DCAssetsContentViewController.h"

@interface DCImagePickerController ()

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) ALAssetsGroup *group;
@property (strong, nonatomic) NSMutableArray *assets;

@end

@implementation DCImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.hidden = YES;
    self.navigationBarHidden = YES;
    
    [self fetchAssetLibrary];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchAssetLibrary {
    
    if (! self.assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc]init];
    }
    if (! self.group) {
        _group = [[ALAssetsGroup alloc]init];
    }
    if (! self.assets) {
        _assets = [[NSMutableArray alloc]init];
    }
    else {
        [_assets removeAllObjects];
    }
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                  usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                      
                                      // We just fetch photos
                                      //
                                      ALAssetsFilter *assetsFliter = [ALAssetsFilter allPhotos];
                                      [group setAssetsFilter:assetsFliter];
                                      
                                      if (group && group.numberOfAssets) {
                                          
                                          [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                              
                                              if (result) {
                                                  [_assets addObject:result];
                                              }
                                              
                                          }];
                                          
                                          // Once the asset fetch complete, present the root view controller
                                          //
                                          DCAssetsContentViewController *assetsContentViewController = [[UIStoryboard storyboardWithName:@"DCImagePicker" bundle:nil] instantiateViewControllerWithIdentifier:@"dcImagePickerContentView"];
                                          assetsContentViewController.assets = self.assets;
                                          
                                          [self setViewControllers:@[assetsContentViewController] animated:YES];
                                          
                                      }
                                      
                                  }
                                failureBlock:^(NSError *error) {
                                    
                                    NSLog(@"Error");
                                    
                                }];
    
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
