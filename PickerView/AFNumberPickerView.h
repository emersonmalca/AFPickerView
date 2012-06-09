//
//  AFNumberPickerView.h
//  PickerView
//
//  Created by Emerson Malca on 6/9/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import "AFPickerView.h"

@interface AFNumberPickerView : AFPickerView <AFPickerViewDataSource>

@property (nonatomic, unsafe_unretained) NSInteger maxNumber;

- (void)setNumber:(NSInteger)number;

@end
