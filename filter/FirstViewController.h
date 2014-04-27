//
//  FirstViewController.h
//  filter+
//
//  Created by Rohan Bajaj & Apoorv Kulkarni on 4/9/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//


// Camera View

#import <UIKit/UIKit.h>




@interface FirstViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    UIImagePickerController *picker;
    UIImage *image;
    
    IBOutlet UIImageView *imageView;
    

}


-(IBAction)TakePhoto;

@end
