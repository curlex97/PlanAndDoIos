//
//  DescriptionViewController.h
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseViewController.h"
#import "AddTaskViewController.h"

@interface DescriptionViewController : BaseViewController

@property AddTaskViewController* parentController;
@property NSString* text;

@end
