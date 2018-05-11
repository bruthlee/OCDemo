//
//  KVCModel.m
//  OCDemo
//
//  Created by hollywater on 2018/5/11.
//  Copyright © 2018年 greencici. All rights reserved.
//

#import "KVCModel.h"

@interface KVCModel() {
//    NSString *_name;
    NSString *_isName;
//    NSString *name;
}
@end

@implementation KVCModel

static BOOL directly = YES;
+ (BOOL)accessInstanceVariablesDirectly {
    return directly;
}

- (void)setShouldInstanceVariablesDirectly:(BOOL)shouldInstanceVariablesDirectly {
    _shouldInstanceVariablesDirectly = shouldInstanceVariablesDirectly;
    directly = shouldInstanceVariablesDirectly;
}

- (id)valueForUndefinedKey:(NSString *)key {
    if (_canSetValue) {
        return [self valueForKey:key];
    }
    NSLog(@"[异常]The value for key:%@ is not exist.", key);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"[异常]The value(%@) for key(%@) is not existed.",value,key);
    if (_canSetValue) {
        [self setValue:value forKey:key];
    }
}

- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKey:(NSString *)inKey error:(out NSError * _Nullable __autoreleasing *)outError {
    return YES;
}

- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError * _Nullable __autoreleasing *)outError {
    return YES;
}

@end
