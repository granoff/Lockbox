//
//  Lockbox.m
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import "Lockbox.h"
#import <Security/Security.h>

#define kDelimeter @"-|-"

#if __has_feature(objc_arc)
#define ID __bridge id
#else
#define ID id
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
    
    [dict setObject: (ID) kSecClassGenericPassword  forKey: (ID) kSecClass];

    return dict;
}

+(NSMutableDictionary *)_query
{
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    
    [query setObject: (ID) kSecClassGenericPassword forKey: (ID) kSecClass];
    [query setObject: (ID) kCFBooleanTrue           forKey: (ID) kSecReturnData];

    return query;
}

// Prefix a bare key like "MySecureKey" with the bundle id, so the actual key stored
// is unique to this app, e.g. "com.mycompany.myapp.MySecretKey"
+(NSString *)_hierarchicalKey:(NSString *)key
{
    return [_bundleId stringByAppendingFormat:@".%@", key];
}

+(BOOL)setObject:(NSString *)obj forKey:(NSString *)key
{
    OSStatus status;
    
    NSString *hierKey = [self _hierarchicalKey:key];

    // If the object is nil, delete the item
    if (!obj) {
        NSMutableDictionary *query = [self _query];
        [query setObject:hierKey forKey:(ID)kSecAttrService];
#if __has_feature(objc_arc)
        status = SecItemDelete((__bridge CFDictionaryRef)query);
#else
        status = SecItemDelete((CFDictionaryRef)query);
#endif
        return (status == errSecSuccess);
    }
    
    NSMutableDictionary *dict = [self _service];
    [dict setObject: hierKey forKey: (ID) kSecAttrService];
    [dict setObject: [obj dataUsingEncoding:NSUTF8StringEncoding] forKey: (ID) kSecValueData];
    
#if __has_feature(objc_arc)
    status = SecItemAdd ((__bridge CFDictionaryRef) dict, NULL);
#else
    status = SecItemAdd ((CFDictionaryRef) dict, NULL);
#endif
    if (status == errSecDuplicateItem) {
        NSMutableDictionary *query = [self _query];
        [query setObject:hierKey forKey:(ID)kSecAttrService];
#if __has_feature(objc_arc)
        status = SecItemDelete((__bridge CFDictionaryRef)query);
#else
        status = SecItemDelete((CFDictionaryRef) query);
#endif
        if (status == errSecSuccess)
#if __has_feature(objc_arc)
            status = SecItemAdd((__bridge CFDictionaryRef) dict, NULL);        
#else
            status = SecItemAdd((CFDictionaryRef) dict, NULL);
#endif
    }
    if (status != errSecSuccess)
        NSLog(@"SecItemAdd failed for key %@: %ld", hierKey, status);
    
    return (status == errSecSuccess);
}

+(NSString *)objectForKey:(NSString *)key
{
    NSString *hierKey = [self _hierarchicalKey:key];

    NSMutableDictionary *query = [self _query];
    [query setObject:hierKey forKey: (ID)kSecAttrService];

    CFDataRef data = nil;
    OSStatus status =
#if __has_feature(objc_arc)
        SecItemCopyMatching ( (__bridge CFDictionaryRef) query, (CFTypeRef *) &data );
#else
        SecItemCopyMatching((CFDictionaryRef) query, (CFTypeRef *)&data);
#endif
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
    return [self setObject:value forKey:key];
}

+(NSString *)stringForKey:(NSString *)key
{
    return [self objectForKey:key];
}

+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key
{
    NSString *components = [value componentsJoinedByString:kDelimeter];
    return [self setObject:components forKey:key];
}

+(NSArray *)arrayForKey:(NSString *)key
{
    NSArray *array = nil;
    NSString *components = [self objectForKey:key];
    if (components)
        array = [NSArray arrayWithArray:[components componentsSeparatedByString:kDelimeter]];
    
    return array;
}

+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key
{
    return [self setArray:[value allObjects] forKey:key];
}

+(NSSet *)setForKey:(NSString *)key
{
    NSSet *set = nil;
    NSArray *array = [self arrayForKey:key];
    if (array)
        set = [NSSet setWithArray:array];
    
    return set;
}

@end
