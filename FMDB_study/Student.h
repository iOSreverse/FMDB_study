//
//  Student.h
//  FMDB_study
//
//  Created by wdw on 2020/5/24.
//  Copyright © 2020 wdw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWArchiveBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

/**
 id
 */
@property (nonatomic, assign) int stuID;
/**
 age
 */
@property (nonatomic, assign) int age;
/**
 height
 */
@property (nonatomic, assign) int height;
/**
 name
 */
@property (nullable, nonatomic, copy) NSString *name;
/**
 number
 */
@property (nonatomic, assign) int number;
/**
 sex
 */
@property (nullable, nonatomic, copy) NSString *sex;
/**
 time
 */
@property (nonatomic, strong) NSString *startTime;

@end

NS_ASSUME_NONNULL_END
