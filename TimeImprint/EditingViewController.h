//
//  EditingViewController.h
//  documentary-video-ios-native
//
//  Created by Bibo on 4/7/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EditingView.h"
#include <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "AddPhotoCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>

@interface EditingViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

{
    EditingView *editingView;
    
    ALAssetsLibrary *library;
    NSArray *imageArray;
    NSMutableArray *mutableArray;
    NSMutableArray *UIImageArray;
    
    AddPhotoCollectionViewCell *cell;
    UIView *photoView;
    
    NSMutableArray *imageMarkArray;
    NSMutableArray *selectedImageArray;
    UIButton *addPhotoBtn;
    BOOL getPhotoStarted;
}

-(void)allPhotosCollected:(NSArray*)imgArray;
@property (nonatomic, strong) UICollectionView *photoCollectionView;

@end
