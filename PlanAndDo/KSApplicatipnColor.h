//
//  KSApplicatipnColor.h
//  PlanAndDo
//
//  Created by Амин on 10.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//
//typedef NS_ENUM(CGColorRef, priorityColor)
//{
//    SideDirectionRight=0,
//    SideDirectionLeft
//};

@interface KSApplicatipnColor : NSObject
+(KSApplicatipnColor *)sharedColor;

@property (nonatomic)UIColor * menuTextColor;
@property (nonatomic)UIColor * menuBackgroundColor;
@property (nonatomic)UIColor * searchBarBackgroundColor;
@property (nonatomic)CAGradientLayer * rootGradient;
@end
