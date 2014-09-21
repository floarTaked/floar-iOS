//
//  InforCollectionCell.m
//  WeLinked3
//
//  Created by Floar on 14-3-4.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "InforCollectionCell.h"
#import "MPFlipTransition.h"

//写死的cell的宽度和高度
#define flipWidth 140
#define flipHeight 135

@implementation InforCollectionCell
{
    
    __weak IBOutlet EGOImageView *inforCellImageView;
    
    __weak IBOutlet UILabel *inforCellLabel;
    
    UIView *view;
    
}

-(UIImageView *)createImageView:(NSString *)imageString
{
    EGOImageView *image =[[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, flipWidth+5, flipHeight)];
    image.imageURL = [NSURL URLWithString:imageString];
//        image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.column.title]]];
//        image.backgroundColor = [UIColor greenColor];
//    }
//    image.image = [UIImage imageNamed:imageString];
    
    return image;
}

-(void)transOrNot:(BOOL)isAnimation
{
    if (isAnimation)
    {
        if (view.superview) {
            [view removeFromSuperview];
        }
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, flipWidth, flipHeight)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        
        [view addSubview:[self createImageView:@"55.jpg"]];
        
        [MPFlipTransition transitionFromView:[view.subviews objectAtIndex:0]
                                      toView:[self createImageView:@"132.jpg"]
                                    duration:1.0
                                       style:MPFlipStyleOrientationVertical
                            transitionAction:MPTransitionActionAddRemove
                                  completion:^(BOOL finished) {
                                      NSLog(@"finish...");
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


-(void)setColumn:(Column *)column
{
    _column = column;
    inforCellImageView.backgroundColor = self.cellColor;
    inforCellImageView.imageURL = [NSURL URLWithString:column.img];
    inforCellLabel.text = column.title;
    inforCellLabel.font = getFontWith(NO, 17);
    
    [self setNeedsLayout];
}

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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
