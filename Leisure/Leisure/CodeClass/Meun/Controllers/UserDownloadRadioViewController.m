//
//  UserDownloadRadioViewController.m
//  Leisure
//
//  Created by 沈强 on 16/4/13.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "UserDownloadRadioViewController.h"
#import "RadioDetailListDB.h"

@interface UserDownloadRadioViewController ()

/** 收藏列表 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 收藏数据 */
@property (nonatomic, strong) NSArray *dataArray;

@end

static NSString * const UserDownloadCellID = @"download";

@implementation UserDownloadRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 添加自定义导航栏
    [self addCustomNavigationBar];
    
    // 查询数据
    [self findDB];
}

/**
 *  查询数据
 */
- (void)findDB {
    RadioDetailListDB *db = [[RadioDetailListDB alloc] init];
    self.dataArray = [db getAllRadios];
    [self.tableView reloadData];
}

#pragma mark -自定义导航栏，点击方法
/**
 *  添加自定义导航栏
 */
- (void)addCustomNavigationBar {
    self.navigationController.navigationBar.hidden = YES;
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [bar.menuButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    bar.titleLabel.text = @"收藏";
    
    [self.view addSubview:bar];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -<UITableViewDelegate, UITableViewDataSource>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserDownloadCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserDownloadCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RadioDetailListModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
