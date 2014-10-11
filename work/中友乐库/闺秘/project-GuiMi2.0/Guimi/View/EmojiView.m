//
//  EmojiView.m
//  Guimi
//
//  Created by jonas on 9/15/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "EmojiView.h"

@implementation EmojiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initlize];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initlize];
}
-(void)initlize
{
    [collection registerNib:[UINib nibWithNibName:@"EmojiCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"];
    dataSource = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    viewSource = [NSMutableDictionary dictionary];
    key = Emoji_People_key;
    NSArray* array = [dataSource objectForKey:key];
    self.userInteractionEnabled = YES;
    [collection reloadData];
    pageControl.numberOfPages = ([array count]-21)/21;
    [self updatePage];
}
-(void)setEventBlock:(EventCallBack)callBack
{
    block = callBack;
}
-(void)updatePage
{
    float a = (collection.contentOffset.x-320.0) / 320.0 + 1.0;
    pageControl.currentPage = ceil(a);
}
-(void)loadView
{
    if(key == nil)
    {
        return;
    }
    NSArray* array = [dataSource objectForKey:key];
    if(array == nil)
    {
        return;
    }
    [collection reloadData];
    pageControl.numberOfPages = ([array count]-21)/21+1;
    [self updatePage];
}
-(void)resetButtons
{
    for(int i = 1;i<8;i++)
    {
        UIButton* btn = (UIButton*)[self viewWithTag:i];
        if(btn != nil)
        {
            btn.selected = NO;
        }
    }
}
-(void)selectedButton:(int)tag
{
    if(tag == 1)
    {
        if(block)
        {
            block(2,nil);
        }
    }
    else if (tag == 2)
    {
        key = Emoji_People_key;
        [self loadView];
    }
    else if (tag == 3)
    {
        key = Emoji_Objects_key;
        [self loadView];
    }
    else if (tag == 4)
    {
        key = Emoji_Nature_key;
        [self loadView];
    }
    else if (tag == 5)
    {
        key = Emoji_Places_key;
        [self loadView];
    }
    else if (tag == 6)
    {
        key = Emoji_Symbols_key;
        [self loadView];
    }
    else if (tag == 7)
    {
        if(block)
        {
            block(1,nil);
        }
    }
}
-(IBAction)click:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int tag = [(UIButton*)sender tag];

    [self resetButtons];
    if(tag > 1 && tag < 7)
    {
        btn.selected = YES;
    }
    [self selectedButton:tag];
}
#pragma --mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray* arr = [dataSource objectForKey:key];
    if(arr != nil)
    {
        if(section == ([arr count]-21)/21)
        {
            return [arr count] % 21;
        }
        else
        {
            return 21;
        }
    }
    return 0;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSArray* arr = [dataSource objectForKey:key];
    if(arr != nil)
    {
        return ([arr count]-21)/21 +1;
    }
    return 0;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[UICollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width,
                                                                    collectionView.frame.size.height)];
    }
    UILabel* lbl = (UILabel*)[cell.contentView viewWithTag:100];
    NSArray* arr = [dataSource objectForKey:key];
    NSString* s = [arr objectAtIndex:indexPath.section*21 + indexPath.row];
    [lbl setText:s];
    lbl.font = [UIFont fontWithName:@"AppleColorEmoji" size:30.0];
    return cell;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePage];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* arr = [dataSource objectForKey:key];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString* value = arr[indexPath.section*21 + indexPath.row];
    if(block)
    {
        block(0,value);
    }
}


@end
