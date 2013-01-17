//
//  NSMutableDictionary+SwitchStates.m
//  TwitterAlert
//
//  Created by Jesper Nielsen on 17/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import "NSMutableDictionary+SwitchStates.h"

@implementation NSMutableDictionary (SwitchStates)
- (BOOL) boolForKey:(NSString *)aKey{
    if (![self objectForKey:aKey]) {
        return NO;
    }
    
    id obj = [self objectForKey:aKey];
    if ([obj respondsToSelector:@selector(boolValue)]) {
        return [(NSNumber *)obj boolValue];
    }
    return NO;
}

- (void) setBool:(BOOL)boolValue forKey:(NSString *)aKey{
    [self setValue:[NSNumber numberWithBool:boolValue] forKeyPath:aKey];
}

@end
