//
//  BaseTableViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIImage+ACScaleImage.h"
#import "Reachability.h"
#import "ApplicationManager.h"

@interface BaseTableViewController ()
@property (nonatomic)BOOL currentReachStatus;
@end

@implementation BaseTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    if(reach.isReachableViaWiFi || reach.isReachableViaWWAN)
    {
        self.currentReachStatus=YES;
    }
    [reach startNotifier];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reachabilityChanged:(NSNotification *)not
{
    Reachability* reach=[not object];
    
    if(reach.isReachableViaWiFi)
    {
        if(!self.currentReachStatus)
        {
            UIView * toolBarHidenView=[[UIView alloc] initWithFrame:self.navigationController.toolbar.frame];
            toolBarHidenView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
            [self.navigationController.toolbar addSubview:toolBarHidenView];
            [self.navigationController.view addSubview:self.loadContentView];
            [[ApplicationManager sharedApplication].syncApplicationManager syncWithCompletion:^(BOOL completed)
         {
             if(completed)
             {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                 {
                     [self reloadData];
                     [self.loadContentView removeFromSuperview];
                     [toolBarHidenView removeFromSuperview];
                     self.currentReachStatus=YES;
                 });
             }
         }];
        }
    }
    else if(reach.isReachableViaWWAN && !self.currentReachStatus)
    {
        if(!self.currentReachStatus)
        {
            UIView * toolBarHidenView=[[UIView alloc] initWithFrame:self.navigationController.toolbar.frame];
            toolBarHidenView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
            [self.navigationController.toolbar addSubview:toolBarHidenView];
            [self.navigationController.view addSubview:self.loadContentView];
            [[ApplicationManager sharedApplication].syncApplicationManager syncWithCompletion:^(BOOL completed)
             {
                 if(completed)
                 {
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                    {
                                        [self reloadData];
                                        [self.loadContentView removeFromSuperview];
                                        [toolBarHidenView removeFromSuperview];
                                        self.currentReachStatus=YES;
                                    });
                 }
             }];
        }
    }
    else
    {
        //no internet
        self.currentReachStatus=NO;
        NSLog(@"%@",reach);
    }
    
}

-(void)reloadData
{
    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refreshDidSwipe
{
    [self.tableView reloadData];
    [self.refresh endRefreshing];
}

-(void)refreshDidSwipeEvent
{
    [[ApplicationManager sharedApplication].syncApplicationManager syncWithCompletion:^(BOOL completed)
     {
         if(completed)
         {
             dispatch_async(dispatch_get_main_queue(), ^
             {
                    [self refreshDidSwipe];
             });
         }
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    self.refresh=[[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-15, 0, 40, 40)];
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addSubview:self.refresh];
    [self.refresh addTarget:self action:@selector(refreshDidSwipeEvent) forControlEvents:UIControlEventValueChanged];
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:self.tableView];
    
    self.emptyTableHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)];
    self.emptyTableHeader.backgroundColor=[UIColor whiteColor];
    UIImageView * imageView=[[UIImageView alloc] init];
    imageView.image=[UIImage imageWithImage:[UIImage imageNamed:@"You free"] scaledToSize:CGSizeMake(180.0, 180.0)];
    imageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.emptyTableHeader addSubview:imageView];
    
    [self.emptyTableHeader addConstraint:[NSLayoutConstraint
                                          constraintWithItem:imageView
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.emptyTableHeader
                                          attribute:NSLayoutAttributeCenterX
                                          multiplier:1.0f
                                          constant:0.f]];
    
    [self.emptyTableHeader addConstraint:[NSLayoutConstraint
                                          constraintWithItem:imageView
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.emptyTableHeader
                                          attribute:NSLayoutAttributeCenterY
                                          multiplier:1.0f
                                          constant:0.f]];
    
    [self setConstraints];
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        self.tableView.cellLayoutMarginsFollowReadableWidth=NO;
    }
}

-(void)setConstraints
{
    self.trailing =[NSLayoutConstraint
                    constraintWithItem:self.tableView
                    attribute:NSLayoutAttributeTrailing
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.view
                    attribute:NSLayoutAttributeTrailing
                    multiplier:1.0f
                    constant:0.f];
    
    self.leading = [NSLayoutConstraint
                    constraintWithItem:self.tableView
                    attribute:NSLayoutAttributeLeading
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.view
                    attribute:NSLayoutAttributeLeading
                    multiplier:1.0f
                    constant:0.f];
    
    self.bottom =[NSLayoutConstraint
                  constraintWithItem:self.tableView
                  attribute:NSLayoutAttributeBottom
                  relatedBy:NSLayoutRelationEqual
                  toItem:self.view
                  attribute:NSLayoutAttributeBottom
                  multiplier:1.0f
                  constant:0.f];
    
    self.top =[NSLayoutConstraint
               constraintWithItem:self.tableView
               attribute:NSLayoutAttributeTop
               relatedBy:NSLayoutRelationEqual
               toItem:self.view
               attribute:NSLayoutAttributeTop
               multiplier:1.0f
               constant:0.f];
    
    //self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:self.trailing];
    [self.view addConstraint:self.leading];
    [self.view addConstraint:self.bottom];
    [self.view addConstraint:self.top];
}

@end
