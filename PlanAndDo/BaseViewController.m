//
//  BaseViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "BaseViewController.h"
#import "KSApplicatipnColor.h"
#import "UIImage+ACScaleImage.h"

#define BAR_BUTTON_SIZE 50

//#import "KSToolBarCustomView.h"

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
    
    CAGradientLayer * gradient=[KSApplicatipnColor sharedColor].rootGradient;
    gradient.frame=self.navigationController.navigationBar.bounds;
    UIGraphicsBeginImageContext([gradient frame].size);
    
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:outputImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        CALayer * gradient=self.navigationController.navigationBar.layer.sublayers[1];
        gradient.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, self.navigationController.navigationBar.bounds.size.height-12);
    }
    else
    {
        CALayer * gradient=self.navigationController.navigationBar.layer.sublayers[1];
        gradient.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, self.navigationController.navigationBar.bounds.size.height+12);
    }
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
    
    self.navigationController.toolbarHidden=YES;
    self.navigationController.toolbar.clipsToBounds=YES;
    self.navigationController.toolbar.autoresizesSubviews=YES;
    self.navigationController.toolbar.opaque=YES;
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    self.navigationController.toolbar.backgroundColor=[UIColor whiteColor];
    self.navigationController.toolbar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSLog(@"%@",self.navigationController.navigationBar.layer.sublayers);
    //    CGRect pathRect=self.navigationController.toolbar.bounds;
    //    pathRect.size=self.navigationController.toolbar.frame.size;
    //    self.navigationController.toolbar.layer.shadowColor=[UIColor blackColor].CGColor;
    //    self.navigationController.toolbar.layer.shadowPath=[UIBezierPath bezierPathWithRect:pathRect].CGPath;
    //    self.navigationController.toolbar.layer.shadowRadius=30.0;
    //    self.navigationController.toolbar.layer.shadowOpacity = 0.0f;
    //    self.navigationController.toolbar.layer.rasterizationScale=[UIScreen mainScreen].scale;
    //    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"repoCell"owner:self options:nil];
    //    KSToolBarCustomView * view=[nib objectAtIndex:0];
    //    view.imageView.image=[UIImage imageNamed:@"Today"];
    //    view.title=@""
    UIBarButtonItem * spaceItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    //spaceItem.width=30;
    UIBarButtonItem * today=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Today"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)] style:UIBarButtonItemStyleDone target:self action:@selector(todayDidTap)];
    //today.width=45;
    //today.possibleTitles=[today.possibleTitles setByAddingObject:@"Allah"];
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    UIBarButtonItem * tomorrow=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Tomorrow"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)] style:UIBarButtonItemStyleDone target:self action:@selector(tomorrowDidTap)];
    //tomorrow.width=45;
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    UIBarButtonItem * week=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Week"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)] style:UIBarButtonItemStyleDone target:self action:@selector(weekDidTap)];
    //week.width=45;
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    UIBarButtonItem * backLog=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Backlog"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)] style:UIBarButtonItemStyleDone target:self action:@selector(backLogDidTap)];
    //backLog.width=45;
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    UIBarButtonItem * archive=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Archive"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)] style:UIBarButtonItemStyleDone target:self action:@selector(tomorrowDidTap)];
    //archive.width=45;
    self.toolbarItems=[NSArray arrayWithObjects:
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       today,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       tomorrow,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       week,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       backLog,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       archive,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       nil];
    
    
    self.refresh=[[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-15, 0, 40, 40)];
    
    [self.tableView addSubview:self.refresh];
    [self setConstraints];
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