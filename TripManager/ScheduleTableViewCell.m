//
//  ScheduleTableViewCell.m
//  TripManager
//
//  Created by 何家瑋 on 2017/3/23.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "ScheduleTableViewCell.h"

@interface ScheduleTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;

@property (weak, nonatomic) IBOutlet UITextView *customRemarkTextView;

@end

@implementation ScheduleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
        [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(DataItem *)item
{
        // icon image view category
        switch (item.DataItemType.integerValue)
        {
                case dataItemTypeScenicspot:
                        _categoryImageView.image = [UIImage imageNamed:@"category_location"];
                        break;
                case dataItemTypeRestaurant:
                        _categoryImageView.image = [UIImage imageNamed:@"category_restaurant"];
                        break;
                case dataItemTypeHotel:
                        _categoryImageView.image = [UIImage imageNamed:@"category_house"];
                        break;
                default:
                        break;
        }
        
        // name label
        _nameLabel.text = item.Name;
        
        // time label
        NSString * visitTime = (item.VisitTime) ? item.VisitTime : @"00:00";
        _visitTimeLabel.text = [NSString stringWithFormat:@"預定到達時間：%@", visitTime];
        _visitTimeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [_visitTimeLabel sizeToFit];
        
        // remark text view
        if (item.CustomRemarks)
        {
                _customRemarkTextView.text = item.CustomRemarks;
        }
        else
        {
                _customRemarkTextView.text = @"備註：";
        }
        _customRemarkTextView.editable = NO;
        _customRemarkTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

@end
