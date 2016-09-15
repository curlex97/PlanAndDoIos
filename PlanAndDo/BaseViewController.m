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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.clipsToBounds=YES;
    self.view.autoresizesSubviews=YES;
    self.view.opaque=YES;
    self.view.clearsContextBeforeDrawing=YES;
    
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