//
//  Lockbox.m
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import "Lockbox.h"
#import <Security/Security.h>

// Define DLog if user hasn't already defined his own implementation
#ifndef DLog
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif
#endif

#define kDelimiter @"-|-"
#define DEFAULT_ACCESSIBILITY kSecAttrAccessibleWhenUnlocked

#define LOCKBOX_ID __bridge id
#define LOCKBOX_DICTREF __bridge CFDictionaryRef

static Lockbox *_lockBox = nil;
static NSString *_defaultKeyPrefix = nil;

@interface Lockbox()
@property (strong, nonatomic, readwrite) NSString *keyPrefix;
@end

@implementation Lockbox

+(void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultKeyPrefix = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
        _lockBox = [[Lockbox alloc] init];
    });
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.keyPrefix = _defaultKeyPrefix;
    }
    return self;
}

-(instancetype)initWithKeyPrefix:(NSString *)keyPrefix
{
    self = [self init];
    if (self) {
        if (keyPrefix)
            self.keyPrefix = keyPrefix;
    }
    return self;
}

-(NSMutableDictionary *)_service
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject: (LOCKBOX_ID) kSecClassGenericPassword  forKey: (LOCKBOX_ID) kSecClass];

    return dict;
}

-(NSMutableDictionary *)_query
{
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    
    [query setObject: (LOCKBOX_ID) kSecClassGenericPassword forKey: (LOCKBOX_ID) kSecClass];
    [query setObject: (LOCKBOX_ID) kCFBooleanTrue           forKey: (LOCKBOX_ID) kSecReturnData];

    return query;
}

// Prefix a bare key like "MySecureKey" with the bundle id, so the actual key stored
// is unique to this app, e.g. "com.mycompany.myapp.MySecretKey"
-(NSString *)_hierarchicalKey:(NSString *)key
{
    return [_keyPrefix stringByAppendingFormat:@".%@", key];
}

-(BOOL)setObject:(NSString *)obj forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    NSString *hierKey = [self _hierarchicalKey:key];

    // If the object is nil, delete the item
    if (!obj) {
        NSMutableDictionary *query = [self _query];
        [query setObject:hierKey forKey:(LOCKBOX_ID)kSecAttrService];
        _lastStatus = SecItemDelete((LOCKBOX_DICTREF)query);
        return (_lastStatus == errSecSuccess);
    }
    
    NSMutableDictionary *dict = [self _service];
    [dict setObject: hierKey forKey: (LOCKBOX_ID) kSecAttrService];
    [dict setObject: (LOCKBOX_ID)(accessibility) forKey: (LOCKBOX_ID) kSecAttrAccessible];
    [dict setObject: [obj dataUsingEncoding:NSUTF8StringEncoding] forKey: (LOCKBOX_ID) kSecValueData];
    
    _lastStatus = SecItemAdd ((LOCKBOX_DICTREF) dict, NULL);
    if (_lastStatus == errSecDuplicateItem) {
        NSMutableDictionary *query = [self _query];
        [query setObject:hierKey forKey:(LOCKBOX_ID)kSecAttrService];
        _lastStatus = SecItemDelete((LOCKBOX_DICTREF)query);
        if (_lastStatus == errSecSuccess)
            _lastStatus = SecItemAdd((LOCKBOX_DICTREF) dict, NULL);
    }
    if (_lastStatus != errSecSuccess)
        DLog(@"SecItemAdd failed for key %@: %d", hierKey, (int)_lastStatus);
    
    return (_lastStatus == errSecSuccess);
}

-(NSString *)objectForKey:(NSString *)key
{
    NSString *hierKey = [self _hierarchicalKey:key];

    NSMutableDictionary *query = [self _query];
    [query setObject:hierKey forKey: (LOCKBOX_ID)kSecAttrService];

    CFDataRef data = nil;
    _lastStatus =
    SecItemCopyMatching ( (LOCKBOX_DICTREF) query, (CFTypeRef *) &data );
    if (_lastStatus != errSecSuccess && _lastStatus != errSecItemNotFound)
        DLog(@"SecItemCopyMatching failed for key %@: %d", hierKey, (int)_lastStatus);
    
    if (!data)
        return nil;

    NSString *s = [[NSString alloc] initWithData:(__bridge_transfer NSData *)data encoding: NSUTF8StringEncoding];
    
    return s;
}

-(BOOL)setData:(NSData *)obj forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    NSString *hierKey = [self _hierarchicalKey:key];
    
    // If the object is nil, delete the item
    if (!obj) {
        NSMutableDictionary *query = [self _query];
        [query setObject:hierKey forKey:(LOCKBOX_ID)kSecAttrService];
        _lastStatus = SecItemDelete((LOCKBOX_DICTREF)query);
        return (_lastStatus == errSecSuccess);
    }
    
    NSMutableDictionary *dict = [self _service];
    [dict setObject: hierKey forKey: (LOCKBOX_ID) kSecAttrService];
    [dict setObject: (LOCKBOX_ID)(accessibility) forKey: (LOCKBOX_ID) kSecAttrAccessible];
    [dict setObject: obj forKey: (LOCKBOX_ID) kSecValueData];
    
    _lastStatus = SecItemAdd ((LOCKBOX_DICTREF) dict, NULL);
    if (_lastStatus == errSecDuplicateItem) {
        NSMutableDictionary *query = [self _query];
        [query setObject:hierKey forKey:(LOCKBOX_ID)kSecAttrService];
        _lastStatus = SecItemDelete((LOCKBOX_DICTREF)query);
        if (_lastStatus == errSecSuccess)
            _lastStatus = SecItemAdd((LOCKBOX_DICTREF) dict, NULL);
    }
    if (_lastStatus != errSecSuccess)
        DLog(@"SecItemAdd failed for key %@: %d", hierKey, (int)_lastStatus);
    
    return (_lastStatus == errSecSuccess);
}

-(NSData *)dataForKey:(NSString *)key
{
    NSString *hierKey = [self _hierarchicalKey:key];
    
    NSMutableDictionary *query = [self _query];
    [query setObject:hierKey forKey: (LOCKBOX_ID)kSecAttrService];
    
    CFDataRef data = nil;
    _lastStatus =
    SecItemCopyMatching ( (LOCKBOX_DICTREF) query, (CFTypeRef *) &data );
    if (_lastStatus != errSecSuccess && _lastStatus != errSecItemNotFound)
        DLog(@"SecItemCopyMatching failed for key %@: %d", hierKey, (int)_lastStatus);
    
    if (!data)
        return nil;

    return (__bridge_transfer NSData *)data;
}

-(BOOL)archiveObject:(id<NSSecureCoding>)object forKey:(NSString *)key
{
    return [self archiveObject:object forKey:key accessibility:DEFAULT_ACCESSIBILITY];
}

-(BOOL)archiveObject:(id<NSSecureCoding>)object forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    NSMutableData *data = [NSMutableData new];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    
    return [self setData:data forKey:key accessibility:accessibility];
}

-(id)unarchiveObjectForKey:(NSString *)key
{
    NSData *data = [self dataForKey:key];
    if (!data)
        return nil;

    id object = nil;
    @try {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        object = [unarchiver decodeObjectForKey:key];
    }
    @catch (NSException *exception) {
        DLog(@"failed for key %@: %@", key, exception.description);
    }
    
    return object;
}


-(BOOL)setString:(NSString *)value forKey:(NSString *)key
{
    return [self setString:value forKey:key accessibility:DEFAULT_ACCESSIBILITY];
}

-(BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [self setObject:value forKey:key accessibility:accessibility];
}

-(NSString *)stringForKey:(NSString *)key
{
    return [self objectForKey:key];
}

-(BOOL)setArray:(NSArray *)value forKey:(NSString *)key
{
    return [self setArray:value forKey:key accessibility:DEFAULT_ACCESSIBILITY];
}

-(BOOL)setArray:(NSArray *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    NSString *components = nil;
    if (value != nil && value.count > 0) {
        components = [value componentsJoinedByString:kDelimiter];
    }
    return [self setObject:components forKey:key accessibility:accessibility];
}

-(NSArray *)arrayForKey:(NSString *)key
{
    NSArray *array = nil;
    NSString *components = [self objectForKey:key];
    if (components)
        array = [NSArray arrayWithArray:[components componentsSeparatedByString:kDelimiter]];
    
    return array;
}

-(BOOL)setSet:(NSSet *)value forKey:(NSString *)key
{
    return [self setSet:value forKey:key accessibility:DEFAULT_ACCESSIBILITY];
}

-(BOOL)setSet:(NSSet *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [self setArray:[value allObjects] forKey:key accessibility:accessibility];
}

-(NSSet *)setForKey:(NSString *)key
{
    NSSet *set = nil;
    NSArray *array = [self arrayForKey:key];
    if (array)
        set = [NSSet setWithArray:array];
    
    return set;
}

-(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key
{
    return [self setDictionary:value forKey:key accessibility:DEFAULT_ACCESSIBILITY];
}

-(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    NSMutableArray * keysAndValues = [NSMutableArray arrayWithArray:value.allKeys];
    [keysAndValues addObjectsFromArray:value.allValues];
    
    return [self setArray:keysAndValues forKey:key accessibility:accessibility];
}

-(NSDictionary *)dictionaryForKey:(NSString *)key
{
    NSArray * keysAndValues = [self arrayForKey:key];
    
    if (!keysAndValues || keysAndValues.count == 0)
        return nil;
    
    if ((keysAndValues.count % 2) != 0)
    {
        DLog(@"Dictionary for %@ was not saved properly to keychain", key);
        return nil;
    }
    
    NSUInteger half = keysAndValues.count / 2;
    NSRange keys = NSMakeRange(0, half);
    NSRange values = NSMakeRange(half, half);
    return [NSDictionary dictionaryWithObjects:[keysAndValues subarrayWithRange:values]
                                       forKeys:[keysAndValues subarrayWithRange:keys]];
}

-(BOOL)setDate:(NSDate *)value forKey:(NSString *)key
{
    return [self setDate:value forKey:key accessibility:DEFAULT_ACCESSIBILITY];
}

-(BOOL)setDate:(NSDate *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    if (!value)
        return [self setObject:nil forKey:key accessibility:accessibility];
    NSNumber *rti = [NSNumber numberWithDouble:[value timeIntervalSinceReferenceDate]];
    return [self setObject:[rti stringValue] forKey:key accessibility:accessibility];
}

-(NSDate *)dateForKey:(NSString *)key
{
    NSString *dateString = [self objectForKey:key];
    if (dateString)
        return [NSDate dateWithTimeIntervalSinceReferenceDate:[dateString doubleValue]];
    return nil;
}

#pragma mark - Class methods

+(BOOL)archiveObject:(id<NSSecureCoding>)object forKey:(NSString *)key
{
    return [_lockBox archiveObject:object forKey:key];
}

+(BOOL)archiveObject:(id<NSSecureCoding>)object forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [_lockBox archiveObject:object forKey:key accessibility:accessibility];
}

+(id)unarchiveObjectForKey:(NSString *)key
{
    return [_lockBox unarchiveObjectForKey:key];
}

+(BOOL)setString:(NSString *)value forKey:(NSString *)key
{
    return [_lockBox setString:value forKey:key];
}

+(BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [_lockBox setString:value forKey:key accessibility:accessibility];
}

+(NSString *)stringForKey:(NSString *)key
{
    return [_lockBox stringForKey:key];
}

+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key
{
    return [_lockBox setArray:value forKey:key];
}

+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
{
    return [_lockBox setArray:value forKey:key accessibility:accessibility];
}

+(NSArray *)arrayForKey:(NSString *)key
{
    return [_lockBox arrayForKey:key];
}

+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key
{
    return [_lockBox setSet:value forKey:key];
}

+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [_lockBox setSet:value forKey:key accessibility:accessibility];
}

+(NSSet *)setForKey:(NSString *)key
{
    return [_lockBox setForKey:key];
}

+(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key
{
    return [_lockBox setDictionary:value forKey:key];
}

+(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [_lockBox setDictionary:value forKey:key accessibility:accessibility];
}

+(NSDictionary *)dictionaryForKey:(NSString *)key
{
    return [_lockBox dictionaryForKey:key];
}

+(BOOL)setDate:(NSDate *)value forKey:(NSString *)key
{
    return [_lockBox setDate:value forKey:key];
}

+(BOOL)setDate:(NSDate *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    return [_lockBox setDate:value forKey:key accessibility:accessibility];
}

+(NSDate *)dateForKey:(NSString *)key
{
    return [_lockBox dateForKey:key];
}

@end
