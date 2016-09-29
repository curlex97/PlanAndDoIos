//
//  KSApplicatipnColor.m
//  PlanAndDo
//
//  Created by Амин on 10.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSApplicationColor.h"
#import "ApplicationDefines.h"

@implementation KSApplicationColor

static KSApplicationColor * applicationColorInstance;
+(KSApplicationColor *)sharedColor
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^
                  {
                      applicationColorInstance=[[KSApplicationColor alloc] init];
                  });
    return applicationColorInstance;
}

-(CAGradientLayer *)rootGradient
{
    UIColor *leftColor = [UIColor colorWithRed:CLR_ROOT_GRADIENT_LEFT_RED green:CLR_ROOT_GRADIENT_LEFT_GREEN blue:CLR_ROOT_GRADIENT_LEFT_BLUE alpha:CLR_ROOT_GRADIENT_LEFT_ALPHA];
    UIColor *rightColor = [UIColor colorWithRed:CLR_ROOT_GRADIENT_RIGHT_RED green:CLR_ROOT_GRADIENT_RIGHT_GREEN blue:CLR_ROOT_GRADIENT_RIGHT_BLUE alpha:CLR_ROOT_GRADIENT_RIGHT_ALPHA];
    CAGradientLayer * gradient = [CAGradientLayer layer];
    gradient.colors = @[ (__bridge id)leftColor.CGColor,
                                                      (__bridge id)rightColor.CGColor ];
    gradient.startPoint = CGPointMake(CLR_ROOT_GRADIENT_START_POINT_X, CLR_ROOT_GRADIENT_START_POINT_Y);
    gradient.endPoint = CGPointMake(CLR_ROOT_GRADIENT_END_POINT_X, CLR_ROOT_GRADIENT_END_POINT_Y);
    return gradient;
}
-(instancetype)init
{
    if(applicationColorInstance)
    {
        return nil;
    }
    else
    {
        return [super init];
    }
}
@end
