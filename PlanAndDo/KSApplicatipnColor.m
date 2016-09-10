//
//  KSApplicatipnColor.m
//  PlanAndDo
//
//  Created by Амин on 10.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSApplicatipnColor.h"

@implementation KSApplicatipnColor

static KSApplicatipnColor * applicationColorInstance;
+(KSApplicatipnColor *)sharedColor
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^
                  {
                      applicationColorInstance=[[KSApplicatipnColor alloc] init];
                  });
    return applicationColorInstance;
}

-(CAGradientLayer *)rootGradient
{
    UIColor *leftColor = [UIColor colorWithRed:61.0/255.0 green:93.0/255.0 blue:108.0/255.0 alpha:1.0];
    UIColor *rightColor = [UIColor colorWithRed:40.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0];
    CAGradientLayer * gradient = [CAGradientLayer layer];
    gradient.colors = @[ (__bridge id)leftColor.CGColor,
                                                      (__bridge id)rightColor.CGColor ];
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(1.0, 0.5);
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
