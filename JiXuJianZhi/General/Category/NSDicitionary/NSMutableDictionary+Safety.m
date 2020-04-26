//
//  NSMutableDictionary+Safety.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "NSMutableDictionary+Safety.h"

@implementation NSMutableDictionary (Safety)

- (void)SafetySetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (!anObject)
    {
        return;
    }
    
    if ([anObject isKindOfClass:[NSString class]])
    {
        if ([anObject length] > 0)
        {
            [self setObject:anObject forKey:aKey];
        }
    }
    else if ([anObject isKindOfClass:[NSArray class]])
    {
        if ([anObject count] > 0)
        {
            [self setObject:anObject forKey:aKey];
        }
    }
    else if ([anObject isKindOfClass:[NSDictionary class]])
    {
        if ([anObject count] > 0)
        {
            [self setObject:anObject forKey:aKey];
        }
    }
    else
    {
        [self setObject:anObject forKey:aKey];
    }
}

@end
