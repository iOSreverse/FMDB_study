//
//  DWArchiveBaseModel.m
//  FMDB_study
//
//  Created by wdw on 2020/5/24.
//  Copyright © 2020 wdw. All rights reserved.
//

#import "DWArchiveBaseModel.h"
#import <objc/runtime.h>

@implementation DWArchiveBaseModel

- (void)encodeWithCoder:(NSCoder *)coder
{
    NSArray *names = [[self class] getPropertyNames];
    for (NSString *name in names) {
        id value = [self valueForKey:name];
        [coder encodeObject:value forKey:name];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        NSArray *names = [[self class] getPropertyNames];
        for (NSString *name in names) {
            id value = [coder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id obj = [[[self class] alloc] init];
    NSArray *names = [[self class] getPropertyNames];
    for (NSString *name in names) {
        id value = [self valueForKey:name];
        [obj setValue:value forKey:name];
    }
    return obj;
}

+ (NSArray *)getPropertyNames {
    //Property count
    unsigned int count;
    //Get property list
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    //get names
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        //objc_property_t
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        if (name.length) {
            [array addObject:name];
        }
    }
    free(properties);
    return array;
}

@end
