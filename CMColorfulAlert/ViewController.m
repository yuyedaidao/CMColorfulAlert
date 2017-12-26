//
//  ViewController.m
//  CMColorfulAlert
//
//  Created by Wang on 2017/12/25.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "ViewController.h"
#import "CMColorfulAlert.h"

@interface ViewController ()
@property (strong, nonatomic) CMColorfulAlert *alert;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CMColorfulAlert *alert = [CMColorfulAlert createWithTitleIcon:[UIImage imageNamed:@"kaoqin_daka_start_b"] title:@"正经标题" contentImage:[UIImage imageNamed:@"kaoqin_congratulaions"] contentLabels:@[@"我是一个粉刷匠,粉刷本领强,哟吼吼吼吼", @"我要把那新房子刷得更难看"] buttonTitles:@[@"点一个试试", @"再点一个试试"] buttonClickBlock:nil];
    [alert showInView:self.view];
    self.alert = alert;

}
- (IBAction)tapAction:(id)sender {
    if (!self.alert.superview) {
        [self.alert show];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
