//
//  JobTableCell.m
//  WeLinked3
//
//  Created by 牟 文斌 on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "JobTableCell.h"
#import <EGOImageView.h>
#import "LogicManager.h"
@interface JobTableCell ()
@property (weak, nonatomic) IBOutlet EGOImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *salary;
@property (weak, nonatomic) IBOutlet UILabel *workPlace;
@property (weak, nonatomic) IBOutlet UILabel *recommender;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation JobTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setJobInfo:(JobInfo *)jobInfo
{
    _jobInfo = jobInfo;
    if (jobInfo.isFriendJob) {
        self.icon.imageURL = [NSURL URLWithString:_jobInfo.posterImg];
    }else{
        self.icon.image = [UIImage imageNamed:jobInfo.jobImage];
    }
    
    JobObject *job = [[LogicManager sharedInstance]getPublicObject:_jobInfo.jobCode type:Job];
    self.jobTitle.text = job.name;
    self.salary.text = [[LogicManager sharedInstance] getSalary:_jobInfo.salaryLevel];
    CityObject *city = [[LogicManager sharedInstance] getPublicObject:_jobInfo.locationCode type:City];
    self.workPlace.text = city.name;
    self.recommender.text = [NSString stringWithFormat:@"%@发布了这个职位",_jobInfo.poster];
    
    self.bgView.layer.borderColor = colorWithHex(0xcccccc).CGColor;
    self.bgView.layer.borderWidth = 0.5;
}

@end
