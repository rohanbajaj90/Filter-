//
//  SecondViewController.m
//  filter+
//
//  Created by Rohan Bajaj & Apoorv Kulkarni on 4/9/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//



// Editing View

#import "SecondViewController.h"
#import <Social/Social.h>


@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize sliderValue=_sliderValue;



// check slider values
double currentValue=0;
double prevValue=0;


// which filter button selected
double currentButton;


// filter sequecne before and after saving
double filtersequence=0;
double invertedfiltersequcne=0;


// check if any image loaded in UIImageView
BOOL currentlyImageOpen=NO;


// max and min values of slider
double maxReached=NO;
double minReached=NO;


BOOL isSet=NO;

// slider value increase and decrease arrows on sides
double incButtonValue;
double decButtonValue;



int total_filtereffects=8;
NSString *filterName;


int CurrentNumberOfEffects=0;
// name of filters in array
NSArray *filerNamesArray[20];


int currentFilterselected=0;
BOOL filterFromSelectionSelected=NO;
BOOL filterOccupied=NO;

BOOL alertForMorethan8FiltersShown=NO;

int filternamesavedatlocation=-1;
int NumberOfFiltersUsed=0;





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // don't stretch image in UIImageView
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    //Labels only to display value
    _sliderValue.userInteractionEnabled = NO;
    _ShowFilterSelection.userInteractionEnabled=NO;
    _FilterSaveConfirmation.userInteractionEnabled=NO;
    
    
   
    _CurrentNumberOfFilterstoShow.enabled = NO;

    
    // first time inititalization
    [self setNamesArrayFirstTime];
    
    
   

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    // to move view up and down when keyboard (dis)appears
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    
    
    // assign background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
  
}




// move everything up
- (void)keyboardDidShow:(NSNotification *)notification
{
    //assign new frame to view
    [self.view setFrame:CGRectMake(0,-25,320,600)];
    
}


// set back to normal
-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,320,600)];
}





- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    
    NSLog(@"Second ViewDidAppear");
    [self loadthepicker];
    
    
}




// put values in UIPickerView
-(void) loadthepicker
{

    NSMutableArray *getarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilerNamesArray"]];
  
    pickerLoaderArray=[[NSMutableArray alloc] init];
    
    for (int j=0; j<20; j++) {
        
        
        
        if ([[getarray objectAtIndex:j] isEqualToString:@"NULL"])
        {
             // do nothing
            
            
        }
        else   // add that filter to pickerLoaderArray
        {
                        
            [pickerLoaderArray addObject:[getarray objectAtIndex:j]];
            
        }
        
     
        
    } // end of for
    

    
    
    
  
        // refresh pickerView
    [pickerView reloadAllComponents];
    
    [pickerView selectRow:0 inComponent:0 animated:NO];
    
    

}



// for UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(NSInteger)component
{
    
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{
    
    return [pickerLoaderArray count];
    
}

-(NSString *)pickerView:(UIPickerView *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [pickerLoaderArray objectAtIndex:row];
}






// To apply a custome filter button
// Take input from Text field
// break sequence
// and apply that particular filter
- (IBAction)applyCustom:(id)sender {
    
    BOOL nameExists=NO;
    
    NSMutableArray *getarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilerNamesArray"]];
     NSMutableArray *getSeqArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilterSeqArray"]];
    
    NSArray *name=getarray;
    NSArray *seq=getSeqArray;
    
    
    // hide the keyboard
    [_CustomFilterToApply resignFirstResponder];
   
    
    
    
    // look for filter matching same name as text field and if found, apply corresponding filter sequence from the other array
    for (int j=0; j<20; j++) {
        
        
        
        if (    [[name objectAtIndex:j] isEqualToString:_CustomFilterToApply.text]  )
        {
        
            NSLog(@"Filter : %@ ...Sequence: %@  at location %d",[name objectAtIndex:j],[seq objectAtIndex:j],j);
            nameExists=YES;
            
            
            double toApplySequence=[[seq objectAtIndex:j] doubleValue];
            int SingleFilter=0;
            
            while (toApplySequence>=10) {
                
                SingleFilter=fmod(toApplySequence,100);
                NSLog(@"Single Filter %d",SingleFilter);
                
                toApplySequence=toApplySequence/100;
                NSLog(@"Reduced requence %f",toApplySequence);
                
                
                
                
                // apply in built filters based on filter sequence saved
                if (SingleFilter==10)       {
                
                
                    //1
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    
                    //2
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    //3
                    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputIntensity", [NSNumber numberWithFloat:0.5], nil];
                    
                    
                    //4
                    CIImage *outputImage = [filter outputImage];
                    
                    
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    //5
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    
                    
                    //6
                    CGImageRelease(cgimg);
                
                
                
                
                }
                
                
                else if (SingleFilter==11)  {
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputIntensity", [NSNumber numberWithFloat:-1], nil];
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                }
                
                
                
                
                else if (SingleFilter==12)  {
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIVignette"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputIntensity", [NSNumber numberWithFloat:0.5], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                
                
                }
               
                
                
                else if (SingleFilter==13)  {
                
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIVignette"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputIntensity", [NSNumber numberWithFloat:-0.5], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                
                }
                
                
                
                
                else if (SingleFilter==14)  {
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputBrightness", [NSNumber numberWithFloat:0.02], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);

                
                
                }
                
                
                else if (SingleFilter==15)  {
                
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputBrightness", [NSNumber numberWithFloat:-0.02], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                
                
                }
                
                
                
                else if (SingleFilter==16)  {
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIVibrance"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputAmount", [NSNumber numberWithFloat:0.5], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                }
                
                
                
                else if (SingleFilter==17)  {
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIVibrance"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputAmount", [NSNumber numberWithFloat:-0.5], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                
                }
                
                
                else if (SingleFilter==18)  {
                
                
                    
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputRadius", [NSNumber numberWithFloat:1.0], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                    
                
                
                }
                
                
                else if (SingleFilter==19)  {
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputRadius", [NSNumber numberWithFloat:-1.0], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);

                
                
                
                
                }
                
                
                else if (SingleFilter==20)  {
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectMono"
                                                  keysAndValues: kCIInputImageKey, beginImage,nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                }
                
                
                else if (SingleFilter==21)  {
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectMono"
                                                  keysAndValues: kCIInputImageKey, beginImage,nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                }
                
                
                else if (SingleFilter==22)  {
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIGammaAdjust"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputPower", [NSNumber numberWithFloat:0.90], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                
                }
                
                
                else if (SingleFilter==23)  {
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIGammaAdjust"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputPower", [NSNumber numberWithFloat:0.75], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                
                
                }
                
                
                else if (SingleFilter==24)  {
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputEV", [NSNumber numberWithFloat:0.20], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                
                
                }
                
                
                
                else if (SingleFilter==25)  {
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputEV", [NSNumber numberWithFloat:0.50], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                
                
                }
                
                
                
                else if (SingleFilter==26)  {
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize"
                                                  keysAndValues: kCIInputImageKey, beginImage,
                                        @"inputLevels", [NSNumber numberWithFloat:6.00], nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);

                
                
                
                }
                
                
                else if (SingleFilter==27)  {
                
                
                    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
                    CIContext *context = [CIContext contextWithOptions:nil];
                    
                    
                    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"
                                                  keysAndValues: kCIInputImageKey, beginImage,nil];
                    
                    
                    CIImage *outputImage = [filter outputImage];
                    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
                    
                    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
                    CGImageRelease(cgimg);
                
                
                
                }

                
            }
            
            
        }
        
        
    }
    
    
    
    if (nameExists==NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No such filter exists" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
    }
    
    if (nameExists==YES) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Filter applied" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
    }
    
    
    
    // put back the placeholder text
    _CustomFilterToApply.text=nil;

    
}





// first time app install and run initialization of FilterName array and FilterSequence array
// runs only once for setting, then only displays occupied filters if any afterwards
-(void) setNamesArrayFirstTime
{

    
    // check if the names array is set
    NSUserDefaults *isnames_arraysettonull = [NSUserDefaults standardUserDefaults];
    
    NSInteger myInt = [isnames_arraysettonull integerForKey:@"set_names_array"];
    
    
    
    // if names array set variable !=2...then set the names array to null...and the set variable to 2
   
    
    if (myInt!=2) {  // 2 is condidtion for value being set for names array..so if not 2, set the array
        
        NSUserDefaults * settingname_arraytonull = [NSUserDefaults standardUserDefaults];
        [settingname_arraytonull setInteger:2 forKey:@"set_names_array"];
        
        // keep track of how many filters out of 20 being used
        NSUserDefaults * Filtersused = [NSUserDefaults standardUserDefaults];
        [Filtersused setInteger:0 forKey:@"FiltersUsed"];
        
        [settingname_arraytonull synchronize];
        [Filtersused synchronize];
        
        NSLog(@"Condition = 2 now..setting");
        
       
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:20];
        NSMutableArray* arrayForFilterSeq = [NSMutableArray arrayWithCapacity:20];

        
       
        
        //put NULL at all 20 location
        for ( int i=0; i<20; i++)
        {
            [array insertObject:@"NULL" atIndex:i];
            [arrayForFilterSeq insertObject:[NSNumber numberWithDouble:8888888888888888] atIndex:i];

        }
        
        
        //save mutable array
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"FilerNamesArray"];
        [[NSUserDefaults standardUserDefaults] setObject:arrayForFilterSeq forKey:@"FilterSeqArray"];
        
       
        
        
        //sync
        [[NSUserDefaults standardUserDefaults]synchronize];
        
         NSLog(@"All position set to NULL in names array and 8 0s in filterseqArray");
        
        
    }
    
    
    
    else if (myInt==2)
    {
        NSLog(@"Already done...array set to null and variable to 2");
        
        
        // retreive it once and check if it's working
        //get back array
        NSMutableArray *getarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilerNamesArray"]];
         NSMutableArray *getSeqArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilterSeqArray"]];
        
       
        // store into normal array
        NSArray *get=getarray;
        
        for (int j=0; j<20; j++) {
            
            
            if ([[get objectAtIndex:j] isEqualToString:@"NULL"])
            {
                
           //        NSLog(@"NULL Retreived %d,%@....Seq %@",j,[get objectAtIndex:j],[getSeqArray objectAtIndex:j]);
                

            }
            else   // show name of filter at that location
            {
                NSLog(@"Existing filter Retreived at location :%d,%@....Seq %@",j,[get objectAtIndex:j],[getSeqArray objectAtIndex:j]);

            }
            
        }
    
    
    
    }  // end of if myInt=2...that is it already has been set once
    
    
    
    
}





// hide keyboard
- (void)dismissKeyboard
{
    [_FilterNameInputField resignFirstResponder];
    [_ShowFilterSelection resignFirstResponder];
    [_CustomFilterToApply resignFirstResponder];
}





// select photo from photo library
- (IBAction)chooseImage:(id)sender
{
    self.imagePicker=[[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    [self.imagePicker setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
    NSLog(@"photo library open");
    
    // new photo being loaded so set filtersequcne = 0
    filtersequence=0;
    
}





// invert the saved filter sequnce to apply in correct order on getting back

-(void) invertFilterSeq
{
    
    double reverseString = 0.0;
    double temp = filtersequence;
    
    while (temp > 0.0)
    {
        double groupMultiplier = 100.0;
        double singleFilter = floor(fmod(temp, groupMultiplier));
        temp = floor(temp / groupMultiplier);
        
        reverseString = reverseString * groupMultiplier + singleFilter;
    }
    
    NSLog(@"reversed string of filter %f", reverseString);
    
    invertedfiltersequcne=reverseString;


}




// save photo to photo library
- (IBAction)savePhoto:(id)sender {
    
    if (currentlyImageOpen==YES) {
        
        UIImageWriteToSavedPhotosAlbum(_imageView.image, nil, nil, nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Saved" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        
        [self invertFilterSeq];

    }
    
    
    else
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No image open" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
    }
        
}





// when saving filter name, save the name in filter names array
// search for first NULL position out of 20 positions
-(void) savethenameinarray {
    
    
     BOOL filternamesaved=NO;
    
    //get back array
    NSMutableArray *getarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilerNamesArray"]];
     NSMutableArray *getSeqArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilterSeqArray"]];
    
    // store into normal array
    NSArray *get=getarray;
    
    
    for (int j=0; j<20; j++) {
        
       
        if ([[get objectAtIndex:j] isEqualToString:@"NULL"] && filternamesaved==NO)
        {
            
            NSLog(@"NULL place found %d,%@",j,[get objectAtIndex:j]);
            
            
            [getarray insertObject:_FilterNameInputField.text atIndex:j];
            
            [self invertFilterSeq];
          [getSeqArray insertObject:[NSNumber numberWithDouble:invertedfiltersequcne] atIndex:j];
            
            
           // save modified array
            [[NSUserDefaults standardUserDefaults] setObject:getarray forKey:@"FilerNamesArray"];
            [[NSUserDefaults standardUserDefaults] setObject:getSeqArray forKey:@"FilterSeqArray"];
            
            //sync
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            filternamesaved=YES;
            
            // use this filternameSaveDatLocation to set value of sequence in it's array.
            filternamesavedatlocation=j;
            NSLog(@" new filter saved at location %d",j);
            
            
            [self loadthepicker];
            
        }
        
    } // end of for


}



// check if some name is entered in the field
// check if some effects have been applied so that they can be saved
// make sure not more than 8 effects applied - DEMO edition app

- (IBAction)FilterNameSave:(id)sender {
    
    if ([_FilterNameInputField.text length] == 0) {  // if no name given in field
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No name given" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
    }
    
    
    else  // if name if given in field
    {
       
        if (CurrentNumberOfEffects==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Can't Save" message: @"No effects applied " delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        }
        
        
        
        else if (CurrentNumberOfEffects>8) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Can't Save" message: @"More than 8 effects applied. " delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
            
            
             [_FilterSaveConfirmation setBackground:[UIImage imageNamed:@"notsaved.png"]];
        }
        
        
        
        else {  // if number of effects applied lie in range 1-8..allowed
        
           
            NSString *input=_FilterNameInputField.text;
            NSLog(@"Filter to save: %@",input);
            
           
            NSUserDefaults *CheckFiltersUsed = [NSUserDefaults standardUserDefaults];
            NSInteger myInt = [CheckFiltersUsed integerForKey:@"FiltersUsed"];
            
           
            if (myInt<=20) {
                
                [CheckFiltersUsed setInteger:myInt+1 forKey:@"FiltersUsed"];
                NSLog(@"Current count of filters used: %ld",myInt+1);   // +1 done to see how many after save
                [CheckFiltersUsed synchronize];
                
                [self savethenameinarray];
                
                
                [ _FilterSaveConfirmation setBackground:[UIImage imageNamed:@"saved.png"]];
                
                 _FilterNameInputField.text=nil;

            }
            
            
            else{  // if 20 filters already occupied
                
                NSLog(@"All filters used..delete some");
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"oops!" message: @"All filters used..delete some! " delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
                
                 [ _FilterSaveConfirmation setBackground:[UIImage imageNamed:@"notsaved.png"]];
            
            }
            
                }
        
        
            }
    
  
    // hide keyboard
    [_FilterNameInputField resignFirstResponder];
    
}







// increase value of selected filter
- (IBAction)sliderIncreaseButton:(id)sender {
    
    _FilterNameInputField.text=nil;
    
    [ _FilterSaveConfirmation setBackground:[UIImage imageNamed:@"nothingnothing"]];
    
    if (currentlyImageOpen==YES && currentButton!=0 && currentButton!=6 && currentButton!=7 && currentButton!= 8 && currentButton!=9 && currentButton!=10) {
        CurrentNumberOfEffects++;
        NSLog(@"Total Effects Till now %d",  CurrentNumberOfEffects);
    }

    
    
    if (currentButton==0 || currentlyImageOpen==NO) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Select a Filter and Image" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
    }
    
    
    NSString *strFromInt = [NSString stringWithFormat:@"%d",CurrentNumberOfEffects];
    _CurrentNumberOfFilterstoShow.text=strFromInt;
    
    if (CurrentNumberOfEffects==8) {
        
        alertForMorethan8FiltersShown=YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Can not save more effects for custom filter \n  Can continue to edit and save image" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        
        
    }
    

    
    [_sliderValue setValue:_sliderValue.value+1.0];
    
   
    
    if (_sliderValue.value==3) {
        maxReached=YES;
    }
    else {
     maxReached=NO;
       // isSet=NO;
    }
    
    currentValue=_sliderValue.value;
    
    incButtonValue=currentValue;
    
    
    if (currentButton==1)
    {
        [self sepia_plus];
    }
    
    if (currentButton==2)
    {
        [self brightness_plus];
    }
    
    if (currentButton==3) {
        [self vignette_plus];
    }
    
    if (currentButton==4) {
        [self vibrance_plus];
    }
    
    if (currentButton==5) {
        [self blur_plus];
    }
    if (currentButton==6) {
        // [self bw_plus];   // single push effects commented
    }
    
    if (currentButton==7) {
        //  [self gamme_plus];
    }
    
    if (currentButton==8) {
        //    [self exp_plus];
    }
    
    if (currentButton==9) {
        //       [self poster_plus];
    }
    
    if (currentButton==10) {
        //         [self colorInvert_plus];
    }
    

    
   
}



// decrease value of selected filter
- (IBAction)sliderDecreaseButton:(id)sender {
    
    
    // no image nothingnothing, only put because "" gives warnings

      _FilterNameInputField.text=nil;
     [_FilterSaveConfirmation setBackground:[UIImage imageNamed:@"nothingnothing"]];
    
    if (currentlyImageOpen==YES && currentButton!=0 && currentButton!=6 && currentButton!=7 && currentButton!= 8 && currentButton!=9 && currentButton!=10) {
        CurrentNumberOfEffects++;
        NSLog(@"Total Effects Till now %d",  CurrentNumberOfEffects);
    }


    
    if (currentButton==0 || currentlyImageOpen==NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Select a Filter and Image" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
    }

    
    
    
    NSString *strFromInt = [NSString stringWithFormat:@"%d",CurrentNumberOfEffects];
    _CurrentNumberOfFilterstoShow.text=strFromInt;
    
    if (CurrentNumberOfEffects==8) {
        
        alertForMorethan8FiltersShown=YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Can't save more effects for custom filter \n  Can continue to edit and save image though!" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
    }
    
    
    
    
    if (isSet==YES) {
        isSet=NO;
    }
    
    [_sliderValue setValue:_sliderValue.value-1.0];
    
    // NSLog(@"Decrease");
    
    currentValue=_sliderValue.value;
    decButtonValue=currentValue;
    
    if (currentButton==1)
    {
        [self sepia_minus];
    }
    
    if (currentButton==2)
    {
        [self brightness_minus];
    }
    
    if (currentButton==3) {
        [self vignette_minus];
    }
    
    if (currentButton==4) {
        [self vignette_minus];
    }
    
    if (currentButton==5) {
        [self blur_minus];
    }
    
    if (currentButton==6) {
        // [self bw_minus];  // single push effects
    }
    
    
    if (currentButton==7) {
        //  [self gamma_minus];
    }
    
    if (currentButton==8) {
        //  [self exp_minus];
    }
    
    if (currentButton==9) {
        //       [self poster_plus];   // poster minus doesn't exist.
    }
    
    if (currentButton==10) {
        //         [self colorInvert_plus];   // colorInvert minus doesn't exist.
    }

    
}


- (IBAction)slidermove:(id)sender {    // only for representational purpose
    
    
}




//
//
// core filters being used
//
//


-(void) sepia_plus   // filter 10
{
    
    if (currentlyImageOpen==YES && isSet==NO) {
        
        if (filtersequence==0) {
            filtersequence=10;
        }
        else{
             filtersequence=filtersequence*100 + 10;
        }
        
        if (maxReached==YES) {
            isSet=YES;
        }
        else isSet=NO;
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }
    
    
    //1
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    
    //2
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //3
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", [NSNumber numberWithFloat:0.5], nil];
    
    
    //4
    CIImage *outputImage = [filter outputImage];
    
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    //5
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
   
    
    //6
    CGImageRelease(cgimg);
}




-(void) sepia_minus  // filter 11
{
    
    if (currentlyImageOpen==YES && decButtonValue>=0) {
        
        if (filtersequence==0) {
            filtersequence=11;
        }
        else{
            filtersequence=filtersequence*100 + 11;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];

    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", [NSNumber numberWithFloat:-1], nil];
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
}



-(void) vignette_plus   // filter 12
{
    
    if (currentlyImageOpen==YES && incButtonValue<=3) {
        
        if (filtersequence==0) {
            filtersequence=12;
        }
        else{
            filtersequence=filtersequence*100 + 12;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIVignette"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", [NSNumber numberWithFloat:0.5], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}


-(void) vignette_minus   // filter 13
{
    
    if (currentlyImageOpen==YES && decButtonValue>=0) {
        
        if (filtersequence==0) {
            filtersequence=13;
        }
        else{
            filtersequence=filtersequence*100 + 13;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIVignette"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", [NSNumber numberWithFloat:-0.5], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}




-(void) brightness_plus    // filter 14
{
    
    if (currentlyImageOpen==YES && incButtonValue<=3) {
        
        if (filtersequence==0) {
            filtersequence=14;
        }
        else{
            filtersequence=filtersequence*100 + 14;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }


    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputBrightness", [NSNumber numberWithFloat:0.02], nil];
    

    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);

}



-(void) brightness_minus // filter 15
{
    
    if (currentlyImageOpen==YES && decButtonValue>=0) {
        
        if (filtersequence==0) {
            filtersequence=15;
        }
        else{
            filtersequence=filtersequence*100 + 15;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }
    
   
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputBrightness", [NSNumber numberWithFloat:-0.02], nil];
    

    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}



-(void) vibrance_plus  // filter 16
{
    
    if (currentlyImageOpen==YES && incButtonValue<=3) {
        
        if (filtersequence==0) {
            filtersequence=16;
        }
        else{
            filtersequence=filtersequence*100 + 16;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIVibrance"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputAmount", [NSNumber numberWithFloat:0.5], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}




-(void) vibrance_minus  // filter 17
{
    
    if (currentlyImageOpen==YES && decButtonValue>=0) {
        
        if (filtersequence==0) {
            filtersequence=17;
        }
        else{
            filtersequence=filtersequence*100 + 17;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIVibrance"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputAmount", [NSNumber numberWithFloat:-0.5], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}




-(void) blur_plus  // filter 18
{
    
    
    if (currentlyImageOpen==YES && incButtonValue<=3) {
        
        if (filtersequence==0) {
            filtersequence=18;
        }
        else{
            filtersequence=filtersequence*100 + 18;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }
    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputRadius", [NSNumber numberWithFloat:1.0], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}



-(void) blur_minus  // filter 19
{
    
    if (currentlyImageOpen==YES && decButtonValue>=0) {
        
        if (filtersequence==0) {
            filtersequence=19;
        }
        else{
            filtersequence=filtersequence*100 + 19;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputRadius", [NSNumber numberWithFloat:-1.0], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}




-(void) bw_plus   // filter 20
{
    
    if (currentlyImageOpen==YES) {
        
        if (filtersequence==0) {
            filtersequence=20;
        }
        else{
            filtersequence=filtersequence*100 + 20;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }
    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectMono"
                                  keysAndValues: kCIInputImageKey, beginImage,nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}



-(void) bw_minus    // filter 21
{
    if (currentlyImageOpen==YES) {
        
        if (filtersequence==0) {
            filtersequence=21;
        }
        else{
            filtersequence=filtersequence*100 + 21;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectMono"
                                  keysAndValues: kCIInputImageKey, beginImage,nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}




-(void) gamme_plus   // filter 22
{
    if (currentlyImageOpen==YES) {
        
        if (filtersequence==0) {
            filtersequence=22;
        }
        else{
            filtersequence=filtersequence*100 + 22;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }
    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGammaAdjust"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputPower", [NSNumber numberWithFloat:0.90], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}




-(void) gamma_minus    // filter 23
{
    
    if (currentlyImageOpen==YES) {
        
        if (filtersequence==0) {
            filtersequence=23;
        }
        else{
            filtersequence=filtersequence*100 + 23;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGammaAdjust"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputPower", [NSNumber numberWithFloat:0.75], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}





-(void) exp_plus    // filter 24
{
    
    if (currentlyImageOpen==YES) {
        
        if (filtersequence==0) {
            filtersequence=24;
        }
        else{
            filtersequence=filtersequence*100 + 24;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputEV", [NSNumber numberWithFloat:0.20], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}




-(void) exp_minus    // filter 25
{
    
    if (currentlyImageOpen==YES) {
        
        if (filtersequence==0) {
            filtersequence=25;
        }
        else{
            filtersequence=filtersequence*100 + 25;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputEV", [NSNumber numberWithFloat:0.50], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}




-(void) poster_plus   // filter 26
{
    if (currentlyImageOpen==YES) {
        
        if (filtersequence==0) {
            filtersequence=26;
        }
        else{
            filtersequence=filtersequence*100 + 26;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputLevels", [NSNumber numberWithFloat:6.00], nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}




-(void) colorInvert_plus   // filter 27
{
    if (currentlyImageOpen==YES) {
        
        if (filtersequence==0) {
            filtersequence=27;
        }
        else{
            filtersequence=filtersequence*100 + 27;
        }
        
        NSLog(@"Filter Sequence %f",filtersequence);
        
    }

    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"
                                  keysAndValues: kCIInputImageKey, beginImage,nil];
    
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    _imageView.image = [UIImage imageWithCGImage:cgimg];  // put the edited pic
    CGImageRelease(cgimg);
    
}



//
//
// buttons to select these effects
//
//


- (IBAction)sepiaButton:(id)sender
{
    [_sliderValue setValue:0.0];
    currentButton=1;

    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];

    _ShowFilterSelection.text=@"Sepia";
    [_ShowFilterSelection resignFirstResponder];
}


- (IBAction)brightnessButton:(id)sender
{
    _ShowFilterSelection.text=@"Brightness";
    [_ShowFilterSelection resignFirstResponder];

    
    [_sliderValue setValue:0.5];

    currentButton=2;
    

    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
}


- (IBAction)vignetteButton:(id)sender
{
    _ShowFilterSelection.text=@"Vignette";
    [_ShowFilterSelection resignFirstResponder];

    [_sliderValue setValue:0.0];

    currentButton=3;
    
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
}


- (IBAction)contrastButton:(id)sender {

    _ShowFilterSelection.text=@"Vibrance";
    [_ShowFilterSelection resignFirstResponder];

    [_sliderValue setValue:0.5];
    currentButton=4;

    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
}


- (IBAction)blurButton:(id)sender {
    
    _ShowFilterSelection.text=@"Blur";
    [_ShowFilterSelection resignFirstResponder];

    [_sliderValue setValue:0.0];
    currentButton=5;
    
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
}


// single push effect buttons

- (IBAction)bwButton:(id)sender {
    
    _FilterNameInputField.text=nil;
    _ShowFilterSelection.text=@"Black & White";
    [_ShowFilterSelection resignFirstResponder];

    currentButton=6;
    [self bw_minus];
    
    if (currentlyImageOpen==YES) {
        
        if (CurrentNumberOfEffects>8 && alertForMorethan8FiltersShown==NO) {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Can not save more effects for custom filter \n  Can continue to edit and save image" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
            
            alertForMorethan8FiltersShown=YES;
        }
        else{
            CurrentNumberOfEffects++;
            NSLog(@"Total Effects Till now %d",  CurrentNumberOfEffects);
        }
        
    }
    else
    {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No image Open" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
    
    }
    

    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    NSString *strFromInt = [NSString stringWithFormat:@"%d",CurrentNumberOfEffects];
    _CurrentNumberOfFilterstoShow.text=strFromInt;
    
}




- (IBAction)gammaButton:(id)sender {
    
    _FilterNameInputField.text=nil;
    _ShowFilterSelection.text=@"Gamma";
    [_ShowFilterSelection resignFirstResponder];

   
    currentButton=7;
    [self gamme_plus];
    
    if (currentlyImageOpen==YES) {
        
        if (CurrentNumberOfEffects>8 && alertForMorethan8FiltersShown==NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Can not save more effects for custom filter \n  Can continue to edit and save image" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
            
            alertForMorethan8FiltersShown=YES;
        }
        else{
            CurrentNumberOfEffects++;
            NSLog(@"Total Effects Till now %d",  CurrentNumberOfEffects);
        }
        
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No image Open" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        
    }
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    NSString *strFromInt = [NSString stringWithFormat:@"%d",CurrentNumberOfEffects];
    _CurrentNumberOfFilterstoShow.text=strFromInt;
}


- (IBAction)expButton:(id)sender {
    
    _FilterNameInputField.text=nil;
    _ShowFilterSelection.text=@"Exposure";
    [_ShowFilterSelection resignFirstResponder];

    
    currentButton=8;
     [self exp_plus];
    
    if (currentlyImageOpen==YES) {
        
        if (CurrentNumberOfEffects>8 && alertForMorethan8FiltersShown==NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Can not save more effects for custom filter \n  Can continue to edit and save image" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
            
            alertForMorethan8FiltersShown=YES;
        }
        else{
            CurrentNumberOfEffects++;
            NSLog(@"Total Effects Till now %d",  CurrentNumberOfEffects);
        }
        
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No image Open" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        
    }
    
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    NSString *strFromInt = [NSString stringWithFormat:@"%d",CurrentNumberOfEffects];
    _CurrentNumberOfFilterstoShow.text=strFromInt;
}




- (IBAction)posterButton:(id)sender {
    
    _FilterNameInputField.text=nil;
    _ShowFilterSelection.text=@"Posterize";
    [_ShowFilterSelection resignFirstResponder];

    
    currentButton=9;
    [self poster_plus];
    
    if (currentlyImageOpen==YES) {
        
        if (CurrentNumberOfEffects>8 && alertForMorethan8FiltersShown==NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Can not save more effects for custom filter \n  Can continue to edit and save image" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
            
            alertForMorethan8FiltersShown=YES;
        }
        else{
            CurrentNumberOfEffects++;
            NSLog(@"Total Effects Till now %d",  CurrentNumberOfEffects);
        }
        
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No image Open" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        
    }
    
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    NSString *strFromInt = [NSString stringWithFormat:@"%d",CurrentNumberOfEffects];
    _CurrentNumberOfFilterstoShow.text=strFromInt;
}


- (IBAction)colorInvertButton:(id)sender {
    
    _FilterNameInputField.text=nil;
    _ShowFilterSelection.text=@"Invert Colors";
    [_ShowFilterSelection resignFirstResponder];

    
    currentButton=10;
    [self colorInvert_plus];
    
    if (currentlyImageOpen==YES) {
        
        if (CurrentNumberOfEffects>8 && alertForMorethan8FiltersShown==NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Can not save more effects for custom filter \n  Can continue to edit and save image" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
            
            alertForMorethan8FiltersShown=YES;
        }
        else{
            CurrentNumberOfEffects++;
            NSLog(@"Total Effects Till now %d",  CurrentNumberOfEffects);
        }
        
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No image Open" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        
    }
    
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    
    NSString *strFromInt = [NSString stringWithFormat:@"%d",CurrentNumberOfEffects];
    _CurrentNumberOfFilterstoShow.text=strFromInt;
}



- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.chosenImage= info[UIImagePickerControllerOriginalImage];
    [self.imageView setImage:self.chosenImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"image picked and opened in UIView");
    
   
    
    _FilterNameInputField.text=nil;
    [_FilterSaveConfirmation setBackground:[UIImage imageNamed:@"nothingnothing"]];
    
    currentlyImageOpen=YES;
    
    self.originalImage=self.imageView.image;
    
    CurrentNumberOfEffects=0;
    
    currentButton=0;
    
    _CurrentNumberOfFilterstoShow.text=@"Maximum Effects is 8";
    
    _ShowFilterSelection.text=@"No Filter Selected";
    
    alertForMorethan8FiltersShown=NO;


    
    

}



// no image selected when photo library open
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources
}



//
//
// share button action sheet
//
//


- (IBAction)Share:(id)sender {

    UIActionSheet *share =[[UIActionSheet alloc] initWithTitle:@"Share Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook it",@"Tweet it", nil];
    
    [share showInView:self.view];
    
    

}

-(void )actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{


    if (buttonIndex==1) {
        
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *tweet= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [tweet addImage:self.imageView.image];
            
            [self presentViewController:tweet animated:YES completion:nil];
            
            
            
        }
        
        else
            
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No twitter account setup on device" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        }
        
    }
    
    
    
    else if (buttonIndex==0) {
        
        
        if (currentlyImageOpen) {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                
                SLComposeViewController *facebook= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [facebook addImage:self.imageView.image];
                
                [self presentViewController:facebook animated:YES completion:nil];
                
            }
            
            else
                
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No facebook account setup on device" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
            }
            

        }
        
        else
        {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No image open" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        
        }
        
            }
    
    
    
}





@end
