//
//  AMAndroidSideBarViewController.h
//  PlanAndDo
//
//  Created by Амин on 10.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMAndroidSideBarViewController : UIViewController
+(AMAndroidSideBarViewController *)sideBarWithFrontVC:(UIViewController *)frontVC andBackVC:(UIViewController *)backVC;

@property (nonatomic)UIViewController * backViewController;
@property (nonatomic)UIViewController * frontViewController;

-(void)setNewBackViewController:(UIViewController *)frontViewController;
-(void)side;
@end
