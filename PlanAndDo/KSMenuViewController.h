//
//  KSMenuViewController.h
//  PlanAndDo
//
//  Created by Амин on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, KSMenuState)
{
    KSMenuStateNormal,
    KSMenuStateSearch,
    KSMenuStateEdit
};

@interface KSMenuViewController : BaseTableViewController
@property (nonatomic)KSMenuState state;

@end
