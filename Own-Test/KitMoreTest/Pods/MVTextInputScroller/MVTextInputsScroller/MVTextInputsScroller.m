//
// Created by Andrea Bizzotto on 25/03/2014.
// Copyright (c) 2014 musevisions. All rights reserved.
//

#import "MVTextInputsScroller.h"

///////////////////////////////////////////////////////
@interface UIView (ViewHierarchyInputs)
- (NSArray *)textInputsInHierarchy;
@end

@implementation UIView (ViewHierarchyInputs)
- (NSArray *)textInputsInHierarchy
{
    NSMutableArray *textInputs = [NSMutableArray new];
    for (UIView *subview in self.subviews)
    {
        NSArray *subviewInputs = [subview textInputsInHierarchy];
        if (subviewInputs != nil) {
            [textInputs addObjectsFromArray:subviewInputs];
        }
    }
    if ([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]]) {
        [textInputs addObject:self];
    }
    return textInputs;
}
@end
///////////////////////////////////////////////////////

static NSString *kContentSizeKeyToObserve = @"scrollView.contentSize";

@interface MVTextInputsScroller ()
@property(weak, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) NSArray *textInputs;
@property CGSize keyboardSize;
@property BOOL keyboardVisible;
@property CGSize storedContentSize;
@property(weak, nonatomic) UIView *activeView;
@property(weak, nonatomic) UIView *activeViewBeforeOrientationChange;
@end

@implementation MVTextInputsScroller

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unregister];
}

- (void)unregister {

    // Run this in try/catch block just in case method is called when observer is not registered
    @try {
        [self removeObserver:self forKeyPath:kContentSizeKeyToObserve context:nil];
    }
    @catch (NSException * __unused exception) {
        
    }
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    if (self = [super init]) {

        self.scrollView = scrollView;
        self.textInputs = [scrollView textInputsInHierarchy];
        self.storedContentSize = self.scrollView.contentSize;
        [self setupObservers];
        //[self printLayout];
    }
    return self;
}

- (void)setupObservers {

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // Listen to 'did begin editing' notifications
    [nc addObserver:self selector:@selector(textInputDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [nc addObserver:self selector:@selector(textInputDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [nc addObserver:self selector:@selector(textInputDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    [nc addObserver:self selector:@selector(textInputDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];

    // Listen to keyboard events
    //[nc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];

    // Listen to orientation changes
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];

    // Useful if the scroll view content size changes
    [self addObserver:self forKeyPath:kContentSizeKeyToObserve options:0 context:nil];
}

#pragma mark - keyboard notifications
- (void)keyboardWillShow:(NSNotification *)notification
{
    //DLog();
    self.keyboardVisible = YES;
    if (self.activeView == nil) {
        // Restore if this is just an orientation change
        self.activeView = self.activeViewBeforeOrientationChange;
    }
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    //DLog();
    self.keyboardVisible = NO;
    self.activeViewBeforeOrientationChange = self.activeView;
    //self.scrollView.contentInset = UIEdgeInsetsZero;
    self.activeView = nil;
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {

    NSDictionary *info = [notification userInfo];
    self.keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (UIInterfaceOrientationIsLandscape([[self class] currentOrientation])) {
        self.keyboardSize = CGSizeMake(self.keyboardSize.height, self.keyboardSize.width);
    }
    //DLog(@"New keyboard size: %@", NSStringFromCGSize(self.keyboardSize));

    // If there is an active view and the keyboard is visible
    if (self.activeView != nil && self.keyboardVisible) {

        [self makeViewVisible:self.activeView animated:YES];
    }
}


- (void)orientationChanged:(NSNotification *)notification {

    if (self.activeView != nil) {
        [self makeViewVisible:self.activeView animated:YES];
    }
}

#pragma mark - text input notifications

- (void)textInputDidBeginEditing:(NSNotification *)notice {
    [self processInputDidBeginEditing:notice.object];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)textInputDidEndEditing:(NSNotification *)notice {
    [self performSelector:@selector(resetContentOffset) withObject:nil afterDelay:0.2f];
}

- (void)processInputDidBeginEditing:(id)object {

    //DLog(@"%@", object);
    if ([object isKindOfClass:[UIView class]]) {
        UIView *view = (UIView *)object;
        if ([self scrollViewHasSubview:view]) {
            self.activeView = view;
            [self makeViewVisible:view animated:YES];
        }
    }
}
#pragma mark - Scroll View content size changes
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kContentSizeKeyToObserve]) {
        // Update
        CGSize contentSize = self.scrollView.contentSize;
        if (!CGSizeEqualToSize(contentSize, self.storedContentSize)) {
            //DLog(@"prev content size: %@, current content size: %@", NSStringFromCGSize(self.storedContentSize), NSStringFromCGSize(contentSize));
            self.storedContentSize = contentSize;
            if (self.activeView != nil) {
                [self makeViewVisible:self.activeView animated:NO];
            }
        }
    }
}

- (CGSize)calculateKeyboardSizeWithView:(UIView *)view {

    // Get keyboard size (if zero, it hasn't been set yet so try to guess)
    CGSize keyboardSize = self.keyboardSize;
    if (CGSizeEqualToSize(keyboardSize, CGSizeZero)) {
        keyboardSize = [[self class] currentEstimatedKeyboardSize];
        // Account for accessory views in calculating keyboard size
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (textField.inputAccessoryView) {
                CGFloat accessoryViewHeight = textField.inputAccessoryView.frame.size.height;
                //DLog(@"AccessoryView height: %f", accessoryViewHeight);
                CGSize estimatedSize = [[self class] currentEstimatedKeyboardSize];
                if (estimatedSize.height == keyboardSize.height)
                    keyboardSize.height += accessoryViewHeight;
            }
        }
    }
    return keyboardSize;
}

- (void)makeViewVisible:(UIView *)view animated:(BOOL)animated {

    // Calculate keyboard size
    CGSize keyboardSize = [self calculateKeyboardSizeWithView:view];

    // Calculate visible scrollable height (which is the portion of the screen that can scroll and is not hidden by the keyboard)
    float visibleScrollableHeight = [self visibleScrollableHeightWithKeyboardSize:keyboardSize];

    // Calculate the offset of the view centerY relative to the scrollView
    CGPoint viewOriginInScrollView = [self viewOriginInScrollView:view];
    float viewCenterY = viewOriginInScrollView.y + view.frame.size.height/2;

    // Calculate new content offset that will cause the view to be centered in the visible scrollable area
    float newContentOffsetY = viewCenterY - visibleScrollableHeight/2;

    // Update content offset, subject to top/bottom constraints
    [self updateWithNewContentOffsetY:newContentOffsetY visibleScrollableHeight:visibleScrollableHeight animated:animated];
}

- (void)resetContentOffset {

    // Calculate visible scrollable height (which is the portion of the screen that can scroll and is not hidden by the keyboard)
    float visibleScrollableHeight = [self visibleScrollableHeightWithKeyboardSize:CGSizeZero];

    // Use current offset as reference
    float newContentOffsetY  = self.scrollView.contentOffset.y;

    // Update content offset, subject to top/bottom constraints
    [self updateWithNewContentOffsetY:newContentOffsetY visibleScrollableHeight:visibleScrollableHeight animated:YES];
}

- (void)updateWithNewContentOffsetY:(float)newContentOffsetY visibleScrollableHeight:(float)visibleScrollableHeight animated:(BOOL)animated {

    // Calculate new content offset that will cause the view to be centered in the visible scrollable area
    float contentHeight = self.scrollView.contentSize.height;
    // If content offset would cause the scroll view to scroll below its bottom, recalculate
    // to the maximum content offset. This way we don't show additional empty space below the last visible control.
    if (newContentOffsetY + visibleScrollableHeight > contentHeight) {
        newContentOffsetY = contentHeight - visibleScrollableHeight;
    }
    // Ensure content offset is not negative
    if (newContentOffsetY < 0) {
        newContentOffsetY = 0;
    }
    CGPoint newContentOffset = CGPointMake(0, newContentOffsetY);
    [self.scrollView setContentOffset:newContentOffset animated:animated];
}

- (float)visibleScrollableHeightWithKeyboardSize:(CGSize)keyboardSize {

    CGSize currentScreenSize = [[self class] currentScreenSize];
    // Calculate scroll view origin without offset
    CGPoint scrollViewOriginInMainWindowNoOffset = [[self class] viewOriginInMainWindow:self.scrollView];
    scrollViewOriginInMainWindowNoOffset.y += self.scrollView.contentOffset.y;

    return currentScreenSize.height - keyboardSize.height - scrollViewOriginInMainWindowNoOffset.y;
}

#pragma mark - utility methods

- (BOOL)scrollViewHasSubview:(UIView *)view {
    return [self.textInputs containsObject:view];
}

+ (CGSize)currentEstimatedKeyboardSize {

    BOOL portrait = UIInterfaceOrientationIsPortrait([self currentOrientation]);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return portrait ? CGSizeMake(768, 264) : CGSizeMake(1024, 352);
    }
    else {
        return portrait ? CGSizeMake(320, 216) : CGSizeMake(480, 162);
    }
}

+ (UIInterfaceOrientation)currentOrientation {
    return [UIApplication sharedApplication].statusBarOrientation;
}
+ (CGSize)currentScreenSize
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(screenBounds);
    CGFloat height = CGRectGetHeight(screenBounds);
    UIInterfaceOrientation interfaceOrientation = [self currentOrientation];
    return UIInterfaceOrientationIsPortrait(interfaceOrientation) ? CGSizeMake(width, height) : CGSizeMake(height, width);
}

- (CGPoint)viewOriginInScrollView:(UIView *)view {

    return [self.scrollView convertPoint:CGPointZero fromView:view];
}

+ (CGPoint)viewOriginInMainWindow:(UIView *)view {

    UIWindow *mainView = [[UIApplication sharedApplication].delegate window].subviews[0];
    return [mainView convertPoint:CGPointZero fromView:view];
}

//- (void)printLayout {
//
//    for (UIView *view in self.textInputs) {
//        DLog(@"class: %@, frame: %@", NSStringFromClass([view class]), NSStringFromCGRect(view.frame));
//    }
//}

@end
