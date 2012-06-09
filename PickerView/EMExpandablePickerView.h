//
//  EMExpandablePickerView.h
//  PickerView
//
//  Created by Emerson Malca on 6/9/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import "AFPickerView.h"

@interface EMExpandablePickerView : AFPickerView

@property (nonatomic, readonly, getter=isExpanded) BOOL expanded;

@end
