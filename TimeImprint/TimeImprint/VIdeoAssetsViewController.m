//
//  VIdeoAssetsViewController.m
//  TimeImprint
//
//  Created by Paul on 5/5/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "VIdeoAssetsViewController.h"
#import "VideoAssetsCell.h"

@interface VIdeoAssetsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) ALAssetsGroup *group;
@property (strong, nonatomic) NSMutableArray *assets;

@end

@implementation VIdeoAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[VideoAssetsCell class]
            forCellWithReuseIdentifier:@"VideoCell"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self fetchAssetsLibrary];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchAssetsLibrary {
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
                                      ALAssetsFilter *assetsFliter = [ALAssetsFilter allVideos];
                                      [group setAssetsFilter:assetsFliter];
                                      
                                      if (group && group.numberOfAssets) {
                                          
                                          [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                              
                                              if (result) {
                                                  [_assets addObject:result];
                                              }
                                              
                                          }];
                                          
                                      }
                                      
                                      dispatch_async(dispatch_get_main_queue(),
                                                     ^{
                                                        [self.collectionView reloadData];
                                                     });
                                      
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

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return _assets.count;
    
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *videoCellIdentifier = @"VideoCell";
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:videoCellIdentifier forIndexPath:indexPath];
    
    // load the asset for this cell
    //
    ALAsset *asset = self.assets[indexPath.row];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    
    // apply the image to the cell
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
    imageView.image = thumbnail;
    
    return cell;
}


- (IBAction)cancelButtonTouchUpInside:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
