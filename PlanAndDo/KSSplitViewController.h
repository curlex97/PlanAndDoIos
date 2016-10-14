//
//  KSSplitViewController.h
//  PlanAndDo
//
//  Created by Амин on 14.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseKSMenuViewController.h"

@interface KSSplitViewController : UISplitViewController <UISplitViewControllerDelegate>

-(instancetype)initWithMenuVC:(BaseKSMenuViewController *) menuVC
                 andDetailsVC:(UINavigationController *)detailsVC;
@end
