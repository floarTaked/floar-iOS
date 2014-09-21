//
//  ASScrollView.m
//  KitMoreTest
//
//  Created by floar on 14-6-29.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "ASScrollView.h"

@interface ASScrollView ()<UIScrollViewDelegate>
{
    float previousTouchPoint;
    UIScrollView *OwnScrollView;
    UIPageControl *pageControl;
    int scrollWidth;
    int scrollHeight;
    BOOL didEndAnimate;
}
@end

@implementation ASScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        OwnScrollView = [[UIScrollView alloc] initWithFrame:frame];
        OwnScrollView.delegate = self;
        scrollWidth = frame.size.width;
        scrollHeight = frame.size.height;
        OwnScrollView.showsVerticalScrollIndicator = NO;
        OwnScrollView.showsHorizontalScrollIndicator = NO;
        OwnScrollView.pagingEnabled = NO;
        OwnScrollView.bounces = NO;
        [self addSubview:OwnScrollView];
    }
    return self;
}

-(void)setArrOfImages:(NSMutableArray *)arrOfImages
{
    if (arrOfImages.count > 0 && arrOfImages != nil)
    {
        OwnScrollView.contentSize = CGSizeMake(scrollWidth*arrOfImages.count, scrollHeight);
        
        for (int i = 0; i<arrOfImages.count; i++)
        {
            UIView *imgView = (UIView *)[self viewWithTag:10+i];
            if (imgView == nil)
            {
                imgView = [[UIView alloc] initWithFrame:CGRectMake(scrollWidth*i, 0, scrollWidth, scrollHeight)];
                imgView.tag = 10+i;
                imgView.backgroundColor = [arrOfImages objectAtIndex:i];
                [OwnScrollView addSubview:imgView];
            }
        }
    }
}

-(void) cancelScrollAnimation
{
    didEndAnimate =YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    previousTouchPoint = scrollView.contentOffset.x;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    didEndAnimate = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = floor((scrollView.contentOffset.x - 320) / 320) + 1;
    float OldMin = 320*page;
    int Value = scrollView.contentOffset.x -OldMin;
    float alpha = (Value% 320) / 320.f;
    
    
    if (previousTouchPoint > scrollView.contentOffset.x)
        page = page+2;
    else
        page = page+1;
    
    UIView *nextPage = [scrollView.superview viewWithTag:page+1];
    UIView *previousPage = [scrollView.superview viewWithTag:page-1];
    UIView *currentPage = [scrollView.superview viewWithTag:page];
    
    if(previousTouchPoint <= scrollView.contentOffset.x){
        if ([currentPage isKindOfClass:[UIImageView class]])
            currentPage.alpha = 1-alpha;
        if ([nextPage isKindOfClass:[UIImageView class]])
            nextPage.alpha = alpha;
        if ([previousPage isKindOfClass:[UIImageView class]])
            previousPage.alpha = 0;
    }else if(page != 0){
        if ([currentPage isKindOfClass:[UIImageView class]])
            currentPage.alpha = alpha;
        if ([nextPage isKindOfClass:[UIImageView class]])
            nextPage.alpha = 0;
        if ([previousPage isKindOfClass:[UIImageView class]])
            previousPage.alpha = 1-alpha;
    }
    if (!didEndAnimate )
    {
        for (UIView * imageView in self.subviews){
            if (imageView.tag !=1 && [imageView isKindOfClass:[UIImageView class]])
                imageView.alpha = 0;
            else if([imageView isKindOfClass:[UIImageView class]])
                imageView.alpha = 1 ;
        }
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
