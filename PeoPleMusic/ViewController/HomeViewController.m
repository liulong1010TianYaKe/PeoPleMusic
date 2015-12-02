//
//  HomeViewController.m
//  PeoPleMusic
//
//  Created by long on 12/2/15.
//  Copyright © 2015 long. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = nil;
    [self addAutoScrollLabelTitle:@"个人中心"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------------
#pragma mark - TableViewDelegate

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.array.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    CommonGroup *group = self.array[section];
//    return group.items.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    CommonCell *cell = [CommonCell cellWithTableView:tableView];
//    
//    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil] firstObject];
//    }
//    
//    CommonGroup *group = self.array[indexPath.section];
//    cell.item = group.items[indexPath.row];
//    // 设置cell所处的行号 和 所处组的总行数
//    [cell setIndexPath:indexPath rowsInSection:(int)group.items.count];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath     //重写父类中的方法
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.section == 0) {
//        if (![JMUserInfo sharedUserInfo].settleType == SettleTypeMonthSettlement) {
//            if (indexPath.row == 0) {
//                if ([JMUserInfo sharedUserInfo].isLogined) {
//                    MyAccountViewController *myAccountViewController = [[MyAccountViewController alloc]init];
//                    myAccountViewController.title = @"我的账户";
//                    [self.navigationController pushViewController:myAccountViewController animated:YES];
//                }else
//                {
//                    [self.navigationController pushViewController:[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil] animated:YES];
//                    return;
//                }
//            }else if (indexPath.row == 1)
//            {
//                if ([JMUserInfo sharedUserInfo].isLogined) {
//                    [self networkGetMyServiceDetail];
//                }
//                else
//                {
//                    [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
//                    return;
//                }
//            }else if (indexPath.row== 2)
//            {
//                if ([JMUserInfo sharedUserInfo].isLogined) {
//                    MyMessageListViewController * myMessageListViewController = [[MyMessageListViewController alloc]init];
//                    [self.navigationController pushViewController:myMessageListViewController animated:YES];
//                }else
//                {
//                    NotifyListViewController * notifyListViewController = [[NotifyListViewController alloc]init];
//                    [self.navigationController pushViewController:notifyListViewController animated:YES];
//                }
//            }
//        } else {
//            if (indexPath.row == 0) {
//                if ([JMUserInfo sharedUserInfo].isLogined) {
//                    [self networkGetMyServiceDetail];
//                }
//                else
//                {
//                    [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
//                    return;
//                }
//            }else if (indexPath.row == 1)
//            {
//                if ([JMUserInfo sharedUserInfo].isLogined) {
//                    MyMessageListViewController * myMessageListViewController = [[MyMessageListViewController alloc]init];
//                    [self.navigationController pushViewController:myMessageListViewController animated:YES];
//                }else
//                {
//                    NotifyListViewController * notifyListViewController = [[NotifyListViewController alloc]init];
//                    [self.navigationController pushViewController:notifyListViewController animated:YES];
//                }
//                
//            }
//        }
//    }else if (indexPath.section == 1)
//    {
//        if (indexPath.row == 0) {
//            if ([JMUserInfo sharedUserInfo].isLogined) {
//                HomeCell *cell = (HomeCell *)[tableView cellForRowAtIndexPath:indexPath];
//                ListGroupViewController *listGroupViewController = [[ListGroupViewController alloc] initWithNibName:@"ListGroupViewController" bundle:nil];
//                listGroupViewController.style = ListGroupViewControllerStyleNormal;
//                if (cell.littleTipIcon.hidden == NO) {
//                    listGroupViewController.isFirstOpen = YES;
//                } else {
//                    listGroupViewController.isFirstOpen = NO;
//                }
//                [self.navigationController pushViewController:listGroupViewController animated:YES];
//            } else {
//                [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
//            }
//        } else if (indexPath.row == 1) {
//            if ([JMUserInfo sharedUserInfo].isLogined) {
//                [self networkGetStatistics];
//            }
//            else
//            {
//                [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
//                return;
//            }
//        }
//    }else if (indexPath.section == 2)
//    {
//        [self.navigationController pushViewController:[[SettingViewController alloc]init] animated:YES];
//    }
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    //    if (section == 0) {
//    //        return 20;
//    //    }else
//    //    {
//    //        return 0;
//    //    }
//    return 10;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}

@end
