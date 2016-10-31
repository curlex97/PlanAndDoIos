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
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString * name=[[UIDevice currentDevice].model isEqualToString:@"iPad"]?@"IPad":@"Main";
    self.baseStoryboard=[UIStoryboard storyboardWithName:name bundle:nil];
                         
    self.view.clipsToBounds=YES;
    self.view.autoresizesSubviews=YES;
    self.view.opaque=YES;
    self.view.clearsContextBeforeDrawing=YES;
    
    self.loadController = [UIAlertController alertControllerWithTitle:nil
                                                                     message:@"Loading...\n\n"
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.color = [UIColor blackColor];
    indicator.translatesAutoresizingMaskIntoConstraints=NO;
    [self.loadController.view addSubview:indicator];
    NSDictionary * views = @{@"pending" : self.loadController.view, @"indicator" : indicator};
    
    NSArray * constraintsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicator]-(20)-|" options:0 metrics:nil views:views];
    NSArray * constraintsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[indicator]|" options:0 metrics:nil views:views];
    NSArray * constraints = [constraintsVertical arrayByAddingObjectsFromArray:constraintsHorizontal];
    [self.loadController.view addConstraints:constraints];
    [indicator setUserInteractionEnabled:NO];
    [indicator startAnimating];
    
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

-(void)setConsctraintsForLoadView
{

}

@end
