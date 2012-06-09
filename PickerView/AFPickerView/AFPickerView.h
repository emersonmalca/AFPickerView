//
//  AFPickerView.h
//  PickerView
//
//  Created by Fraerman Arkady on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol AFPickerViewDataSource;
@protocol AFPickerViewDelegate;

@interface AFPickerView : UIView <UIScrollViewDelegate>
{
    __unsafe_unretained id <AFPickerViewDataSource> _dataSource;
    __unsafe_unretained id <AFPickerViewDelegate> _delegate;
    
    UIImageView *_shadows;
    UIScrollView *_contentView;
    UIImageView *_selectionIndicator;
    
    int rowsCount; 
    
    CGPoint previousOffset;
    BOOL isScrollingUp;
    
    // recycling
    NSMutableSet *recycledViews;
    NSMutableSet *visibleViews;
    
    UIFont *_rowFont;
    CGFloat _rowIndent;
    NSInteger _numOfFillerRows;
    CGFloat _rowHeight;
    int currentRow;

}

@property (nonatomic, unsafe_unretained) id <AFPickerViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id <AFPickerViewDelegate> delegate;
@property (nonatomic, unsafe_unretained) int selectedRow;
@property (nonatomic, strong) UIFont *rowFont;
@property (nonatomic, unsafe_unretained) CGFloat rowIndent;
@property (nonatomic, unsafe_unretained) CGFloat rowHeight;

- (void)setShadowsImage:(UIImage *)image;
- (void)setCornerRadius:(CGFloat)radius;
- (void)setSelectionIndicatorImage:(UIImage *)image;
- (void)reloadData;

@end



@protocol AFPickerViewDataSource <NSObject>

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView;
- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row;

@end



@protocol AFPickerViewDelegate <NSObject>
@optional
- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row;
- (Class)labelClassForPickerView:(AFPickerView *)pickerView;
- (void)pickerView:(AFPickerView *)pickerView willDisplayLabel:(UILabel *)label forRowAtIndex:(NSInteger *)index;
@end