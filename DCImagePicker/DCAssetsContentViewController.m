//
//  DCAssetsContentViewController.m
//  DCImagePicker
//
//  Created by Paul on 4/25/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#import "DCAssetsContentViewController.h"
#import "DCImagePickerPhotoViewController.h"

#import "DCImagePickerCameraCell.h"
#import "DCImagePickerImageCell.h"

@interface DCAssetsContentViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DCAssetsContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Asset: %@", self.assets);
    
    [self.collectionView registerClass:[DCImagePickerCameraCell class] forCellWithReuseIdentifier:@"DCImagePickerCamera"];
    [self.collectionView registerClass:[DCImagePickerImageCell class] forCellWithReuseIdentifier:@"DCImagePickerImageCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.assets.count + 1;
    
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cameraCellIdentifier = @"CameraCell";
    static NSString *CellIdentifier = @"PhotoCell";
    
    if (indexPath.row == 0) {
        UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cameraCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // load the asset for this cell
    ALAsset *asset = self.assets[indexPath.row - 1];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    
    // apply the image to the cell
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
    imageView.image = thumbnail;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showPhoto"]) {
        
        DCImagePickerPhotoViewController *imagePickerPhotoViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        
        // Present a full size photo
        //
        ALAsset *photoAsset = self.assets[indexPath.row - 1];
        ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
        
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                       scale:[assetRepresentation scale]
                                                 orientation:UIImageOrientationUp];

        
        imagePickerPhotoViewController.image = fullScreenImage;
        
    }
    
}


@end
