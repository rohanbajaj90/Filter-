//
//  FourthViewController.h
//  filter+
//
//  Created by Rohan Bajaj & Apoorv Kulkarni on 4/9/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

// Delete Custom Filters


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FourthViewController : UIViewController
{
    IBOutlet UIPickerView *pickerView;
    NSMutableArray *pickerLoaderArray;
    
}


@property (strong, nonatomic) IBOutlet UITextField *filterToDelete;

@end
