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

@interface ViewController ()

/**
 students
 */
@property (nonatomic, strong) NSMutableArray *students;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self creatData];
}

//建表

//打开数据库
- (void)creatData {
    //数据库文件路径
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = pathArr.lastObject;
    NSString *fileName = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"fileName--%@", fileName);

    //创建数据库对象
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    //打开数据库
    if ([db open]) {
        NSLog(@"open database success");

        //创建表
        NSString *creatTableSqlString = @"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL)";
        [db executeUpdate:creatTableSqlString];

        //写入数据 - 不确定参数用?来占位
//        NSString *sql = @"insert into t_student (name,age) values (?,?)";
//
//        for (int i = 0; i < 10; i++) {
//            NSString *name = [NSString stringWithFormat:@"小明-%d", arc4random()];
//            NSNumber *age = [NSNumber numberWithInt:arc4random_uniform(100)];
//            [db executeUpdate:sql, name, age];
//        }
        
        //删除数据
//        NSString *sql = @"delete from t_student where id = ?";
//        [db executeUpdate:sql,[NSNumber numberWithInt:1]];
        
        //更改数据
//        NSString *sql = @"update t_student set name = '调皮的悟空' where id = ?";
//        [db executeUpdate:sql,[NSNumber numberWithInt:2]];
        
        //使用execteUpdateWithFormat: 不确定的参数用%@,%d等来占位
//        NSString *sql = @"insert into t_student (name,age) values (%@,%d)";
//        NSString *name = [NSString stringWithFormat:@"红孩儿-%d",arc4random()];
//        [db executeUpdateWithFormat:sql,name,arc4random_uniform(100)];
        
        //查询
        NSString *sql = @"select id,name,age FROM t_student";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            int id = [rs intForColumnIndex:0];
            NSString *name  = [rs stringForColumnIndex:1];
            int age = [rs intForColumnIndex:2];
            Student *student = [[Student alloc] init];
            student.stuID = id;
            student.name = name;
            student.age = age;
            [self.students addObject:student];
        }
    } else {
        NSLog(@"fail to open database");
    }
}

- (NSMutableArray *)students {
    if (_students == nil) {
        _students = [NSMutableArray new];
    }
    return _students;
}

@end
