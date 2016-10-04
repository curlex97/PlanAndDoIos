//
//  CategoryApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApiManager.h"
#import "KSCategory.h"
#import "KSAuthorisedUser.h"

@interface CategoryApiManager : ApiManager

-(void) addCategoriesAsync:(NSArray*)categories forUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;

-(void) updateCategoriesAsync:(NSArray*)categories forUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;

-(void) deleteCategoriesAsync:(NSArray*)categories forUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;

-(void) syncCategoriesWithCompletion:(void (^)(NSDictionary*))completed;

@end
