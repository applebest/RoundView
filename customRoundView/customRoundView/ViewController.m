//
//  ViewController.m
//  customRoundView
//
//  Created by xindongyuan on 2016/12/9.
//  Copyright © 2016年 clt. All rights reserved.
//

#import "ViewController.h"
#import "CLTRoundView.h"


@interface ViewController ()

@property (nonatomic,strong) CLTRoundView *roudView;


@end

@implementation ViewController



-(CLTRoundView *)roudView
{
    if (!_roudView) {
        
        _roudView = [[CLTRoundView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300)];
    }
    
    return _roudView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.roudView];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     // 传入百分比的时候，传入 小数，  0.1 - 1 范围内  <==>  1 - 100
    self.roudView.percent = arc4random_uniform(100 + 1) * 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
