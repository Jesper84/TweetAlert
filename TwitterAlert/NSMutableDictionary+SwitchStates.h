//
//  NSMutableDictionary+SwitchStates.h
//  TwitterAlert
//
//  Created by Jesper Nielsen on 17/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SwitchStates)
- (BOOL) boolForKey:(NSString *)key;
- (void) setBool:(BOOL)boolValue forKey:(NSString *)key;
@end
