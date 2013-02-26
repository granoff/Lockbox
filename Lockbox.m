//
//  Lockbox.m
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import "Lockbox.h"
#import <Security/Security.h>

#define kDelimiter @"-|-"
#define DEFAULT_ACCESSIBILITY kSecAttrAccessibleWhenUnlocked

#if __has_feature(objc_arc)
#define LOCKBOX_ID __bridge id
#define LOCKBOX_DICTREF __bridge CFDictionaryRef
#else
#define LOCKBOX_ID id
#define LOCKBOX_DICTREF CFDictionaryRef
#endif

static NSString *_bundleId = nil;

@implementation Lockbox

+(void)initialize
{
    _bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
}

+(NSMutableDictionary *)_service
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject: (LOCKBOX_ID) kSecClassGenericPassword  forKey: (LOCKBOX_ID) kSecClass];

    return dict;
}

+(NSMutableDictionary *)_query
{
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    
    [query setObject: (LOCKBOX_ID) kSecClassGenericPassword forKey: (LOCKBOX_ID) kSecClass];
    [query setObject: (LOCKBOX_ID) kCFBooleanTrue           forKey: (LOCKBOX_ID) kSecReturnData];

    return query;
}

// Prefix a bare key like "MySecureKey" with the bundle id, so the actual key stored
// is unique to this app, e.g. "com.mycompany.myapp.MySecretKey"
+(NSString *)_hierarchicalKey:(NSString *)key
{
    return [_bundleId stringByAppendingFormat:@".%@", key];
}

+(BOOL)setObject:(NSString *)obj forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    OSStatus status;
    
    NSString *hierKey = [self _hierarchicalKey:key];

    // If the object is nil, delete the item
    if (!obj) {
        NSMutableDictionary *query = [self _query];
        [query setObject:hierKey forKey:(LOCKBOX_ID)kSecAttrService];
        status = SecItemDelete((LOCKBOX_DICTREF)query);
        return (status == errSecSuccess);
    }
    
    NSMutableDictionary *dict = [self _service];
    [dict setObject: hierKey forKey: (LOCKBOX_ID) kSecAttrService];
    [dict setObject: (LOCKBOX_ID)(accessibility) forKey: (LOCKBOX_ID) kSecAttrAccessible];
    [dict setObject: [obj dataUsingEncoding:NSUTF8StringEncoding] forKey: (LOCKBOX_ID) kSecValueData];
    
    status = SecItemAdd ((LOCKBOX_DICTREF) dict, NULL);
    if (status == errSecDuplicateItem) {
        NSMutableDictionary *query = [self _query];
        [query setObject:hierKey forKey:(LOCKBOX_ID)kSecAttrService];
        status = SecItemDelete((LOCKBOX_DICTREF)query);
        if (status == errSecSuccess)
            status = SecItemAdd((LOCKBOX_DICTREF) dict, NULL);
    }
    if (status != errSecSuccess)
        NSLog(@"SecItemAdd failed for key %@: %ld", hierKey, status);
    
    return (status == errSecSuccess);
}

+(NSString *)objectForKey:(NSString *)key
{
    NSString *hierKey = [self _hierarchicalKey:key];

    NSMutableDictionary *query = [self _query];
    [query setObject:hierKey forKey: (LOCKBOX_ID)kSecAttrService];

    CFDataRef data = nil;
    OSStatus status =
    SecItemCopyMatching ( (LOCKBOX_DICTREF) query, (CFTypeRef *) &data );
    if (status != errSecSuccess)
        NSLog(@"SecItemCopyMatching failed for key %@: %ld", hierKey, status);
    
    if (!data)
        return nil;

    NSString *s = [[NSString alloc] 
                    initWithData: 
#if __has_feature(objc_arc)
                   (__bridge_transfer NSData *)data 
#else
                   (NSData *)data
#endif
                    encoding: NSUTF8StringEncoding];

#if !__has_feature(objc_arc)
    [s autorelease];
    CFRelease(data);
#endif
    
    return s;    
}

+(BOOL)setString:(NSString *)value forKey:(NSString *)key
{
    return [self setString:value forKey:key accessibility:DEFAULT_ACCESSIBILITY];
}

+(BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [self setObject:value forKey:key accessibility:accessibility];
}

+(NSString *)stringForKey:(NSString *)key
{
    return [self objectForKey:key];
}

+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key
{
    return [self setArray:value forKey:key accessibility:DEFAULT_ACCESSIBILITY];
}

+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    NSString *components = [value componentsJoinedByString:kDelimiter];
    return [self setObject:components forKey:key accessibility:accessibility];
}

+(NSArray *)arrayForKey:(NSString *)key
{
    NSArray *array = nil;
    NSString *components = [self objectForKey:key];
    if (components)
        array = [NSArray arrayWithArray:[components componentsSeparatedByString:kDelimiter]];
    
    return array;
}

+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key
{
    return [self setSet:value forKey:key accessibility:DEFAULT_ACCESSIBILITY];
}

+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [self setArray:[value allObjects] forKey:key accessibility:accessibility];
}

+(NSSet *)setForKey:(NSString *)key
{
    NSSet *set = nil;
    NSArray *array = [self arrayForKey:key];
    if (array)
        set = [NSSet setWithArray:array];
    
    return set;
}


+(BOOL)setDate:(NSDate *)value forKey:(NSString *)key
{
    return [self setDate:value forKey:key accessibility:DEFAULT_ACCESSIBILITY];
}

+(BOOL)setDate:(NSDate *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    if (!value)
        return [self setObject:nil forKey:key accessibility:accessibility];
    NSNumber *rti = [NSNumber numberWithDouble:[value timeIntervalSinceReferenceDate]];
    return [self setObject:[rti stringValue] forKey:key accessibility:accessibility];
}

+(NSDate *)dateForKey:(NSString *)key
{
    NSString *dateString = [self objectForKey:key];
    if (dateString)
        return [NSDate dateWithTimeIntervalSinceReferenceDate:[dateString doubleValue]];
    return nil;
}

@end
