//
//  CategoryApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CategoryApiManager.h"

@implementation CategoryApiManager

-(void)addCategoryAsync:(KSCategory *)category forUser:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
{

}

-(void)updateCategoryAsync:(KSCategory *)category forUser:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
{
    
}

-(void)deleteCategoryAsync:(KSCategory *)category forUser:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
{
    
}

-(void)syncCategoriesWithCompletion:(void (^)(bool))completed
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completed(true);
    });
}

@end
