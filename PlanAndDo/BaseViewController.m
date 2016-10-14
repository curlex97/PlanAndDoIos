//
//  BaseViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "BaseViewController.h"
#import "KSApplicationColor.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBarImage];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)setBarImage
{
//    CAGradientLayer * gradient=[KSApplicationColor sharedColor].rootGradient;
//    gradient.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45);
//    
//    NSLog(@"%@", NSStringFromCGRect(gradient.frame));
//    UIGraphicsBeginImageContext([gradient frame].size);
//    
//    [gradient renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    [self.navigationController.navigationBar setBackgroundImage:outputImage forBarMetrics:UIBarMetricsDefault];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    [self setBarImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setBarImage];
    self.view.clipsToBounds=YES;
    self.view.autoresizesSubviews=YES;
    self.view.opaque=YES;
    self.view.clearsContextBeforeDrawing=YES;
    
    self.loadContentView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.loadContentView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    
    UIView * searchView=[[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-80.0, [UIScreen mainScreen].bounds.size.height/2-50.0, 160.0, 100.0)];
    searchView.backgroundColor=[UIColor whiteColor];
    searchView.layer.cornerRadius=8.0;
    
    UILabel * searchLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 60.0, 160.0, 30.0)];
    searchLabel.text=@"Load...";
    searchLabel.adjustsFontSizeToFitWidth=YES;
    searchLabel.textAlignment=NSTextAlignmentCenter;
    searchLabel.textColor=[UIColor blackColor];
    
    UIActivityIndicatorView * activityInd=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(55.0, 10.0, 50.0, 50.0)];
    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityInd.color=[UIColor blackColor];
    activityInd.hidesWhenStopped=YES;
    [activityInd startAnimating];
    
    [searchView addSubview:searchLabel];
    [searchView addSubview:activityInd];
    [self.loadContentView addSubview:searchView];
    
    [self.loadContentView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:searchView
                                                  attribute:NSLayoutAttributeCenterX
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.loadContentView
                                                  attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0f
                                                  constant:0.0]];
    
    [self.loadContentView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:searchView
                                                  attribute:NSLayoutAttributeCenterY
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.loadContentView
                                                  attribute:NSLayoutAttributeCenterY
                                                  multiplier:1.0f
                                                  constant:0.0]];
    
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.toolbarHidden=YES;
    //self.navigationController.toolbar.clipsToBounds=YES;
    //self.navigationController.toolbar.autoresizesSubviews=YES;
    self.navigationController.toolbar.opaque=YES;
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    self.navigationController.toolbar.backgroundColor=[UIColor whiteColor];
    self.navigationController.toolbar.barTintColor=[UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


@end
