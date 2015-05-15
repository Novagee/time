//
//  EditingViewController.m
//  documentary-video-ios-native
//
//  Created by Bibo on 4/7/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import "EditingViewController.h"
#import "SVProgressHUD.h"

static int count=0;

@implementation EditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    
//    [self addNotifications];
//    [self setupViewController];
    
    editingView = [[EditingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [editingView.publishBtn addTarget:self action:@selector(publishBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editingView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openCameraRollForPhoto) name:@"openCameraRollForPhoto" object:nil];
    
    [self getPictureCount];
}

-(void)openCameraRoll {
    UIImagePickerController *picker= [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];

}

-(void)openCameraRollForPhoto {
    
    [self getAllPictures];
}

-(void)getPictureCount {
    mutableArray =[[NSMutableArray alloc]init];
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if(result != nil)
        {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                
                [library assetForURL:url
                         resultBlock:^(ALAsset *asset)
                 {
                     if (url && url.absoluteString.length > 5) {
                         [mutableArray addObject:url];
                         count = (int)mutableArray.count;
//                         NSLog(@"%i", (int)count);
                     }
                 }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!");
                        } ];
            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop)
    {
        if(group != nil)
        {
            [group enumerateAssetsUsingBlock:assetEnumerator];
            //            [assetGroups addObject:group];
            //            count=[group numberOfAssets];
        }
    };
    //
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error)
     {
         NSLog(@"There is an error");
     }];
}

//-(void)getAllPictures
//{
//    mutableArray =[[NSMutableArray alloc]init];
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    
//    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
//    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        
//        // Within the group enumeration block, filter to enumerate just photos.
//        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
//        
//        // Chooses the photo at the last index
//        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
//            // The end of the enumeration is signaled by asset == nil.
//            if (alAsset) {
//                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
//                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
//                
//                
//                UIImage *latestPhotoThumbnail =  [UIImage imageWithCGImage:[alAsset thumbnail]];
//                [mutableArray addObject:latestPhotoThumbnail];
//                NSLog(@"%i", (int)mutableArray.count);
//                
//                // Stop the enumerations
//                *stop = YES; *innerStop = YES;
//                
//                // Do something interesting with the AV asset.
//                //[self sendTweet:latestPhoto];
//            }
//        }];
//    } failureBlock: ^(NSError *error) {
//        // Typically you should handle an error more gracefully than this.
//        NSLog(@"No groups");
//    }];
//}

-(void)getAllPictures
{
    getPhotoStarted = NO;
    imageArray=[[NSArray alloc] init];
    mutableArray =[[NSMutableArray alloc]init];
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    [SVProgressHUD show];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        
        
        if(result != nil)
        {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
//                if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo])
//                {
//                    
//                    if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeUnknown])
//                    {
                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        
                        NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                        
                        [library assetForURL:url
                                 resultBlock:^(ALAsset *asset)
                         {
//                             [mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                             if (url && url.absoluteString.length > 5) {
                                 [mutableArray addObject:url];
//                                 NSLog(@"%i", (int)mutableArray.count);
                             }
                             
                             
                             if ([mutableArray count]==count)
                             {
                                 if (getPhotoStarted == NO) {
                                     
//                                     NSLog(@"%i %i", (int)mutableArray.count, (int)count);
                                     
                                     NSArray* reversedArray = [[mutableArray reverseObjectEnumerator] allObjects];
                                     imageArray=[[NSArray alloc] initWithArray:reversedArray];
                                     [SVProgressHUD dismiss];
                                     [self allPhotosCollected:imageArray];
                                     getPhotoStarted = YES;
                                 }
                             }
                         }
                                failureBlock:^(NSError *error){
                                    NSLog(@"operation was not successfull!");
                                    [SVProgressHUD dismiss];
                                }
                         ];
                
            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop)
    {
        if(group != nil)
        {
            [group enumerateAssetsUsingBlock:assetEnumerator];
//            [assetGroups addObject:group];
//            count=[group numberOfAssets];
        }
    };
//
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error)
    {
        NSLog(@"There is an error");
    }];
}

-(void)allPhotosCollected:(NSArray*)imgArray
{
    //write your code here after getting all the photos from library...
//    NSLog(@"all pictures are %@",imgArray);
    
    [self showPhotoCollectionPickerView];
}

-(void)showPhotoCollectionPickerView {
    
    [SVProgressHUD show];
    
    photoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:photoView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    titleLabel.text = @"选择照片";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [photoView addSubview:titleLabel];
    
    addPhotoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addPhotoBtn.frame = CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64);
    [addPhotoBtn setTitle:@"(0/4)加照片" forState:UIControlStateNormal];
    addPhotoBtn.backgroundColor = [UIColor darkGrayColor];
    addPhotoBtn.tintColor = [UIColor whiteColor];
    [addPhotoBtn addTarget:self action:@selector(addPhotoBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [photoView addSubview:addPhotoBtn];
    
    UIImageArray = [NSMutableArray new];
    selectedImageArray = [NSMutableArray new];
    imageMarkArray = [NSMutableArray new];
    
    for (int i = 0; i < imageArray.count; i++) {
        [self addImageWithIndex:i];
        [imageMarkArray addObject:@"0"];
    }
    
    [SVProgressHUD dismiss];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArray.count+1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width-10)/4, (self.view.frame.size.width-10)/4);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self openCameraRoll];
    }
    else {
    if ([imageMarkArray[indexPath.row-1]integerValue] == 0) {
        
        if (selectedImageArray.count <4) {
            [imageMarkArray replaceObjectAtIndex:indexPath.row-1 withObject:@"1"];
            NSIndexPath *path = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
            [_photoCollectionView reloadItemsAtIndexPaths:@[path]];
            [selectedImageArray addObject:UIImageArray[indexPath.row-1]];
            
        }
        else {
            
        }
        
    }
    else {
        [selectedImageArray removeObject:UIImageArray[indexPath.row-1]];
        [imageMarkArray replaceObjectAtIndex:indexPath.row-1 withObject:@"0"];
        NSIndexPath *path = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
        [_photoCollectionView reloadItemsAtIndexPaths:@[path]];
    }
    
    [addPhotoBtn setTitle:[NSString stringWithFormat:@"(%i/4)加照片",(int)selectedImageArray.count] forState:UIControlStateNormal];
    }
//    NSLog(@"%@", selectedImageArray);
}

-(void)addPhotoBtnPressed {
    
    
    if (selectedImageArray.count == 4) {
        editingView.photoImageOne.image = selectedImageArray[0];
        editingView.photoImageTwo.image = selectedImageArray[1];
        editingView.photoImageThree.image = selectedImageArray[2];
        editingView.photoImageFour.image = selectedImageArray[3];
        [photoView removeFromSuperview];
    }
    else {
        
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
//    NSLog(@"%i", (int)imageMarkArray[indexPath.row]);
    
    if (indexPath.row == 0) {
        cell.photoImageView.image = [UIImage imageNamed:@"cameraWhite"];
        cell.imageCheckMark.hidden = YES;
    }
    else {
        
    cell.photoImageView.image = UIImageArray[indexPath.row-1];
    cell.imageCheckMark.hidden = NO;
        
//    NSLog(@"%@", imageMarkArray);
        
    if ([imageMarkArray[indexPath.row-1]integerValue] == 1) {
        cell.imageCheckMark.image = [UIImage imageNamed:@"preferences-check-on@2x.png"];
    }
    else {
        cell.imageCheckMark.image = [UIImage imageNamed:@"preferences-check-off@2x.png"];
    }
    
    }
    
    return cell;
}

-(void)addImageWithIndex:(NSInteger)index {
    NSURL *url = imageArray[index];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, index*70, 70, 70)];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
//    NSData *data = [[NSData alloc]initWithContentsOfURL:url];
    
//    [self.view addSubview:image];
    
    [library assetForURL:url
             resultBlock:^(ALAsset *asset)
     {
         if(asset){
             image.image =  [UIImage imageWithCGImage:[asset thumbnail]];
             
             //         image.image = [UIImage imageWithCGImage:[[asset defaultRepresentation]fullScreenImage]];
             [UIImageArray addObject:image.image];

         }
         
         if (index == imageArray.count-1) {
             UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
             layout.scrollDirection = UICollectionViewScrollDirectionVertical;
             layout.minimumInteritemSpacing = 0;
             layout.minimumLineSpacing = 5;
             layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
             _photoCollectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
             _photoCollectionView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-128);
             [_photoCollectionView setDataSource:self];
             [_photoCollectionView setDelegate:self];
             [_photoCollectionView registerClass:[AddPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
             [_photoCollectionView setBackgroundColor:[UIColor whiteColor]];
             _photoCollectionView.tag = 3;
             [photoView addSubview:_photoCollectionView];
             
//             NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:imageArray.count-1 inSection:0];
//             [_photoCollectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
         }
         //                             [mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
//         [mutableArray addObject:url];
//         
//         if ([mutableArray count]==count)
//         {
//             imageArray=[[NSArray alloc] initWithArray:mutableArray];
//             [self allPhotosCollected:imageArray];
//         }
     }
            failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!");
    } ];
    
//    NSLog(@"%@", url);
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"whichPhotoFrame"] == 1) {
//        editingView.photoImageOne.image = image;
//    }
//    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"whichPhotoFrame"] == 2) {
//        editingView.photoImageTwo.image = image;
//    }
//    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"whichPhotoFrame"] == 3) {
//        editingView.photoImageThree.image = image;
//    }
//    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"whichPhotoFrame"] == 4) {
//        editingView.photoImageFour.image = image;
//    }
//    [photoView removeFromSuperview];
//    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
//    NSString *imageName = [imagePath lastPathComponent];
//    
//    count = count + 1;
//    NSURL* imageUrl = [info valueForKey:UIImagePickerControllerMediaURL];
//    NSLog(@"%@",imagePath);
//    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
//    {
//        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
//        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
//    };
//    
//    // get the asset library and fetch the asset based on the ref url (pass in block above)
//    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
//    [assetslibrary assetForURL:imagePath resultBlock:resultblock failureBlock:nil];
    
//    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:imageArray];
//    [tempArray addObject:imageUrl];
//    [_photoCollectionView reloadData];
    
//    [photoView removeFromSuperview];
//    [self getAllPictures];
//
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum([info objectForKey:@"UIImagePickerControllerOriginalImage"], nil, nil, nil);
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:((UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]).CGImage
                                 metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              NSLog(@"assetURL %@", assetURL);
                              NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:imageArray];
                              [tempArray addObject:assetURL];
                              imageArray = [NSArray arrayWithArray:tempArray];
                              [UIImageArray addObject:image];
                              [imageMarkArray addObject:@"1"];
                              
                              [selectedImageArray addObject:image];
                              [addPhotoBtn setTitle:[NSString stringWithFormat:@"(%i/4)加照片",(int)selectedImageArray.count] forState:UIControlStateNormal];
                              
                              [_photoCollectionView reloadData];
                              [self dismissViewControllerAnimated:YES completion:nil];
                          }];
//    UIImageWriteToSavedPhotosAlbum(image,
//                                   self,
//                                   @selector(finishSaving),
//                                   nil);
//    
//    NSURL *refURL = [info valueForKey:UIImagePickerControllerMediaURL];
//    
//    // define the block to call when we get the asset based on the url (below)
//    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
//    {
//        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
//        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
//        [self dismissViewControllerAnimated:YES completion:nil];
//    };
//    // get the asset library and fetch the asset based on the ref url (pass in block above)
//    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
//    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
}

-(void)finishSaving {
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)publishBtnPressed {
    [editingView removeFromSuperview];
}

@end
