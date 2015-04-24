//
//  DCImagePickerPhotoViewController.m
//  DCImagePicker
//
//  Created by Paul on 4/25/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#import "DCImagePickerPhotoViewController.h"

@interface DCImagePickerPhotoViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DCImagePickerPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView.image = self.image;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonTuuchUpInside:(id)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)saveButtonTouchUpInside:(id)sender {
 
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
