//
//  EditCategoryTableViewCell.m
//  PlanAndDo
//
//  Created by Амин on 16.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "EditCategoryTableViewCell.h"

@implementation EditCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)willTransitionToState:(UITableViewCellStateMask)state
{
    NSLog(@"Tapped");
}

@end
