//
// AKSegmentedControl.m
//
// Copyright (c) 2013 Ali Karagoz (http://alikaragoz.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AKSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

#define kAKButtonSeparatorWidth 1.0

@interface AKSegmentedControl ()

/**
 Buttons target method
 */
- (void)segmentButtonPressed:(id)sender;

@end

@implementation AKSegmentedControl
{
    /**
     Array containing all the separators, for easy access
     */
    NSMutableArray *separatorsArray;
    
    /**
     Background Image view of the segmented control
     */
    UIImageView *backgroundImageView;
}

#pragma mark -
#pragma mark Init and Dealloc

- (void)dealloc
{
    [_buttonsArray release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setContentEdgeInsets:UIEdgeInsetsZero];
    [self setSelectedIndex:0];
    [self setSegmentedControlMode:AKSegmentedControlModeSticky];
    [self setButtonsArray:[NSMutableArray array]];
    separatorsArray = [NSMutableArray array];
    
    backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    backgroundImageView.hidden = YES;
    [self addSubview:backgroundImageView];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews
{
    // creating the content rect that will "contain" the button
    CGRect contentRect = UIEdgeInsetsInsetRect(self.bounds, _contentEdgeInsets);
    
    // for more clarity we create simple variables
    NSUInteger buttonsCount = [_buttonsArray count];
    NSUInteger separtorsNumber = buttonsCount - 1;
    
    // calculating the button prperties
    CGFloat separatorWidth = (_separatorImage != nil) ? _separatorImage.size.width : kAKButtonSeparatorWidth;
    CGFloat buttonWidth = floorf((CGRectGetWidth(contentRect) - (separtorsNumber * separatorWidth)) / buttonsCount);
    CGFloat buttonHeight = CGRectGetHeight(contentRect);
    CGSize buttonSize = CGSizeMake(buttonWidth, buttonHeight);
    
    CGFloat dButtonWidth = 0;
    CGFloat spaceLeft = CGRectGetWidth(contentRect) - (buttonsCount * buttonSize.width) - (separtorsNumber * separatorWidth);
    
    CGFloat offsetX = CGRectGetMinX(contentRect);
//    CGFloat offsetY = CGRectGetMinY(contentRect);
    
    NSUInteger increment = 0;
    
    // laying-out the buttons
    for (UIButton *button in _buttonsArray)
    {
        // trick to incread the size of the button a little bit because of the separators
        dButtonWidth = buttonSize.width;
        
        if (spaceLeft != 0)
        {
            dButtonWidth++;
            spaceLeft--;
        }
        
        if (increment != 0) offsetX += separatorWidth;
    
        //
//        [button setFrame:CGRectMake(offsetX, offsetY, dButtonWidth, buttonSize.height)];
        
        // replacing each separators
        if (increment < separtorsNumber)
        {
//            UIImageView *separatorImageView = separatorsArray[increment];
//            [separatorImageView setFrame:CGRectMake(CGRectGetMaxX(button.frame),
//                                                    offsetY,
//                                                    separatorWidth,
//                                                    CGRectGetHeight(self.bounds) - _contentEdgeInsets.top - _contentEdgeInsets.bottom)];
        }
        
        increment++;
        offsetX = CGRectGetMaxX(button.frame);
    }
    
    [self.layer setCornerRadius:5];
    self.clipsToBounds = YES;
}

#pragma mark -
#pragma mark Button Actions

- (void)segmentButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (!button || ![button isKindOfClass:[UIButton class]])
        return;
    
    NSUInteger selectedIndex = button.tag;
    
    [self setSelectedIndex:selectedIndex];
}

#pragma mark -
#pragma mark Setters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [backgroundImageView setImage:_backgroundImage];
}

- (void)setButtonsArray:(NSArray *)buttonsArray
{
    [_buttonsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIButton *)obj removeFromSuperview];
    }];
    
    [separatorsArray removeAllObjects];
    
    // filling the arrays
    if (_buttonsArray != buttonsArray) {
        [_buttonsArray release];
        _buttonsArray = [buttonsArray retain];
    }
    
    [_buttonsArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         [self addSubview:(UIButton *)obj];
        [(UIButton *)obj addTarget:self action:@selector(segmentButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [(UIButton *)obj setTag:idx];
        
        if (idx ==_selectedIndex)
            [(UIButton *)obj setSelected:YES];
    }];
    
    [self setSeparatorImage:_separatorImage];
    [self setSegmentedControlMode:_segmentedControlMode];
}

- (void)setSeparatorImage:(UIImage *)separatorImage
{
    [separatorsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIImageView *)obj removeFromSuperview];
    }];
    
    _separatorImage = separatorImage;
    
    NSUInteger separatorsNumber = [_buttonsArray count] - 1;
    
    [_buttonsArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         if (idx < separatorsNumber)
         {
             UIImageView *separatorImageView = [[UIImageView alloc] initWithImage:_separatorImage];
             [self addSubview:separatorImageView];
             [separatorsArray addObject:separatorImageView];
             [separatorImageView release];
         }
     }];
}

- (void)setSegmentedControlMode:(AKSegmentedControlMode)segmentedControlMode
{
    _segmentedControlMode = segmentedControlMode;
    
    if ([_buttonsArray count] == 0) return;
    
    if (_segmentedControlMode == AKSegmentedControlModeButton)
    {
        UIButton *currentSelectedButton = (UIButton *)_buttonsArray[_selectedIndex];
        [currentSelectedButton setSelected:NO];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex != _selectedIndex || _segmentedControlMode == AKSegmentedControlModeButton)
    {        
        if (_segmentedControlMode == AKSegmentedControlModeSticky)
        {
            if ([_buttonsArray count] == 0) return;
            
            UIButton *currentSelectedButton = (UIButton *)_buttonsArray[_selectedIndex];
            UIButton *selectedButton = (UIButton *)_buttonsArray[selectedIndex];
            
            [currentSelectedButton setSelected:!currentSelectedButton.selected];
            [selectedButton setSelected:!selectedButton.selected];
        }
        
        _selectedIndex = selectedIndex;
        
        if ([_delegate respondsToSelector:@selector(segmentedViewController:touchedAtIndex:)])
            [_delegate segmentedViewController:self touchedAtIndex:selectedIndex];
    }
}

-(void)setItems:(NSArray *)items
{
    if (_items != items) {
        [_items release];
        _items =[items retain];
    }
    UIImage *backgroundImage = [[UIImage imageNamed:@"segmented-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 20.0, 10.0, 10.0)];
    [self setBackgroundImage:backgroundImage];
//    [self setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [self setSegmentedControlMode:AKSegmentedControlModeSticky];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
//    [self setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:items.count];
    
    float buttonWidth = CGRectGetWidth(self.frame) / items.count;
    for (int i = 0 ; i < items.count; i ++) {
        UIImage *buttonBackgroundImagePressedCenter = [[UIImage imageNamed:@"segmented-bg-pressed-center.png"]
                                                       resizableImageWithCapInsets:UIEdgeInsetsMake(0, 50, 20, 20.0)];
        UIButton *buttonSocial = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonSocial.frame = CGRectMake(i * buttonWidth , 0, buttonWidth, CGRectGetHeight(self.frame));
        [buttonSocial setTitle:[items objectAtIndex:i] forState:UIControlStateNormal];
//        [buttonSocial setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [buttonSocial setTitleColor:colorWithHex(0xdce7ff) forState:UIControlStateNormal];
        [buttonSocial setTitleColor:colorWithHex(0xffffff) forState:UIControlStateSelected];
//        [buttonSocial setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [buttonSocial.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
//        [buttonSocial.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
        buttonSocial.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [buttonSocial setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
//        buttonSocial.backgroundColor = [UIColor colorWithPatternImage:buttonBackgroundImagePressedCenter];
        
        UIImage *buttonSocialImageNormal = [UIImage imageNamed:@"social-icon.png"];
        [buttonSocial setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
        [buttonSocial setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
        [buttonSocial setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
        [buttonSocial setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateNormal];
        [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateSelected];
        [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateHighlighted];
        [buttonSocial setImage:buttonSocialImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
        [itemArray addObject:buttonSocial];
    }
    
    
    [self setButtonsArray:itemArray];
}

@end