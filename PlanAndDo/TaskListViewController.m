
#import "TaskListViewController.h"

@interface TaskListViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic)NSMutableArray * tasks;
@property (nonatomic)NSUInteger bottomOffset;
@property (nonatomic)NSUInteger keyboardOffset;
@property (nonatomic)UITextField * textField;
@property (nonatomic)UIView * toolBarView;
@end

@implementation TaskListViewController


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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.toolbarHidden=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Task list";
    self.textField=[[UITextField alloc] initWithFrame:CGRectMake(16, 8, self.navigationController.toolbar.frame.size.width-32, 30)];
    self.textField.borderStyle=UITextBorderStyleRoundedRect;
    self.textField.backgroundColor=[UIColor colorWithRed:227.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    self.textField.placeholder=@"Enter your text...";
    self.textField.delegate=self;
    self.bottomOffset=[UIScreen mainScreen].bounds.size.height-108;
    
    self.toolBarView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bottomOffset, self.view.bounds.size.width, 44)];

    self.toolBarView.backgroundColor=[UIColor blackColor];
    [self.toolBarView addSubview:self.textField];
    [self.view addSubview:self.toolBarView];
    
    self.tasks=[NSMutableArray arrayWithObjects:@"Milk",@"Bread",@"Meat", nil];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyboardWillShown:(NSNotification*) not
{
    NSDictionary * info=[not userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^
     {
         self.toolBarView.frame=CGRectMake(0, self.bottomOffset-keyboardSize.height, self.view.bounds.size.width, 44);
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
