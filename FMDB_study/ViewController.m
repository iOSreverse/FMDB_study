//
//  ViewController.m
//  FMDB_study
//
//  Created by wdw on 2020/5/24.
//  Copyright © 2020 wdw. All rights reserved.
//

#import "ViewController.h"
#import <FMDB/FMDB.h>
#import "Student.h"
#import "DWStorageManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self insert];
}

#pragma mark - 数据库操作
//存
- (void)insert {
    Student *student = [[Student alloc] init];
    student.name = [NSString stringWithFormat:@"mr-%d", arc4random_uniform(100)];
    student.age = arc4random_uniform(50);
    student.sex = arc4random_uniform(100) % 2 == 0 ? @"男" : @"女";
    student.height = arc4random_uniform(200);
    student.number = arc4random_uniform(500);
    student.startTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];

    BOOL result = [[DWStorageManager sharedManager] saveStudentModel:student];
    if (result) {
        NSLog(@"插入数据成功");
    } else {
        NSLog(@"插入数据失败");
    }
}

@end
