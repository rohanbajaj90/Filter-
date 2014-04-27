//
//  FourthViewController.m
//  filter+
//
//  Created by Rohan Bajaj & Apoorv Kulkarni on 4/9/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//


// Delete Custom Filters

#import "FourthViewController.h"

@implementation FourthViewController



//Condition to check if any filter is deleted.
BOOL isFilterDeleted=NO;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"view did Load 4th");
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSLog(@"view did appear 4th");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    
    
    [self loadthepicker];
    
    
}


- (void)dismissKeyboard
{
    [_filterToDelete resignFirstResponder];
}




// refresh the picker with values
-(void) loadthepicker
{
    
    NSMutableArray *getarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilerNamesArray"]];

    
    pickerLoaderArray=[[NSMutableArray alloc] init];
    
  
    
    for (int j=0; j<20; j++) {
        
        
        
        if ([[getarray objectAtIndex:j] isEqualToString:@"NULL"])
        {
            // do nothing..don't load
            
            
        }
        else   // add that filter to pickerLoaderArray
        {
            
            [pickerLoaderArray addObject:[getarray objectAtIndex:j]];
            
            
            
        }
        
        
        
    }
    
    
    
    // refresh the picker
    [pickerView reloadAllComponents];
    
    [pickerView selectRow:0 inComponent:0 animated:NO];
    

    
    
    
}


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





// delete the selected filter if present in text view

- (IBAction)deleteButton:(id)sender {
    
 
    
    
    NSUserDefaults *CheckFiltersUsed = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [CheckFiltersUsed integerForKey:@"FiltersUsed"];
    
   

    
    
    if (myInt<=21 && myInt>0) {
        
        
        
        // get names array
        NSMutableArray *getarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilerNamesArray"]];
       
        isFilterDeleted=NO;
        
        // at location where name matches with selected filter..put NULL
        for (int j=0; j<20; j++) {
            
            
            
            if (    [[getarray objectAtIndex:j] isEqualToString:_filterToDelete.text]    )
            {
                
                // update filters used counter
                NSLog(@"number of filters used before deleting %ld",(long)myInt);
                [CheckFiltersUsed setInteger:myInt-1 forKey:@"FiltersUsed"];
                [CheckFiltersUsed synchronize];

                
                // insert NULL
                NSLog(@"------currently %d is %@",j,[getarray objectAtIndex:j]);
                [getarray removeObjectAtIndex:j];
                [getarray insertObject:@"NULL" atIndex:j];
                NSLog(@"------now %d is %@",j,[getarray objectAtIndex:j]);
                
                NSUserDefaults *CheckFiltersUsed = [NSUserDefaults standardUserDefaults];
                NSInteger myInt = [CheckFiltersUsed integerForKey:@"FiltersUsed"];
                NSLog(@"Filters left to delete %ld",(long)myInt);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"Deleted" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
               
                isFilterDeleted=YES;
                
                [[NSUserDefaults standardUserDefaults] setObject:getarray forKey:@"FilerNamesArray"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                 [self loadthepicker];
                
            }
            
            else
            {
            
                
              //  NSLog(@"No matching filter name");
                
            }
            
            
        } // end of for
        
        
    
        
        if (isFilterDeleted==NO) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No such filter!" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
        }
       
        
        
        
    }
    
    else
    {
        
        NSUserDefaults *CheckFiltersUsed = [NSUserDefaults standardUserDefaults];
        NSInteger myInt = [CheckFiltersUsed integerForKey:@"FiltersUsed"];
        NSLog(@"Empty filter count...!!!... %ld",(long)myInt);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: @"No filter to delete!" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];

    }
    
    
    
    
    // check the values of the array
    
    NSMutableArray *checkarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilerNamesArray"]];
    
    NSArray *check=checkarray;
    
    
    for (int j=0; j<20; j++) {
        
        
        
        if ([[check objectAtIndex:j] isEqualToString:@"NULL"])
        {
            
                    NSLog(@"Check - NULL Retreived at %d,%@....",j,[check objectAtIndex:j]);
            
            
        }
        else   // show name of filter at that location
        {
            NSLog(@"Check: Existing  Retreived at :%d,%@....",j,[check objectAtIndex:j]);
            
        }
        

    
    }
    
    _filterToDelete.text=nil;
    [_filterToDelete resignFirstResponder];
    
}



@end


