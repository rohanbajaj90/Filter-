//
//  SecondViewController.h
//  filter+
//
//  Created by Rohan Bajaj & Apoorv Kulkarni on 4/9/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>

@interface SecondViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>


{

    
    IBOutlet UIPickerView *pickerView;
    NSMutableArray *pickerLoaderArray;

    
    
}




@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImage *chosenImage;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property(strong, nonatomic)UIImage *originalImage;



@property (retain, nonatomic) IBOutlet UISlider *sliderValue;


@property (strong, nonatomic) IBOutlet UITextField *FilterNameInputField;
@property (strong, nonatomic) IBOutlet UITextField *FilterSaveConfirmation;
@property (strong, nonatomic) IBOutlet UITextField *CurrentNumberOfFilterstoShow;
@property (strong, nonatomic) IBOutlet UITextField *ShowFilterSelection;
@property (strong, nonatomic) IBOutlet UITextField *CustomFilterToApply;



- (IBAction)FilterNameSave:(id)sender;


- (IBAction)Share:(id)sender;


@end
