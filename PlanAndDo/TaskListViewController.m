
#import "TaskListViewController.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "KSShortTask.h"

@interface TaskListViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic)NSMutableArray<KSShortTask *> * tasks;
@property (nonatomic)NSUInteger bottomOffset;
@property (nonatomic)NSUInteger keyboardOffset;
@property (nonatomic)UITextField * textField;
@property (nonatomic)UIView * toolBarView;
@property (nonatomic)UITapGestureRecognizer * tap;
@property (nonatomic)NSLayoutConstraint * bottomContraint;
@end

@implementation TaskListViewController

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self.textField resignFirstResponder];
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        [self.tasks removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tasks insertObject:[[KSShortTask alloc] initWithID:0 andName:textField.text andStatus:NO andSyncStatus:0] atIndex:0];
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
    cell.textLabel.text=self.tasks[indexPath.row].name;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType==UITableViewCellAccessoryNone)
    {
        self.tasks[indexPath.row].status=YES;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
        self.tasks[indexPath.row].status=NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.bottom.constant=-45;
    [self.view layoutIfNeeded];
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
    
    self.tasks=[NSMutableArray array];
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
    self.bottomContraint=[NSLayoutConstraint
                          constraintWithItem:self.toolBarView
                          attribute:NSLayoutAttributeBottom
                          relatedBy:NSLayoutRelationEqual
                          toItem:self.view
                          attribute:NSLayoutAttributeBottom
                          multiplier:1.0f
                          constant:0.0];
    [self.view addConstraint:self.bottomContraint];
    
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
    
    self.bottomContraint.constant=-keyboardSize.height;
    self.bottom.constant=-keyboardSize.height-45.0;
    
    [UIView animateWithDuration:1 animations:^
     {
         [self.view layoutIfNeeded];
     } completion:nil];
}

-(void)keyboardWillHide:(NSNotification*) not
{
    [self.view removeGestureRecognizer:self.tap];

    self.bottomContraint.constant=0;
    self.bottom.constant=-45;
    [UIView animateWithDuration:1 animations:^
     {
         [self.view layoutIfNeeded];
     } completion:nil];
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
