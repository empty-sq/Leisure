//
//  MeunViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "MeunViewController.h"
#import "AppDelegate.h"
#import "DrawerViewController.h"
#import "ReadViewController.h"
#import "RadioViewController.h"
#import "TopicViewController.h"
#import "ProductViewController.h"

@interface MeunViewController ()
{
    /** 菜单列表数据源 */
    NSMutableArray *list;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MeunViewController

static NSString * const CustomCellID = @"CellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    list = [[NSMutableArray alloc] initWithCapacity:0];
    [list addObject:@"阅读"];
    [list addObject:@"电台"];
    [list addObject:@"话题"];
    [list addObject:@"良品"];
}

/** 改变行高 */
- (CGFloat)tableVIew:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

/** 返回有多少个tableView */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/** 返回tableView中有多少数据 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}

/** 组装每一条数据 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellID];
    }
    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    return cell;
}

/** 选中Cell响应事件 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 获取抽屉对象
    DrawerViewController *menuController = (DrawerViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawerViewController;
    
    if (indexPath.row == 0) { // 设置阅读为抽屉的根视图
        [self setRootViewController:[[ReadViewController alloc] init] menuController:menuController];
    } else if (indexPath.row == 1) { // 设置电台为抽屉的根视图
        [self setRootViewController:[[RadioViewController alloc] init] menuController:menuController];
    } else if (indexPath.row == 2) { // 设置话题为抽屉的根视图
        [self setRootViewController:[[TopicViewController alloc] init] menuController:menuController];
    } else if (indexPath.row == 3) { // 设置良品为抽屉的根视图
        [self setRootViewController:[[ProductViewController alloc] init] menuController:menuController];
    }
}

- (void)setRootViewController:(BaseViewController *)viewController menuController:(DrawerViewController *)menuController {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    // 点击选中单元格时，先删除原来视图，再添加新视图
    [navigationController.view removeFromSuperview];
    // 隐藏系统自带的导航栏
    navigationController.navigationBarHidden = YES;
    [menuController setRootController:navigationController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
