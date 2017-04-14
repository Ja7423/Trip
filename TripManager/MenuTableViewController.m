//
//  MenuTableViewController.m
//  TripManager
//
//  Created by 何家瑋 on 2017/4/12.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "MenuTableViewController.h"

@interface MenuTableViewController ()
{
        NSArray * contentArray;
}

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
        [super viewDidLoad];
        
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.separatorColor = [UIColor clearColor];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@menuTableViewCellReuseIdentifier];
        
        contentArray = [self confirgureContent];
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (NSArray *)confirgureContent
{
        return @[@"shared schedule", @"direction app setting"];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@menuTableViewCellReuseIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = contentArray[indexPath.row];
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        switch (indexPath.row) {
                case 0:
                        [self showExchangeScheduleList];
                        break;
                case 1:
                        [self chooseDirectionApp];
                        break;
                default:
                        break;
        }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
        view.backgroundColor = [UIColor clearColor];
        return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        // status bar height
        return 20;
}

#pragma mark - action
- (void)chooseDirectionApp
{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"choose your direction app" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSArray * apps = @[@googleMap, @appleMap];
        for (NSString * app in apps) {
                UIAlertAction * action = [UIAlertAction actionWithTitle:app style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                        [[NSUserDefaults standardUserDefaults] setObject:action.title forKey:@directionAppKey];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                }];
                
                [alertController addAction:action];
        }
        
        [self shouldPresentViewControllerInHomeViewController:alertController];
}

- (void)showExchangeScheduleList
{
        FileManager * manager = [[FileManager alloc]init];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"choose file" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSArray * files = [manager readInboxList];
        for (NSURL * fileLocation in files)
        {
                NSString * title = fileLocation.lastPathComponent;
                UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        PreviewTableViewController * previewVC = [storyBoard instantiateViewControllerWithIdentifier:@"PreviewTableViewController"];
                        previewVC.fileName = action.title;
                        [self shouldPresentViewControllerInHomeViewController:previewVC];
                }];
                
                [alertController addAction:action];
        }
        
        // cancel button
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // do nothing
        }];
        
        [alertController addAction:cancelAction];
        
        // clear button
        UIAlertAction * cleanAction = [UIAlertAction actionWithTitle:@"clean all" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"click %@", action.title);
                [manager removeInboxFile];
        }];
        
        [alertController addAction:cleanAction];
        
        [self shouldPresentViewControllerInHomeViewController:alertController];
}

- (void)shouldPresentViewControllerInHomeViewController:(UIViewController *)presentViewController
{
        if ([_delegate respondsToSelector:@selector(viewController:shouldPresentViewController:)])
        {
                [_delegate viewController:self shouldPresentViewController:presentViewController];
        }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
