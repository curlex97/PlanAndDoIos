
#import "TaskListViewController.h"

@interface TaskListViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic)NSMutableArray * tasks;
@property (nonatomic)NSUInteger bottomOffset;
@property (nonatomic)NSUInteger keyboardOffset;
@property (nonatomic)UITextField * textField;
@property (nonatomic)UIView * toolBarView;
@property (nonatomic)UITapGestureRecognizer * tap;
@end

@implementation TaskListViewController

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self.textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tasks insertObject:textField.text atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    textField.text=@"";
    [textField resignFirstResponder];
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"reuseble cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.textColor=[UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",self.tasks[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType==UITableViewCellAccessoryNone)
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
    }
}

-(void)setBottomConstraintToValue:(float)value inView:(UIView*)view toView:(UIView *)targetView
{
    for(NSLayoutConstraint * constraint in view.constraints)
    {
        if(constraint.firstAttribute==NSLayoutAttributeBottom)
        {
            [view removeConstraint:constraint];
            break;
        }
    }
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:targetView
                         attribute:NSLayoutAttributeBottom
                         relatedBy:NSLayoutRelationEqual
                         toItem:view
                         attribute:NSLayoutAttributeBottom
                         multiplier:1.0f
                         constant:value]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setBottomConstraintToValue:-45.0 inView:self.view toView:self.tableView];
    NSLog(@"%@",self.view.constraints);
    self.title=@"Task list";
    
    self.tap=[[UITapGestureRecognizer alloc] init];
    self.tap.delegate=self;
    
    self.textField=[[UITextField alloc] initWithFrame:CGRectMake(16, 8, self.navigationController.toolbar.frame.size.width-32, 30)];
    self.textField.borderStyle=UITextBorderStyleRoundedRect;
    self.textField.backgroundColor=[UIColor colorWithRed:227.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    self.textField.placeholder=@"Enter your text...";
    self.textField.delegate=self;
    self.bottomOffset=[UIScreen mainScreen].bounds.size.height-110;
    
    self.toolBarView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bottomOffset, self.view.bounds.size.width, 44)];

    self.toolBarView.backgroundColor=[UIColor whiteColor];
    [self.toolBarView addSubview:self.textField];
    [self.view addSubview:self.toolBarView];
    
    self.tasks=[NSMutableArray arrayWithObjects:@"Milk",@"Bread",@"Meat",@"Chery",@"Banana",@"Fish",@"Bread", nil];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.bounds=CGRectMake(self.tableView.bounds.origin.x, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, self.tableView.bounds.size.height-44);
    self.textField.translatesAutoresizingMaskIntoConstraints=NO;
    [self.toolBarView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.textField
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.toolBarView
                                   attribute:NSLayoutAttributeBottom
                                   multiplier:1.0f
                                   constant:-8.0]];
    
    [self.toolBarView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.textField
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.toolBarView
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:8.0]];
    
    [self.toolBarView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.textField
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.toolBarView
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:-16.0]];
    
    [self.toolBarView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.textField
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.toolBarView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:16.0]];
    
    self.toolBarView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.toolBarView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                     constant:0.0]];
    
//    [self.toolBarView addConstraint:[NSLayoutConstraint
//                                     constraintWithItem:self.toolBarView
//                                     attribute:NSLayoutAttributeHeight
//                                     relatedBy:NSLayoutRelationEqual
//                                     toItem:self.toolBarView
//                                     attribute:NSLayoutAttributeHeight
//                                     multiplier:1.0f
//                                     constant:44.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.toolBarView
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                     attribute:NSLayoutAttributeTrailing
                                     multiplier:1.0f
                                     constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.toolBarView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0f
                                     constant:0.0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShown:(NSNotification*) not
{
    [self.view addGestureRecognizer:self.tap];
    NSDictionary * info=[not userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    self.toolBarView.translatesAutoresizingMaskIntoConstraints = YES;
    self.tableView.translatesAutoresizingMaskIntoConstraints=YES;
    [UIView animateWithDuration:1 animations:^
     {
         self.toolBarView.frame=CGRectMake(0, self.bottomOffset-keyboardSize.height, self.view.bounds.size.width, 44);
         self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height-keyboardSize.height);
     } completion:^(BOOL finished)
     {
         if(finished)
         {
             dispatch_async(dispatch_get_main_queue(), ^
             {
                 self.toolBarView.translatesAutoresizingMaskIntoConstraints = NO;
                 self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
                 [self setBottomConstraintToValue:-keyboardSize.height inView:self.view toView:self.toolBarView];
                 [self setBottomConstraintToValue:-keyboardSize.height-45.0 inView:self.view toView:self.tableView];

             });
             
         }
     }];
}

-(void)keyboardWillHide:(NSNotification*) not
{
    [self.view removeGestureRecognizer:self.tap];
    NSDictionary * info=[not userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    self.toolBarView.translatesAutoresizingMaskIntoConstraints = YES;
    self.tableView.translatesAutoresizingMaskIntoConstraints = YES;
    [UIView animateWithDuration:1 animations:^
     {
         self.toolBarView.frame=CGRectMake(0, self.bottomOffset, self.view.bounds.size.width, 44);
         self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height+keyboardSize.height);
     } completion:^(BOOL finished)
     {
         if(finished)
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                self.toolBarView.translatesAutoresizingMaskIntoConstraints = NO;
                                self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
                                [self setBottomConstraintToValue:0 inView:self.view toView:self.toolBarView];
                                [self setBottomConstraintToValue:-45.0 inView:self.view toView:self.tableView];
                                
                            });
             
         }
     }];
}

-(void)dealloc
{
    self.navigationController.toolbarHidden=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
