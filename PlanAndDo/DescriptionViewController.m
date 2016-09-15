//
//  DescriptionViewController.m
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()
@property (nonatomic)UITextView * textView;
@end

@implementation DescriptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Description";
    UIBarButtonItem * doneItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidTap)];
    doneItem.tintColor=[UIColor whiteColor];
    UIBarButtonItem * cancelItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelDidTap)];
    doneItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=doneItem;
    self.navigationItem.leftBarButtonItem=cancelItem;
    self.textView=[[UITextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.textView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneDidTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelDidTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
