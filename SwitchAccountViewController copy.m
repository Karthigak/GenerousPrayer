//
//  SwitchAccountViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 24/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "SwitchAccountViewController.h"
#import "SwitchCell.h"
#import "CommonMethodClass.h"
#import "Constants.h"
@interface SwitchAccountViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *naviView;

@end

@implementation SwitchAccountViewController
-(void)drawBorder
{
    if (isiPad) {
        
        [self.naviView setFrame:CGRectMake(self.naviView.bounds.origin.x, self.naviView.bounds.origin.y,1024, self.naviView.bounds.size.height)];
    }
    else
    {
        [self.naviView setFrame:CGRectMake(self.naviView.bounds.origin.x, self.naviView.bounds.origin.y,600, self.naviView.bounds.size.height)];
        
    }
    

    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.naviView.bounds];
    self.naviView.layer.masksToBounds = NO;
    self.naviView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.naviView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.naviView.layer.shadowOpacity = 0.3f;
    self.naviView.layer.shadowPath = shadowPath.CGPath;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBorder];
    self.tableView.backgroundColor=[UIColor clearColor];
  

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if(orientation == UIInterfaceOrientationPortrait){
        if(isiPad){
            
            CGFloat width = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
        }
        else{
            
        }
        
        
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        if(isiPad){
            
            CGFloat width = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
            
        }
        else{
            
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchCell class])];
        cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.nameLbl.text=@"Jhon henry";
        cell.emailLbl.text=@"Jhon@example.com";
        
    }
    else if (indexPath.row==1)
    {
        cell.nameLbl.text=@"Daniel";
        cell.emailLbl.text=@"Daniel@example.com";
        
    }
    else if (indexPath.row==2)
    {
        cell.nameLbl.text=@"Alex";
        cell.emailLbl.text=@"Alex@example.com";
        
        
    } else if (indexPath.row==3)
    {
        cell.nameLbl.text=@"Oliva";
        cell.emailLbl.text=@"Oliva@example.com";
        
    }
    
    if (indexPath.row==3) {
        
    }
    else
    {
        
        UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
        UILabel *lineLbl=[[UILabel alloc]init];
        [lineLbl setFrame:CGRectMake(0, 97, self.tableView.frame.size.width,0.5)];
        [lineLbl setBackgroundColor:sepColor];
        [cell.contentView addSubview:lineLbl];
        
    }
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
    UIButton *selectFlight = [[UIButton alloc]init];
    selectFlight.frame= CGRectMake( sectionFooterView.frame.size.width/2,10, 44, 45);
  
    [selectFlight setImage:[UIImage imageNamed:@"addrequest.png"] forState:UIControlStateNormal];
    
    [selectFlight addTarget:self action:@selector(searchFlight) forControlEvents:UIControlEventTouchUpInside];
  
    [sectionFooterView addSubview:selectFlight];
    
    
    
    return sectionFooterView;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
    
    
}
-(void)searchFlight
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self.tableView reloadData];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
