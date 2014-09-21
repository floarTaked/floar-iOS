//
//  InforCollectionCell.m
//  WeLinked3
//
//  Created by Floar on 14-3-4.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "InforCollectionCell.h"
#import "MPFlipTransition.h"
#import <EGOImageLoader.h>

//写死的cell的宽度和高度
#define flipWidth 140
#define flipHeight 135

@implementation InforCollectionCell
{
    
    __weak IBOutlet EGOImageView *inforCellImageView;
    
    __weak IBOutlet UILabel *inforCellLabel;
    
    EGOImageView *firstImage;
    
    UIView *view;
    
}

-(void)transOrNot:(BOOL)isAnimation
        withImage:(UIImageView *)image
{
    if (isAnimation)
    {
//        if (view.superview) {
//            [view removeFromSuperview];
//        }
        [MPFlipTransition transitionFromView:self.contentView
                                      toView:image
                                    duration:1.0
                                       style:MPFlipStyleOrientationVertical
                            transitionAction:MPTransitionActionAddRemove
                                  completion:^(BOOL finished) {
                                      NSLog(@"finish...");
                                      [inforCellLabel bringSubviewToFront:view];
                                      
                                  }];
    }
    else
    {
        [view removeFromSuperview];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib
{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, flipWidth, flipHeight)];
    view.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:view];
    
    firstImage =[[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, flipWidth+5, flipHeight)];
    
    [view addSubview:firstImage];
    [view addSubview:inforCellLabel];
    
}

-(void)animationCell:(Column *)column
{
    firstImage.imageURL = [NSURL URLWithString:column.img];
    
    [[EGOImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:column.firstImg] observer:self];
    
    inforCellLabel.text = column.title;
    inforCellLabel.font = getFontWith(NO, 17);
}

//-(void)setColumn:(Column *)column
//{
//    _column = column;
//    inforCellImageView.backgroundColor = self.cellColor;
//    inforCellImageView.imageURL = [NSURL URLWithString:column.img];
////    [[EGOImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:_column.img] observer:self];
//    inforCellLabel.text = column.title;
//    inforCellLabel.font = getFontWith(NO, 17);
//    
//    [self setNeedsLayout];
//}

//UI显示最后一个cell用
-(void)lastCell
{
    inforCellImageView.image = [UIImage imageNamed:@"img_add_subscription"];
//    inforCellLabel.frame = CGRectMake(8, -10, 114, 57);
    inforCellLabel.text = @"点击添加订阅";
}

-(void)layoutSubviews
{
    //重设尺寸
//    inforCellLabel.frame = CGRectMake(inforCellLabel.frame.origin.x, inforCellLabel.frame.origin.y, inforCellLabel.frame.size.width, cellSize.height);
    [super layoutSubviews];
}

-(void)imageLoaderDidLoad:(NSNotification *)notification
{
    EGOImageView *image = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, flipWidth+5, flipHeight)];
    image.image = [[notification userInfo] objectForKey:@"image"];
    
    [self transOrNot:YES withImage:image];
    
}

-(void)imageLoaderDidFailToLoad:(NSNotification *)notification
{
    NSLog(@"%@",notification);
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
