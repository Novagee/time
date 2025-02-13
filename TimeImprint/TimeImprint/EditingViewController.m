//
//  EditingViewController.m
//  documentary-video-ios-native
//
//  Created by Bibo on 4/7/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import "EditingViewController.h"
#import "SVProgressHUD.h"
#import "LocationPickerViewController.h"
#import "TimePickerViewController.h"
#import "MainViewController.h"
#import "StoryAPIManager.h"
#import "BrowseViewController.h"
#import "CameraView.h"

#import "ShareHelpers.h"

#import <ALBB_OSS_IOS_SDK/OSSService.h>

static int count=0;

@interface EditingViewController()

@property (nonatomic, assign) NSInteger happenedTime;
@property (nonatomic, assign) NSInteger publishedTime;
@property (nonatomic, assign) NSInteger uploadCount;
@property (nonatomic, strong) NSString *photo1Path;
@property (nonatomic, strong) NSString *photo2Path;
@property (nonatomic, strong) NSString *photo3Path;
@property (nonatomic, strong) NSString *photo4Path;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *videoPreviewPath;

@end

@implementation EditingViewController
{
    OSSBucket *bucket;
    OSSData *ossDownloadData;
    NSString *accessKey;
    NSString *secretKey;
    NSString *yourBucket;
    NSString *yourDownloadObjectKey;
    NSString *yourUploadObjectKey;
    NSString *yourUploadDataPath;
    NSString *yourHostId;
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"TimeDidFinishSetting" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSDictionary *object = note.object;
        if ([object[@"date"] isKindOfClass:[NSDate class]]) {
            {
                if ([object[@"type"]isEqual:@0]) {
                    self.happenedTime = [object[@"date"] timeIntervalSince1970];
                } else {
                    self.publishedTime = [object[@"date"] timeIntervalSince1970];
                }
            }
        }
    }];
    
    
    //    [self addNotifications];
    //    [self setupViewController];
    
    editingView = [[EditingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if (self.storyTitle) {
        editingView.titleTextfield .text = self.storyTitle;
    }
    
    [editingView.publishBtn addTarget:self action:@selector(publishBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editingView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openCameraRollForPhoto) name:@"openCameraRollForPhoto" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tappedOnLocation:) name:@"tappedOnLocation" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tappedOnOccurTime:) name:@"tappedOnOccurTime" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tappedOnPublishTime:) name:@"tappedOnPublishTime" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tappedOnPublish:) name:@"tappedOnPublish" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tappedOnCancel:) name:@"tappedOnCancel" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tappedOnWeChatMoment:) name:@"tappedOnWeChatMoment" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tappedOnWeChatFriend:) name:@"tappedOnWeChatFriend" object:nil];
    
    [self getPictureCount];
    
}

- (OSSData *)getUploadData
{
    secretKey = @"v1J1D4B2czqIdUI9AAba61srbRwGSE";
    accessKey = @"f1VGK8lNHkf0C9Cf";
    yourBucket = @"timeimprint";
    yourUploadDataPath = @"";
    yourHostId = @"oss-us-west-1.aliyuncs.com";
    
    id<ALBBOSSServiceProtocol> ossService = [ALBBOSSServiceProvider getService];
    [ossService setGlobalDefaultBucketAcl:PRIVATE];
    [ossService setGlobalDefaultBucketHostId:yourHostId];
    [ossService setAuthenticationType:ORIGIN_AKSK];
    [ossService setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        signature = [OSSTool calBase64Sha1WithData:content withKey:secretKey];
        signature = [NSString stringWithFormat:@"OSS %@:%@", accessKey, signature];
        NSLog(@"here signature:%@", signature);
        return signature;
    }];
    
    bucket = [ossService getBucket:yourBucket];
    return [ossService getOSSDataWithBucket:bucket key:yourUploadObjectKey];
    //    [ossUploadData enableUploadCheckMd5sum:YES];
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
                         [mutableArray insertObject:url atIndex:0];
                         //                                 NSLog(@"%i", (int)mutableArray.count);
                     }
                     
                     
                     if ([mutableArray count]==count)
                     {
                         if (getPhotoStarted == NO) {
                             
                             //                                     NSLog(@"%i %i", (int)mutableArray.count, (int)count);
                             
//                             NSArray* reversedArray = [[mutableArray reverseObjectEnumerator] allObjects];
                             imageArray=[[NSArray alloc] initWithArray:mutableArray];
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
    
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeImageToSavedPhotosAlbum:((UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]).CGImage
//                                 metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
//                          completionBlock:^(NSURL *assetURL, NSError *error) {
//                              NSLog(@"assetURL %@", assetURL);
    
//                              NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:imageArray];
//                              [tempArray insertObject:assetURL atIndex:0];
//                              imageArray = [NSArray arrayWithArray:tempArray];
                              [UIImageArray insertObject:image atIndex:0];
                              [imageMarkArray insertObject:@"1" atIndex:0];
                              
                              [selectedImageArray insertObject:image atIndex:0];
                              
                              [addPhotoBtn setTitle:[NSString stringWithFormat:@"(%i/4)加照片",(int)selectedImageArray.count] forState:UIControlStateNormal];
                              
                              [_photoCollectionView reloadData];
                              [self dismissViewControllerAnimated:YES completion:nil];
//                          }];
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
    //    [editingView removeFromSuperview];
    //    [self dismissViewControllerAnimated:YES completion:nil];
    //    self.tabBarController.selectedIndex = 0;
}

-(void)tappedOnLocation:(UITapGestureRecognizer *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationPickerViewController *locationPickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"location_picker"];
    locationPickerViewController.title = @"事件发生位置";
    [self presentViewController:locationPickerViewController animated:YES completion:nil];
}

-(void)tappedOnOccurTime:(UITapGestureRecognizer *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TimePickerViewController *time_picker = [storyboard instantiateViewControllerWithIdentifier:@"time_picker"];
    time_picker.happenedTime = HappenTime;
    [self presentViewController:time_picker animated:YES completion:nil];
}

-(void)tappedOnPublishTime:(UITapGestureRecognizer *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TimePickerViewController *time_picker = [storyboard instantiateViewControllerWithIdentifier:@"time_picker"];
    time_picker.happenedTime = PublishTime;
    [self presentViewController:time_picker animated:YES completion:nil];
}

- (void)tappedOnWeChatMoment:(NSNotification *)notification {
    
    [ShareHelpers shareByWechat:YES
                 andSharedTitle:@""
                     sharedBody:@""
                     thumbImage:selectedImageArray.firstObject
                    sharedImage:selectedImageArray.firstObject success:^{
                        NSLog(@"suc");
                    }
                        failure:^{
                            NSLog(@"fail");
                        }];
    
}

- (void)tappedOnWeChatFriend:(NSNotification *)notification {
    
    [ShareHelpers shareByWechat:NO
                 andSharedTitle:@""
                     sharedBody:@""
                     thumbImage:selectedImageArray.firstObject
                    sharedImage:selectedImageArray.firstObject success:^{
                        NSLog(@"suc");
                    }
                        failure:^{
                            NSLog(@"fail");
                        }];
    
}

-(void)tappedOnPublish:(UITapGestureRecognizer *)sender {
    
    
    NSLog(@"camRollURL:%@, camRollThumbNail:%@, movieFile.url:%@",[CameraView shared].camRollURL,[CameraView shared].camRollThumbNail,[CameraView shared].movieFile.url);
    
    [SVProgressHUD show];
    
    if (selectedImageArray && selectedImageArray.count == 4) {
        yourUploadObjectKey = [NSString stringWithFormat:@"userId_photo1_%ld",(long)self.publishedTime];
        self.photo1Path = [NSString stringWithFormat:@"http://timeimprint.oss-us-west-1.aliyuncs.com/%@",yourUploadObjectKey];
        OSSData *uploadData1 = [self getUploadData];
        [self uploadDate:UIImagePNGRepresentation([selectedImageArray objectAtIndex:0]) withType:@"image/jpeg" OSSData:uploadData1];
        
        yourUploadObjectKey = [NSString stringWithFormat:@"userId_photo2_%ld",(long)self.publishedTime];
        self.photo2Path = [NSString stringWithFormat:@"http://timeimprint.oss-us-west-1.aliyuncs.com/%@",yourUploadObjectKey];
        OSSData *uploadData2 = [self getUploadData];
        [self uploadDate:UIImagePNGRepresentation([selectedImageArray objectAtIndex:1]) withType:@"image/jpeg" OSSData:uploadData2];
        
        yourUploadObjectKey = [NSString stringWithFormat:@"userId_photo3_%ld",(long)self.publishedTime];
        self.photo3Path = [NSString stringWithFormat:@"http://timeimprint.oss-us-west-1.aliyuncs.com/%@",yourUploadObjectKey];
        OSSData *uploadData3 = [self getUploadData];
        [self uploadDate:UIImagePNGRepresentation([selectedImageArray objectAtIndex:2]) withType:@"image/jpeg" OSSData:uploadData3];
        
        yourUploadObjectKey = [NSString stringWithFormat:@"userId_photo4_%ld",(long)self.publishedTime];
        self.photo4Path = [NSString stringWithFormat:@"http://timeimprint.oss-us-west-1.aliyuncs.com/%@",yourUploadObjectKey];
        OSSData *uploadData4 = [self getUploadData];
        [self uploadDate:UIImagePNGRepresentation([selectedImageArray objectAtIndex:3]) withType:@"image/jpeg" OSSData:uploadData4];
        self.uploadCount = 6;
    } else {
        self.uploadCount = 2;
    }
    
    yourUploadObjectKey = [NSString stringWithFormat:@"userId_video_%ld.mp4",(long)self.publishedTime];
    self.videoPath = [NSString stringWithFormat:@"http://timeimprint.oss-us-west-1.aliyuncs.com/%@",yourUploadObjectKey];
    OSSData *uploadData = [self getUploadData];
    [self uploadDate:[NSData dataWithContentsOfURL:[CameraView shared].camRollURL] withType:@"video/mpeg4" OSSData:uploadData];
    
    yourUploadObjectKey = [NSString stringWithFormat:@"userId_video_preview_%ld",(long)self.publishedTime];
    self.videoPreviewPath = [NSString stringWithFormat:@"http://timeimprint.oss-us-west-1.aliyuncs.com/%@",yourUploadObjectKey];
    OSSData *uploadDataVideoPreview = [self getUploadData];
    [self uploadDate:UIImagePNGRepresentation([CameraView shared].camRollThumbNail) withType:@"image/jpeg" OSSData:uploadDataVideoPreview];
}

-(void)tappedOnCancel:(UITapGestureRecognizer *)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BrowseViewController *browseViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    [self.view.window setRootViewController:browseViewController];
    self.tabBarController.selectedIndex = 0;

}
- (void)uploadDate:(NSData *)data withType: (NSString *)type OSSData: (OSSData *)uploadData {
    
    [uploadData setData:data withType:type];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [uploadData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                
                self.uploadCount -= 1;
                if (self.uploadCount == 0) {
                    
                    [SVProgressHUD dismiss];
                    
                    StoryAPIManager *api = [StoryAPIManager sharedInstance];
                    [api createWithQuestionID:0 publishTime:self.publishedTime happenTime:self.happenedTime title:editingView.titleTextfield.text location:@"test" question_timestamp:64736 questioner_id:64786 content:editingView.aboutBox.text public:!editingView.privacyBtn.selected videoUrl:self.videoPath videoPreviewUrl:self.videoPreviewPath photo1Url:self.photo1Path photo2Url:self.photo2Path photo3Url:self.photo3Path photo4Url:self.photo4Path success:^(id successResponse) {
                        NSLog(@"Story: %@ created", successResponse[@"story_id"]);
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"ReloadMyStoriesNotification"
                         object:self
                         userInfo:nil];
                        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"成功"
                                                                           message:@"发布成功！"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"知道啦"
                                                                 otherButtonTitles:nil];
                        [theAlert show];
                    } failure:^(id failureResponse, NSError *error) {
                        NSLog(@"%@", failureResponse);
                    }];
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    BrowseViewController *browseViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
                    [self.view.window setRootViewController:browseViewController];
                    self.tabBarController.selectedIndex = 0;
                }
                
            } else {
                NSLog(@"上传失败");
                NSLog(@"失败原因：%@", error);
            }
        } withProgressCallback:^(float progress) {
            NSLog(@"当前进度： %f", progress);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"success");
            });
        }];
    });
}

@end
