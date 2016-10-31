//
//  BaseKSMenuViewController.h
//  PlanAndDo
//
//  Created by Амин on 14.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AMSideBarViewController.h"
#import "KSCategory.h"
#import "ApplicationManager.h"
#import "TaskTableViewCell.h"
#import "TabletasksViewController.h"
typedef NS_ENUM(NSInteger, KSBaseMenuState)
{
    KSBaseMenuStateNormal,
    KSBaseMenuStateSearch,
    KSBaseMenuStateEdit
};

@interface BaseKSMenuViewController : BaseTableViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, KSMenuDelegate>
@property (nonatomic)NSMutableArray<KSCategory *> * categories;
@property (nonatomic)UISearchBar * searchBar;
@property (nonatomic)UILongPressGestureRecognizer * longPress;
@property NSMutableArray* allTasks;
@property NSMutableArray* tableTasks;
@property (nonatomic) NSIndexPath * managedIndexPath;
@property (nonatomic) UIPanGestureRecognizer * pan;
@property (nonatomic) UITapGestureRecognizer * tap;
@property (nonatomic) UIButton * addCategoryButton;
@property (nonatomic)KSBaseMenuState state;
@property (nonatomic)NSUInteger test;

-(void)addCategoryDidTap;
-(void)gestureRecognizerAction;
-(void) refreshSearch;
@end
