//
//  AFPickerView.m
//  PickerView
//
//  Created by Fraerman Arkady on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AFPickerView.h"
#import <QuartzCore/QuartzCore.h>

@interface AFPickerView ()

- (void)setup;
- (void)determineCurrentRow;
- (void)didTap:(id)sender;
- (void)makeSteps:(int)steps;

// recycle queue
- (UIView *)dequeueRecycledView;
- (BOOL)isDisplayingViewForIndex:(NSUInteger)index;
- (void)tileViews;
- (void)configureView:(UIView *)view atIndex:(NSUInteger)index;

@end

@implementation AFPickerView {
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
}

#pragma mark - Synthesization

@synthesize dataSource=_dataSource;
@synthesize delegate=_delegate;
@synthesize selectedRow = currentRow;
@synthesize rowFont = _rowFont;
@synthesize rowIndent = _rowIndent;
@synthesize rowHeight=_rowHeight;



#pragma mark - Custom getters/setters

- (void)setSelectedRow:(int)selectedRow
{
    if (selectedRow >= rowsCount)
        return;
    
    currentRow = selectedRow;
    [_contentView setContentOffset:CGPointMake(0.0, _rowHeight * currentRow) animated:NO];
}




- (void)setRowFont:(UIFont *)rowFont
{
    _rowFont = rowFont;
    
    for (UILabel *aLabel in visibleViews) 
    {
        aLabel.font = _rowFont;
    }
    
    for (UILabel *aLabel in recycledViews) 
    {
        aLabel.font = _rowFont;
    }
}




- (void)setRowIndent:(CGFloat)rowIndent
{
    _rowIndent = rowIndent;
    
    for (UILabel *aLabel in visibleViews) 
    {
        CGRect frame = aLabel.frame;
        frame.origin.x = _rowIndent;
        frame.size.width = self.frame.size.width - _rowIndent;
        aLabel.frame = frame;
    }
    
    for (UILabel *aLabel in recycledViews) 
    {
        CGRect frame = aLabel.frame;
        frame.origin.x = _rowIndent;
        frame.size.width = self.frame.size.width - _rowIndent;
        aLabel.frame = frame;
    }
}

- (void)setShadowsImage:(UIImage *)image {
    [_shadows setImage:image];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [_contentView setBackgroundColor:backgroundColor];
}

- (void)setCornerRadius:(CGFloat)radius {
    _contentView.layer.cornerRadius = radius;
}

- (void)setSelectionIndicatorImage:(UIImage *)image {
    _selectionIndicator.image = image;
    _selectionIndicator.frame = CGRectMake(0.0, 0.0, _contentView.frame.size.width, image.size.height);
    _selectionIndicator.center = _contentView.center;
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // setup
        [self setup];
        
        // content
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.delegate = self;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_contentView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [_contentView addGestureRecognizer:tapRecognizer];
        
        // shadows
        _shadows = [[UIImageView alloc] initWithFrame:self.bounds];
        _shadows.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_shadows];
        
        // glass
        _selectionIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, 20.0)];
        _selectionIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_selectionIndicator];
    }
    return self;
}




- (void)setup
{
    _rowFont = [UIFont boldSystemFontOfSize:24.0];
    _rowIndent = 30.0;
    _rowHeight = 39.0;
    
    currentRow = 0;
    rowsCount = 0;
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
}




#pragma mark - Buisness

- (void)reloadData
{
    // empry views
    currentRow = 0;
    rowsCount = 0;
    
    for (UIView *aView in visibleViews) 
        [aView removeFromSuperview];
    
    for (UIView *aView in recycledViews)
        [aView removeFromSuperview];
    
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
    
    rowsCount = [_dataSource numberOfRowsInPickerView:self];
    [_contentView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    _contentView.contentSize = CGSizeMake(_contentView.frame.size.width, _rowHeight * rowsCount + 4 * _rowHeight);    
    [self tileViews];
}




- (void)determineCurrentRow
{
    CGFloat delta = _contentView.contentOffset.y;
    int position = round(delta / _rowHeight);
    currentRow = position;
    [_contentView setContentOffset:CGPointMake(0.0, _rowHeight * position) animated:YES];
    [_delegate pickerView:self didSelectRow:currentRow];
}




- (void)didTap:(id)sender
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    CGPoint point = [tapRecognizer locationInView:self];
    int steps = floor(point.y / _rowHeight) - 2;
    [self makeSteps:steps];
}




- (void)makeSteps:(int)steps
{
    if (steps == 0 || steps > 2 || steps < -2)
        return;
    
    [_contentView setContentOffset:CGPointMake(0.0, _rowHeight * currentRow) animated:NO];
    
    int newRow = currentRow + steps;
    if (newRow < 0 || newRow >= rowsCount)
    {
        if (steps == -2)
            [self makeSteps:-1];
        else if (steps == 2)
            [self makeSteps:1];
        
        return;
    }
    
    currentRow = currentRow + steps;
    [_contentView setContentOffset:CGPointMake(0.0, _rowHeight * currentRow) animated:YES];
    [_delegate pickerView:self didSelectRow:currentRow];
}




#pragma mark - recycle queue

- (UIView *)dequeueRecycledView
{
	UIView *aView = [recycledViews anyObject];
	
    if (aView) 
        [recycledViews removeObject:aView];
    return aView;
}



- (BOOL)isDisplayingViewForIndex:(NSUInteger)index
{
	BOOL foundPage = NO;
    for (UIView *aView in visibleViews) 
	{
        int viewIndex = aView.frame.origin.y / _rowHeight - 2;
        if (viewIndex == index) 
		{
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}




- (void)tileViews
{
    // Calculate which pages are visible
    CGRect visibleBounds = _contentView.bounds;
    int firstNeededViewIndex = floorf(CGRectGetMinY(visibleBounds) / _rowHeight) - 2;
    int lastNeededViewIndex  = floorf((CGRectGetMaxY(visibleBounds) / _rowHeight)) - 2;
    firstNeededViewIndex = MAX(firstNeededViewIndex, 0);
    lastNeededViewIndex  = MIN(lastNeededViewIndex, rowsCount - 1);
	
    // Recycle no-longer-visible pages 
	for (UIView *aView in visibleViews) 
    {
        int viewIndex = aView.frame.origin.y / _rowHeight - 2;
        if (viewIndex < firstNeededViewIndex || viewIndex > lastNeededViewIndex) 
        {
            [recycledViews addObject:aView];
            [aView removeFromSuperview];
        }
    }
    
    [visibleViews minusSet:recycledViews];
    
    // add missing pages
	for (int index = firstNeededViewIndex; index <= lastNeededViewIndex; index++) 
	{
        if (![self isDisplayingViewForIndex:index]) 
		{
            UILabel *label = (UILabel *)[self dequeueRecycledView];
            
			if (label == nil)
            {
				label = [[UILabel alloc] initWithFrame:CGRectMake(_rowIndent, 0, self.frame.size.width - _rowIndent, _rowHeight)];
                label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                label.backgroundColor = [UIColor clearColor];
                label.font = self.rowFont;
                label.textColor = RGBACOLOR(0.0, 0.0, 0.0, 0.75);
            }
            
            [self configureView:label atIndex:index];
            [_contentView addSubview:label];
            [visibleViews addObject:label];
        }
    }
}




- (void)configureView:(UIView *)view atIndex:(NSUInteger)index
{
    UILabel *label = (UILabel *)view;
    label.text = [_dataSource pickerView:self titleForRow:index];
    CGRect frame = label.frame;
    frame.origin.y = _rowHeight * index + _rowHeight*2;
    label.frame = frame;
}




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tileViews];
}




- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self determineCurrentRow];
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self determineCurrentRow];
}

@end
