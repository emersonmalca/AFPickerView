//
//  AFNumberPickerView.m
//  PickerView
//
//  Created by Emerson Malca on 6/9/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import "AFNumberPickerView.h"

@implementation AFNumberPickerView

@synthesize maxNumber=_maxNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataSource = self;
    }
    return self;
}

- (void)setNumber:(NSInteger)number {
    [self setSelectedRow:number-1];
}

#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView {
    return _maxNumber;
}




- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%i", row + 1];
}


@end
