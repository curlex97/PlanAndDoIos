//
//  BaseViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "BaseViewController.h"
#import "KSApplicatipnColor.h"

@interface BaseViewController ()
@property NSLayoutConstraint *trailing;
@property NSLayoutConstraint *leading;
@property NSLayoutConstraint *bottom;
@property NSLayoutConstraint *top;
@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title=@"Allah";
    CAGradientLayer * gradient=[KSApplicatipnColor sharedColor].rootGradient;
    gradient.frame=self.navigationController.navigationBar.bounds;
    [self.navigationController.navigationBar.layer insertSublayer:gradient atIndex:1];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)todayDidTap
{

}

-(void)tomorrowDidTap
{
    
}

-(void)weekDidTap
{
    
}

-(void)backLogDidTap
{
    
}

-(void)archiveDidTap
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:self.tableView];
    
    self.view.clipsToBounds=YES;
    self.view.autoresizesSubviews=YES;
    self.view.opaque=YES;
    self.view.clearsContextBeforeDrawing=YES;
    
    self.navigationController.toolbarHidden=NO;
    
    self.navigationController.toolbar.clipsToBounds=YES;
    self.navigationController.toolbar.autoresizesSubviews=YES;
    self.navigationController.toolbar.opaque=YES;
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    
    UIBarButtonItem * today=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Today"] style:UIBarButtonItemStylePlain target:self action:@selector(todayDidTap)];
    today.width=50;
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    UIBarButtonItem * tomorrow=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Tomorrow"] style:UIBarButtonItemStyleDone target:self action:@selector(tomorrowDidTap)];
    tomorrow.width=50;
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    UIBarButtonItem * week=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Week"] style:UIBarButtonItemStyleDone target:self action:@selector(weekDidTap)];
    week.width=50;
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    UIBarButtonItem * backLog=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Backlog"] style:UIBarButtonItemStyleDone target:self action:@selector(backLogDidTap)];
    backLog.width=50;
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    UIBarButtonItem * archive=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Archive"] style:UIBarButtonItemStyleDone target:self action:@selector(tomorrowDidTap)];
    archive.width=50;
    NSLog(@"%f",today.width);
    self.toolbarItems=[NSArray arrayWithObjects:today,tomorrow,week,backLog,archive, nil];
    NSLog(@"%@",self.navigationController.toolbar.items);
    
    self.refresh=[[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-15, 0, 40, 40)];
    [self.tableView addSubview:self.refresh];
    [self setConstraints];
    // Do any additional setup after loading the view.
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
    
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:self.trailing];
    [self.view addConstraint:self.leading];
    [self.view addConstraint:self.bottom];
    [self.view addConstraint:self.top];
}

@end
