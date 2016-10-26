//
//  KSNotificationView.h
//  PlanAndDo
//
//  Created by Амин on 26.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSNotificationView : UIView
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *notificationTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
