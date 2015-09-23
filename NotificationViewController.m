//
//  NotificationViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 17/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCell.h"
#import "CommonMethodClass.h"
#import "Constants.h"
@interface NotificationViewController ()
- (IBAction)backAction:(id)sender;


@end

@implementation NotificationViewController
@synthesize loadValue;

-(void)drawView{
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
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    self.tableView.separatorColor=sepColor;
    [self drawView];
    loadValue=[[NSArray alloc]initWithObjects:@"Default",
               @"Throttle notifications to once a day, unless urgent",
               @"Notify me about urgent requests",
               @"Notify me immediately when someone prays for me",
               @"Someone follows me",
               @"Someone wants to be my friend",
               @"Someone shares my request",
               @"A friend posts a request",
               @"A person I follow posts a request",
               @"Someone prays for me",
               @"My prayer request is expiring",
               @"Someone likes my request",
               @"Someone I invited joined Generous",nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.allowsMultipleSelection=YES;
    
    
    // Do any additional setup after loading the view.
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
    return loadValue.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NotificationCell class])];
    cell.tittleLbl.text=self.loadValue[indexPath.row];
    if (indexPath.row==0||indexPath.row==3||indexPath.row==8) {
        cell.selectionImage.image=[UIImage imageNamed:@"unselect.png"];
    }
    else
    {
        cell.selectionImage.image=[UIImage imageNamed:@"select.png"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    if (indexPath.row==[self.loadValue count]-1) {
       
    }
    else
    {
        
        UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
        UILabel *lineLbl=[[UILabel alloc]init];
        [lineLbl setFrame:CGRectMake(0, 67, self.tableView.frame.size.width,0.5)];
        [lineLbl setBackgroundColor:sepColor];
        [cell.contentView addSubview:lineLbl];
        
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [self updateButtonsToMatchTableState];
}

-(void)updateButtonsToMatchTableState
{
    NSMutableArray *temp=[NSMutableArray array];
    // The user tapped one of the OK/Cancel buttons.
    
        // Delete what the user selected.
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        BOOL deleteSpecificRows = selectedRows.count > 0;
        if (deleteSpecificRows)
        {
            // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [indicesOfItemsToDelete addIndex:selectionIndex.row];
                
                [temp addObject:[self.loadValue objectAtIndex:selectionIndex.row]];
            }
            NSLog(@"%@",temp);
            // Delete the objects from our data model.
//            [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
            
            // Tell the tableView that we deleted the objects
//            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            NSLog(@"no value selected");
            // Delete everything, delete the objects from our data model.
            
            // Tell the tableView that we deleted the objects.
            // Because we are deleting all the rows, just reload the current table section
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }

}



- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
