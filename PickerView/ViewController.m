//
//  ViewController.m
//  PickerView
//
//  Created by Fraerman Arkady on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark - Synthesizatoin

@synthesize numberLabel;
@synthesize dayLabel;




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    daysData = [[NSArray alloc] initWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    
    defaultPickerView = [[AFNumberPickerView alloc] initWithFrame:CGRectMake(30.0, 30.0, 126.0, 197.0)];
    defaultPickerView.delegate = self;
    [defaultPickerView setMaxNumber:50];
    [defaultPickerView setShadowsImage:[UIImage imageNamed:@"pickerShadows.png"]];
    [defaultPickerView setSelectionIndicatorImage:[UIImage imageNamed:@"pickerGlass.png"]];
    defaultPickerView.backgroundColor = [UIColor whiteColor];
    [defaultPickerView setCornerRadius:5];
    [defaultPickerView reloadData];
    [defaultPickerView setNumber:25];
    [self.view addSubview:defaultPickerView];
    
    daysPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(30.0, 250.0, 126.0, 197.0)];
    daysPickerView.dataSource = self;
    daysPickerView.delegate = self;
    [daysPickerView setShadowsImage:[UIImage imageNamed:@"pickerShadows.png"]];
    [daysPickerView setSelectionIndicatorImage:[UIImage imageNamed:@"pickerGlass.png"]];
    daysPickerView.rowFont = [UIFont boldSystemFontOfSize:19.0];
    daysPickerView.rowIndent = 10.0;
    [daysPickerView reloadData];
    [self.view addSubview:daysPickerView];
}




#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView
{
    return [daysData count];
}




- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row
{
    return [daysData objectAtIndex:row];
}

#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row
{
    if (pickerView == daysPickerView)
        self.dayLabel.text = [daysData objectAtIndex:row];
    else
        self.numberLabel.text = [NSString stringWithFormat:@"%i", row + 1];
}




#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}




- (void)viewDidUnload
{
    [self setNumberLabel:nil];
    [self setDayLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
