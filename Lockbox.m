//
//  Lockbox.m
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import "Lockbox.h"
#import <Security/Security.h>

#define kDelimeter @"-|-"

@implementation Lockbox

+(NSMutableDictionary *)_service
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject: (id) kSecClassGenericPassword  forKey: (id) kSecClass];

    return dict;
}

+(NSMutableDictionary *)_query
{
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    
    [query setObject: (id) kSecClassGenericPassword forKey: (id) kSecClass];
    [query setObject: (id) kCFBooleanTrue           forKey: (id) kSecReturnData];

    return query;
}

+(BOOL)setObject:(NSString *)obj forKey:(NSString *)key
{
    NSMutableDictionary *dict = [Lockbox _service];
    [dict setObject: key                            forKey: (id) kSecAttrService];
    [dict setObject: [obj dataUsingEncoding:NSUTF8StringEncoding] forKey: (id) kSecValueData];
    
    // Should really check the status here, and the method should return BOOL
    OSStatus status = SecItemAdd ((CFDictionaryRef) dict, NULL);
    if (status == errSecDuplicateItem) {
        NSMutableDictionary *query = [Lockbox _query];
        [query setObject:key forKey:(id)kSecAttrService];
        status = SecItemDelete((CFDictionaryRef)query);
        if (status == errSecSuccess)
            status = SecItemAdd((CFDictionaryRef) dict, NULL);        
    }
    if (status != errSecSuccess)
        NSLog(@"SecItemAdd failed: %ld", status);
    
    return (status == errSecSuccess);
}

+(NSString *)objectForKey:(NSString *)key
{
    NSMutableDictionary *query = [Lockbox _query];
    [query setObject:key forKey: (id)kSecAttrService];

    NSData *data = nil;
    OSStatus status = SecItemCopyMatching ( (CFDictionaryRef) query, (CFTypeRef*) &data );
    if (status != errSecSuccess)
        NSLog(@"SecItemCopyMatching failed: %ld", status);
    
    if (!data)
        return nil;

    NSString *s = [[[NSString alloc] 
                    initWithData: data 
                    encoding: NSUTF8StringEncoding] autorelease];

    return s;    
}

+(BOOL)setString:(NSString *)value forKey:(NSString *)key
{
    return [Lockbox setObject:value forKey:key];
}

+(NSString *)stringForKey:(NSString *)key
{
    return [Lockbox objectForKey:key];
}

+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key
{
    NSString *components = [value componentsJoinedByString:kDelimeter];
    return [Lockbox setObject:components forKey:key];
}

+(NSArray *)arrayForKey:(NSString *)key
{
    NSArray *array = nil;
    NSString *components = [Lockbox objectForKey:key];
    if (components)
        array = [NSArray arrayWithArray:[components componentsSeparatedByString:kDelimeter]];
    
    return array;
}

+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key
{
    return [Lockbox setArray:[value allObjects] forKey:key];    
}

+(NSSet *)setForKey:(NSString *)key
{
    NSSet *set = nil;
    NSArray *array = [Lockbox arrayForKey:key];
    if (array)
        set = [NSSet setWithArray:array];
    
    return set;
}

@end
