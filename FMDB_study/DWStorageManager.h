//
//  DWStorageManager.h
//  FMDB_study
//
//  Created by wdw on 2020/5/24.
//  Copyright © 2020 wdw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Student;

NS_ASSUME_NONNULL_BEGIN

//数据库存储
@interface DWStorageManager : NSObject

+(instancetype)sharedManager;

#pragma mark - motion Model Actions
//存
-(BOOL)saveStudentModel:(Student *)model;
//取
-(NSArray <Student *>*)getAllStudentModels;
//删
-(BOOL)removeStudentModels:(NSArray <Student *> *)models;

@end

NS_ASSUME_NONNULL_END
