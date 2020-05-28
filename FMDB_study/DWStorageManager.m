//
//  DWStorageManager.m
//  FMDB_study
//
//  Created by wdw on 2020/5/24.
//  Copyright © 2020 wdw. All rights reserved.
//

#import "DWStorageManager.h"
#import <FMDB/FMDB.h>
#import "Student.h"

static DWStorageManager *_instance = nil;

//Table SQL
static NSString *const kCreateStudentModelTableSQL = @"CREATE TABLE IF NOT EXISTS StudentModelTable(ObjectData BLOB NOT NULL,CreateDate TEXT NOT NULL);";

//table Name
static NSString *const kStudentModelTable = @"StudentModelTable";

//Column Name
static NSString *const kObjectDataColumn = @"ObjectData";
static NSString *const kCreateDateColumn = @"CreateDate";

@interface DWStorageManager ()

@property (nonatomic, strong)  FMDatabaseQueue *dbQueue;

@end

@implementation DWStorageManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DWStorageManager alloc] init];
        [_instance initial];
    });
    return _instance;
}

#pragma mark - Student Model
//插入
- (BOOL)saveStudentModel:(Student *)model {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data.length == 0) {
        NSLog(@"DWStorageManager save student fail,because model's data is null");
        return NO;
    }

    __block NSArray *arguments = @[data, model.startTime];
    __block BOOL ret = 0;

    [_dbQueue inDatabase:^(FMDatabase *_Nonnull db) {
        NSError *error;
        ret = [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(%@,%@) VALUES (?,?);", kStudentModelTable, kObjectDataColumn, kCreateDateColumn] values:arguments error:&error];
        if (!ret) {
            NSLog(@"DWStorageManager save crash model fail,Error = %@", error.description);
        } else {
            NSLog(@"DWStorageManager save crash success!");
        }
    }];

    return ret;
}

//读取
- (NSArray<Student *> *)getAllStudentModels
{
    __block NSMutableArray *modelArray = [[NSMutableArray alloc] init];

    [_dbQueue inDatabase:^(FMDatabase *_Nonnull db) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", kStudentModelTable]];

        while ([set next]) {
            NSData *objectData = [set dataForColumn:kObjectDataColumn];
            Student *model = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
            if (model) {
                [modelArray insertObject:model atIndex:0];
            }
        }
    }];

    return modelArray.copy;
}

//删除
- (BOOL)removeStudentModels:(NSArray<Student *> *)models
{
    BOOL ret = YES;

    for (Student *model in models) {
        ret = ret && [self _removeMotionModel:model];
    }

    return ret;
}

//内部真正实现删除的方法操作
- (BOOL)_removeMotionModel:(Student *)model {
    __block BOOL ret = NO;
    [_dbQueue inDatabase:^(FMDatabase *_Nonnull db) {
//        CreateDate
        NSError *error;
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", kStudentModelTable, kCreateDateColumn];
        ret = [db executeUpdate:sql values:@[model.startTime] error:&error];
        if (!ret) {
            NSLog(@"Delete Student model fail,error = %@", error);
        }
    }];
    return ret;
}

#pragma mark - Primary
- (void)initial {
    __unused BOOL result = [self initDatabase];//创建数据库
    NSAssert(result, @"init Database fail");
}

- (BOOL)initDatabase {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    doc = [doc stringByAppendingPathComponent:@"DWSqlTool"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:doc]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:doc withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"DWStorageManager create folder fail, error = %@", error.description);
        }
        NSAssert(!error, error.description);
    }

    NSString *filePath = [doc stringByAppendingPathComponent:@"DWSqlTool.db"];

    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];

    __block BOOL ret1 = NO;
    [_dbQueue inDatabase:^(FMDatabase *_Nonnull db) {
        ret1 = [db executeUpdate:kCreateStudentModelTableSQL];
        if (!ret1) {
            NSLog(@"DWStorageManager create StudentModelTable fail");
        }
    }];

    return YES;
}

@end
