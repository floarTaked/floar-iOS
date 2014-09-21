//
//  CommentTitleCell.m
//  WeLinked3
//
//  Created by floar on 14-4-14.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "CommentTitleCell.h"    
#import "JobInfo.h"
#import "LogicManager.h"
#import "Article.h"
#import "RCLabel.h"

#define contentFontSize 14
#define viaFontSize 10

@interface CommentTitleCell ()
{
    UIView *bottonView;
}

@property (nonatomic, strong) EGOImageView *titleImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *viaLabel;

@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *companyLabel;

@property (nonatomic, strong) RCLabel *userpostTitleLabel;

@property (nonatomic, strong) NSString *imageString;
@property (nonatomic, strong) NSString *titleLabelString;
@property (nonatomic, strong) NSString *labelString;
@property (nonatomic, strong) NSString *viaLabelString;

@property (nonatomic, strong) NSString *jobLabelString;
@property (nonatomic, strong) NSString *priceLabelString;
@property (nonatomic, strong) NSString *addressLabelString;
@property (nonatomic, strong) NSString *companyLabelString;

@property (nonatomic, strong) NSString *userpostString;

@end

@implementation CommentTitleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//-(void)setArticle:(Article *)article
//{
//    _article = article;
//    self.titleImage.imageURL = [NSURL URLWithString:_article.image];
//    self.label.text = @"来自";
//    self.titleLabel.text = _article.title;
//    self.viaLabel.text = _article.via;
//    [self change];
//}

-(void)articleFromArticel:(Article *)article
{
        if (bottonView == nil)
        {
            bottonView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 280, 90)];
            bottonView.backgroundColor = colorWithHex(0xE5E5E5);
            [self.contentView addSubview:bottonView];
        }
        
        CGSize viaLabelSize = [self getCGSize:article.via withFontSize:viaFontSize withContentSize:CGSizeMake(70, CGFLOAT_MAX)];
        CGSize labelSize = [self getCGSize:@"来自" withFontSize:viaFontSize  withContentSize:CGSizeMake(70, CGFLOAT_MAX)];
        
        self.titleImage = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 130, bottonView.frame.size.height)];
        self.titleImage.imageURL = [NSURL URLWithString:article.image];
        [bottonView addSubview:self.titleImage];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, 10,130, 55)];
        self.titleLabel.text = article.title;
        self.titleLabel.font = getFontWith(YES, contentFontSize);
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        [bottonView addSubview:self.titleLabel];
        
        if (_label == nil)
        {
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMaxY(self.titleLabel.frame), labelSize.width, labelSize.height)];
            self.label.text = @"来自";
            self.label.textColor = colorWithHex(0x999999);
            self.label.font = getFontWith(NO, viaFontSize);
            [bottonView addSubview:self.label];
        }
        
        self.viaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.label.frame)+10, CGRectGetMaxY(self.titleLabel.frame), viaLabelSize.width, viaLabelSize.height)];
        self.viaLabel.text = article.via;
        self.viaLabel.font = getFontWith(NO, viaFontSize);
        self.viaLabel.textColor = colorWithHex(0x999999);
        [bottonView addSubview:self.viaLabel];
}

-(void)articleTitleViewCell
{
    if (_isFromFeedList)
    {
        Article *article = [[Article alloc] init];
        [article setValuesForKeysWithDictionary:_dateDic];
        
        if (bottonView == nil)
        {
            bottonView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 280, 90)];
            bottonView.backgroundColor = colorWithHex(0xE5E5E5);
            [self.contentView addSubview:bottonView];
        }
        
        CGSize viaLabelSize = [self getCGSize:article.via withFontSize:viaFontSize withContentSize:CGSizeMake(70, CGFLOAT_MAX)];
        CGSize labelSize = [self getCGSize:@"来自" withFontSize:viaFontSize  withContentSize:CGSizeMake(70, CGFLOAT_MAX)];
        
        self.titleImage = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 130, bottonView.frame.size.height)];
        self.titleImage.imageURL = [NSURL URLWithString:article.image];
        [bottonView addSubview:self.titleImage];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, 10,130, 55)];
        self.titleLabel.text = article.title;
        self.titleLabel.font = getFontWith(YES, contentFontSize);
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        [bottonView addSubview:self.titleLabel];
        
        if (_label == nil)
        {
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMaxY(self.titleLabel.frame), labelSize.width, labelSize.height)];
            self.label.text = @"来自";
            self.label.textColor = colorWithHex(0x999999);
            self.label.font = getFontWith(NO, viaFontSize);
            [bottonView addSubview:self.label];
        }
        
        self.viaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.label.frame)+10, CGRectGetMaxY(self.titleLabel.frame), viaLabelSize.width, viaLabelSize.height)];
        self.viaLabel.text = article.via;
        self.viaLabel.font = getFontWith(NO, viaFontSize);
        self.viaLabel.textColor = colorWithHex(0x999999);
        [bottonView addSubview:self.viaLabel];
    }
    
}

-(void)jobArticleCell
{
    JobInfo *job = [[JobInfo alloc] init];
    [job setValuesForKeysWithDictionary:_dateDic];
    self.titleImage.image = [UIImage imageNamed:job.jobImage];
    
    JobObject *jobObj = [[LogicManager sharedInstance] getPublicObject:job.jobCode type:Job];
    self.jobLabel.text = jobObj.name;
    self.priceLabel.text = [[LogicManager sharedInstance] getSalary:job.salaryLevel];

    
    
    if (bottonView == nil)
    {
        bottonView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 280, 90)];
        bottonView.backgroundColor = colorWithHex(0xE5E5E5);
        [self.contentView addSubview:bottonView];
    }
    
    self.titleImage = [[EGOImageView alloc] init];
    self.titleImage.frame = CGRectMake(10, 10, 70, 70);
    self.titleImage.image = [UIImage imageNamed:job.jobImage];
    [bottonView addSubview:self.titleImage];
    
    self.jobLabel = [[UILabel alloc] init];
    self.jobLabel.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, 10, 250,30);
    self.jobLabel.font = getFontWith(YES, contentFontSize);
//    self.jobLabel.backgroundColor = [UIColor orangeColor];
    self.jobLabel.textColor = [UIColor blackColor];
    [bottonView addSubview:self.jobLabel];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMaxY(self.jobLabel.frame), 280, 20);
    self.priceLabel.font = getFontWith(NO, viaFontSize);
    self.priceLabel.textColor = colorWithHex(0x999999);
    [bottonView addSubview:self.priceLabel];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMaxY(self.priceLabel.frame), 60, 25);
    CityObject *city = [[LogicManager sharedInstance] getPublicObject:job.locationCode type:City];
    self.addressLabel.text = [NSString stringWithFormat:@"%@",city.fullName];
    self.addressLabel.font = getFontWith(NO, viaFontSize);
    self.addressLabel.textColor = colorWithHex(0x999999);
    [bottonView addSubview:self.addressLabel];
    
    self.companyLabel = [[UILabel alloc] init];
    self.companyLabel.frame = CGRectMake(CGRectGetMaxX(self.addressLabel.frame), CGRectGetMaxY(self.priceLabel.frame), 70, 25);
    self.companyLabel.text = [_dateDic objectForKey:@"company"];
    self.companyLabel.backgroundColor = [UIColor redColor];
    self.companyLabel.font = getFontWith(NO, viaFontSize);
    self.companyLabel.textColor = colorWithHex(0x999999);
    [bottonView addSubview:self.addressLabel];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(bottonView.width - 20, bottonView.height/ 2 - 5, 11, 11)];
    arrow.image = [UIImage imageNamed:@"img_arrow.png"];
    [bottonView addSubview:arrow];

}


-(void)userPostCell
{
    
    CGSize size = [self getCGSize:[_dateDic objectForKey:@"content"] withFontSize:contentFontSize withContentSize:CGSizeMake(280, CGFLOAT_MAX)];
    self.userpostTitleLabel = [[RCLabel alloc] initWithFrame: CGRectMake(10, 0, size.width+40, size.height+5)];

    
    [self.userpostTitleLabel setText:[NSString stringWithFormat:@"<p><font size = 15 color='#333333'face = Hiragino Kaku Gothic ProN W3 >“</font></p><p><font size = 14 color='#333333'face = Hiragino Kaku Gothic ProN W3 >%@</font></p><p><font size = 15 color='#333333'face = Hiragino Kaku Gothic ProN W3 >”</font></p>",[_dateDic objectForKey:@"content"]]];
    
//    self.userpostTitleLabel.numberOfLines = 0;
    self.userpostTitleLabel.font = getFontWith(YES, contentFontSize);
//        self.userpostTitleLabel.font = [UIFont fontWithName:@"Zapfino" size:15];
    [self.contentView addSubview:self.userpostTitleLabel];
    
    self.titleImage = [[EGOImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.userpostTitleLabel.frame), 200, 100)];
    self.titleImage.imageURL = [NSURL URLWithString:[_dateDic objectForKey:@"image"]];
    [self.contentView addSubview:self.titleImage];
}

-(CGSize)getCGSize:(NSString *)string
          withFontSize:(CGFloat)fontSize
   withContentSize:(CGSize)contentSize
{
    CGSize size;
    if (isSystemVersionIOS7())
    {
        size = [string boundingRectWithSize:CGSizeMake(contentSize.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:getFontWith(NO, fontSize),NSFontAttributeName, nil] context:nil].size;
    }else
    {
        size = [string sizeWithFont:getFontWith(NO, fontSize) constrainedToSize:CGSizeMake(contentSize.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return size;
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
