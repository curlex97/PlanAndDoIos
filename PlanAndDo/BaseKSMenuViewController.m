//
//  BaseKSMenuViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseKSMenuViewController.h"

@interface BaseKSMenuViewController ()

@end

@implementation BaseKSMenuViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}

-(void)reloadData
{
    self.categories = [NSMutableArray arrayWithArray:[[ApplicationManager categoryApplicationManager] allCategories]];
    self.allTasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasks]];
    [super reloadData];
}

-(void)refreshDidSwipe
{
    self.categories = [NSMutableArray arrayWithArray:[[ApplicationManager categoryApplicationManager] allCategories]];
    self.allTasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasks]];
    [super refreshDidSwipe];
}

-(void)gestureRecognizerAction
{
    if([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
        for (UIView *view in self.searchBar.subviews)
        {
            for (id subview in view.subviews)
            {
                if ( [subview isKindOfClass:[UIButton class]] )
                {
                    [subview setEnabled:YES];
                    return;
                }
            }
        }
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self gestureRecognizerAction];
    return YES;
}

#pragma mark Search Bar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
    searchBar.clearsContextBeforeDrawing=YES;
    searchBar.text=@"";
    
    self.state=KSBaseMenuStateNormal;
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    self.state=KSBaseMenuStateSearch;
    searchBar.showsCancelButton=YES;
    self.allTasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasks]];
    
    [self refreshSearch];
    
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self refreshSearch];
}


-(void) refreshSearch
{
    if(self.searchBar.text.length > 0)
    {
        self.tableTasks = [NSMutableArray array];
        for(BaseTask* task in self.allTasks)
        {
            if([task isKindOfClass:[KSTask class]])
            {
                KSTask* realTask = (KSTask*)task;
                if([realTask.name.lowercaseString containsString:self.searchBar.text.lowercaseString] ||
                   [realTask.taskDescription.lowercaseString containsString:self.searchBar.text.lowercaseString])
                    [self.tableTasks addObject:task];
            }
            
            
            else if([task isKindOfClass:[KSTaskCollection class]])
            {
                KSTaskCollection* realTask = (KSTaskCollection*)task;
                for(KSShortTask* subTask in [[ApplicationManager subTasksApplicationManager] allSubTasksForTask:realTask])
                {
                    if([subTask.name.lowercaseString containsString:self.searchBar.text.lowercaseString])
                    {
                        [self.tableTasks addObject:task];
                        break;
                    }
                }
            }
            
        }
        
    }
    else self.tableTasks = [NSMutableArray arrayWithArray:self.allTasks];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result;
    if(self.state==KSBaseMenuStateNormal)
    {
        if(section==0)
        {
            result = 0;
        }
        else if(section==1)
        {
            result = self.categories.count;
        }
        else
        {
            result = 2;
        }
    }
    else if(self.state==KSBaseMenuStateSearch)
    {
        result = self.tableTasks.count;
    }
    else
    {
        result = self.categories.count;
    }
    return result;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.state==KSBaseMenuStateSearch)
    {
        return 55;
    }
    else
    {
        return 45;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result;
    if(self.state==KSBaseMenuStateNormal)
    {
        result=3;
    }
    else
    {
        result=1;
    }
    return result;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==1 && self.state==KSBaseMenuStateNormal)
    {
        return NM_CATEGORIES;
    }
    else if(section==2 && self.state!=KSBaseMenuStateSearch && self.categories.count>0)
    {
        return @"aaa";
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1 && self.state==KSBaseMenuStateNormal)
    {
        UIView * view=[[UIView alloc] init];
        view.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
        
        UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        imageView.image=[UIImage imageNamed:NM_CATEGORY];
        
        UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 30)];
        titleLabel.textColor=[UIColor colorWithRed:163.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:0.35];
        titleLabel.text=NM_CATEGORY;
        titleLabel.font=[UIFont systemFontOfSize:12];
        
        self.addCategoryButton=[[UIButton alloc] initWithFrame:CGRectMake(230, 0, 30, 30)];
        [self.addCategoryButton setTitle:@"Edit" forState:UIControlStateNormal];
        self.addCategoryButton.titleLabel.textColor=[UIColor whiteColor];
        self.addCategoryButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [self.addCategoryButton addTarget:self action:@selector(addCategoryDidTap) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:titleLabel];
        [view addSubview:self.addCategoryButton];
        [view addSubview:imageView];
        return view;
    }
    else if(section==2 && self.state==KSBaseMenuStateNormal)
    {
        UIView * view=[[UIView alloc] init];
        view.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
        
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==2 && self.state==KSBaseMenuStateNormal && self.categories.count>0)
    {
        return 45.0;
    }
    else if(section==1 && self.state==KSBaseMenuStateNormal)
    {
        return 30.0;
    }
    else
    {
        return  0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(void)addCategoryDidTap
{
    
}

-(void) refreshCategoriesInTable:(NSNotification*)not
{
    self.categories=[NSMutableArray arrayWithArray:[[ApplicationManager categoryApplicationManager] allCategories]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)longPressDidUsed:(UILongPressGestureRecognizer *)gestureRecognizer
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCategoriesInTable:) name:NC_SYNC_CATEGORIES object:nil];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.state=KSBaseMenuStateNormal;
    
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDidUsed:)];
    longPress.minimumPressDuration=1.0;
    longPress.delegate=self;
    
    [self.tableView addGestureRecognizer:longPress];
    
    self.tap=[[UITapGestureRecognizer alloc] init];
    self.tap.delegate=self;
    self.tap.enabled=NO;
    
    self.pan=[[UIPanGestureRecognizer alloc] init];
    self.pan.delegate=self;
    self.pan.enabled=NO;
    
    [self.view addGestureRecognizer:self.pan];
    [self.view addGestureRecognizer:self.tap];
    
    self.searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(8, 8, 255, 30)];
    self.searchBar.searchBarStyle=UISearchBarStyleMinimal;
    self.searchBar.tintColor=[UIColor whiteColor];
    self.searchBar.barTintColor=[UIColor whiteColor];
    self.searchBar.delegate=self;
    self.searchBar.placeholder=@"Search";
    
    UIView * searchBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 46)];
    [searchBarView addSubview:self.searchBar];
    
    self.tableView.tableHeaderView=searchBarView;
    [[UITextField appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
    [self.refresh removeFromSuperview];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:163.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:0.35]];
    
    self.categories=[NSMutableArray arrayWithArray:[[ApplicationManager categoryApplicationManager] allCategories]];
    
    
    self.view.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    self.tableView.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    [self.view removeConstraint:self.top];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.tableView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0f
                              constant:20.f]];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
