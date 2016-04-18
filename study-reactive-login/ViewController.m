//
//  ViewController.m
//  study-reactive-login
//
//  Created by 熊 春雷 on 16/4/15.
//  Copyright © 2016年 pandaxcl. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField_account;
@property (weak, nonatomic) IBOutlet UITextField *textField_password;
@property (weak, nonatomic) IBOutlet UIButton *button_login;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    RACSignal*signalAccount = [self.textField_account.rac_textSignal map:^id(NSString* value) {
        return @([value length] >= 3);
    }];
    RACSignal*signalPassword = [self.textField_password.rac_textSignal map:^id(NSString* value) {
        return @([value length] >= 6);
    }];
    RACSignal*signalLoginEnabled = [[signalAccount combineLatestWith:signalPassword] map:^id(RACTuple* value) {
        RACTupleUnpack(NSNumber* accountIsValid, NSNumber* passwordIsValid) = value;
        return @([accountIsValid boolValue] && [passwordIsValid boolValue]);
    }];
//    typeof(self) __weak wself = self;
//    [signalLoginEnabled subscribeNext:^(id x) {
//        typeof(self) sself = wself;
//        sself.button_login.enabled = [x boolValue];
//    }];
    
    RAC(self.button_login, enabled) = signalLoginEnabled;
    RAC(self.button_login, backgroundColor) = [signalLoginEnabled map:^id(NSNumber* value) {
        if ([value boolValue])
            return [UIColor blueColor];
        return [UIColor redColor];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
