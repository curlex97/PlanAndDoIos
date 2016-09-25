//
//  ProfileViewController.h
//  PlanAndDo
//
//  Created by Student on 9/23/16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTableViewController.h"
typedef NS_ENUM(NSUInteger, KSProfileState)
{
    KSProfileStateNameChange,
    KSProfileStateDeleteAll
};
@interface ProfileViewController : BaseTableViewController

@end
