//
//  FirstViewController.m
//  filter+
//
//  Created by Rohan Bajaj & Apoorv Kulkarni on 4/9/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//


// Camera View


#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
     imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}




// Button to click photo
-(IBAction)TakePhoto{
    
    
    // check if camera exists...to test on simulator
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
        
        
        picker=[[UIImagePickerController alloc] init];
        picker.delegate =self;
        picker.allowsEditing = YES;

        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:NULL];

    }
    else
    {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Camera not available on this device" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        
    }
   
    
    
}



// save photo and put in UIView to show
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    
    
    image= [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [imageView setImage:image];
    
    
   
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [self dismissViewControllerAnimated:YES completion:NULL];
}









- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
