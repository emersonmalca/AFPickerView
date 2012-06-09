//
//  EMExpandablePickerView.m
//  PickerView
//
//  Created by Emerson Malca on 6/9/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import "EMExpandablePickerView.h"

@interface AFPickerView ()

- (void)makeSteps:(int)steps;
- (void)tileViews;

@end

@implementation EMExpandablePickerView {
    
}

@synthesize expanded=_expanded;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _expanded = NO;
    }
    return self;
}

- (void)didTap:(id)sender
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    CGPoint point = [tapRecognizer locationInView:self];
    int steps = floor(point.y / self.rowHeight) - _numOfFillerRows;
    if (steps == 0) {
        //We didn't move, the user tapped on the selected row
        [self switchExpandedState];
    } else {
        [self makeSteps:steps];
    }
}

- (void)switchExpandedState {
    if (_expanded) {
        [self expandToTotalVisibleRows:1];
    } else {
        [self expandToTotalVisibleRows:3];
    }
    _expanded = !_expanded;
}

- (void)expandToTotalVisibleRows:(NSInteger)totalVisibleRows {
    CGFloat height = totalVisibleRows*self.rowHeight;
    CGRect frame = self.frame;
    frame.origin.y = frame.origin.y + (frame.size.height - height)/2;
    frame.size.height = height;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = frame;
                         [self reloadData];
                     }
                     completion:NULL];
}

@end
