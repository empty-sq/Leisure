//
//  LoginRegisterViewController.m
//  Leisure
//
//  Created by 沈强 on 16/4/8.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import "UserInfoManager.h"
#import "CustomTextField.h"

@interface LoginRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;
@property (weak, nonatomic) IBOutlet CustomTextField *loginEmailField;
@property (weak, nonatomic) IBOutlet CustomTextField *loginPasswordField;
@property (weak, nonatomic) IBOutlet CustomTextField *registerEmailField;
@property (weak, nonatomic) IBOutlet CustomTextField *registerPasswordField;
@property (weak, nonatomic) IBOutlet CustomTextField *nameField;

@end

@implementation LoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)loginAndRegister:(UIButton *)sender {
    // 退出键盘
    [self.view endEditing:YES];
    
    if (!self.left.constant) { // 显示注册界面
        self.left.constant = - self.view.width;
        sender.selected = YES;
        //        [sender setTitle:@"已有账号?" forState:UIControlStateNormal];
    } else { // 显示登录界面
        self.left.constant = 0;
        sender.selected = NO;
        //        [sender setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:.25 animations:^(void){
        // 如果，有需要刷新的标记，立即调用layoutSubviews进行布局（如果没有标记，不会调用layoutSubviews）
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)login:(UIButton *)sender {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"email"] = _loginEmailField.text;
    parDic[@"passwd"] = _loginPasswordField.text;
    [NetWorkRequestManager requestWithType:POST urlString:@"http://api2.pianke.me/user/login" parDic:parDic finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        NSNumber *result = dataDic[@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            //登录失败
            if ([result intValue] == 0) {
                NSString *message = dataDic[@"data"][@"msg"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录失败!" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            } else { //登录成功
                //保存用户的auth
                [UserInfoManager conserveUserAuth:dataDic[@"data"][@"auth"]];
                //保存用户名
                [UserInfoManager conserveUserName:dataDic[@"data"][@"uname"]];
                //保存用户id
                [UserInfoManager conserveUserID:dataDic[@"data"][@"uid"]];
                
                NSDictionary *dic = @{@"username" : dataDic[@"data"][@"uname"]};
                NSNotification *notification = [NSNotification notificationWithName:@"username" object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                NSString *message = [NSString stringWithFormat:@"欢迎回来!\n%@", dataDic[@"data"][@"uname"]];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录成功!" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                
                
            }
        });
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录失败!" message:@"网络出了点小问题!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (IBAction)registered:(UIButton *)sender {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"email"] = _registerEmailField.text;
    parDic[@"gender"] = @"男";
    parDic[@"passwd"] = _registerPasswordField.text;
    parDic[@"uname"] = _nameField.text;
    
    [NetWorkRequestManager requestWithType:POST urlString:@"http://api2.pianke.me/user/reg" parDic:parDic finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSNumber *result = dataDic[@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            // 注册失败
            if ([result intValue] == 0) {
                NSString *message = dataDic[@"data"][@"msg"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册失败!" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            } else { //注册成功
                //保存用户的auth
                [UserInfoManager conserveUserAuth:dataDic[@"data"][@"auth"]];
                //保存用户名
                [UserInfoManager conserveUserName:dataDic[@"data"][@"uname"]];
                //保存用户id
                [UserInfoManager conserveUserID:dataDic[@"data"][@"uid"]];
                //保存用户icon
                [UserInfoManager conserveUserIcon:dataDic[@"data"][@"icon"]];
                NSString *message = [NSString stringWithFormat:@"注册成功!\n%@", dataDic[@"data"][@"uname"]];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录成功!" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录失败!" message:@"网络出了点小问题!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - <UITextFieldDelegate>
/**
 * 当点击键盘右下角的return key时,就会调用这个方法
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.loginEmailField) {
        [self.loginPasswordField becomeFirstResponder];
    } else if (textField == self.loginPasswordField) {
        [self.view endEditing:YES];
    }
    
    if (textField == self.registerEmailField) {
        [self.registerPasswordField becomeFirstResponder];
    } else if (textField == self.registerPasswordField) {
        [self.nameField becomeFirstResponder];
    } else if (textField == self.nameField) {
        [self.view endEditing:YES];
    }
    
    return YES;
}

@end
