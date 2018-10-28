//
//  DemoApiManagerViewController.m
//  XKNetworking
//
//  Created by 浪漫恋星空 on 2018/10/26.
//  Copyright © 2018 浪漫恋星空. All rights reserved.
//

#import "DemoApiManagerViewController.h"
#import "DemoApiManager/DemoApiManager.h"

@interface DemoApiManagerViewController ()<XKAPIManagerCallBackDelegate>

@property (nonatomic, strong) UIButton *startRequestButton;
@property (nonatomic, strong) DemoApiManager *demoApiManager;

@end

@implementation DemoApiManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.startRequestButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.startRequestButton sizeToFit];
    self.startRequestButton.center = self.view.center;
}

- (void)managerCallAPIDidSuccess:(XKAPIBaseManager * _Nonnull)manager {
    NSLog(@"%@", [manager fetchDataWithReformer:nil]);
}

- (void)managerCallAPIDidFailed:(XKAPIBaseManager * _Nonnull)manager {
    NSLog(@"%@", [manager fetchDataWithReformer:nil]);
}

- (void)didTappedStartButton:(UIButton *)startButton {
    [self.demoApiManager loadData];
}

- (DemoApiManager *)demoApiManager {
    if (!_demoApiManager) {
        _demoApiManager = [[DemoApiManager alloc] init];
        _demoApiManager.delegate = self;
    }
    return _demoApiManager;
}

- (UIButton *)startRequestButton {
    if (_startRequestButton == nil) {
        _startRequestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startRequestButton setTitle:@"send request" forState:UIControlStateNormal];
        [_startRequestButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_startRequestButton addTarget:self action:@selector(didTappedStartButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startRequestButton;
}

@end
