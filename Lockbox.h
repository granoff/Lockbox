//
//  Lockbox.h
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Lockbox : NSObject

#ifdef DEBUG
// For unit tests
@property (strong, nonatomic, readonly) NSString *keyPrefix;
#endif

@property (assign, nonatomic, readonly) OSStatus lastStatus;

// When the default key prefix (your app's bundle id) is not sufficient, instantiate your own
// instance of Lockbox specifying your own key prefix, and use the appropriate instance methods
// to store and retrieve keychain data. You can also instantiate your own instance and use the
// default key prefix simply by calling [[Lockbox alloc] init];
-(instancetype)initWithKeyPrefix:(NSString *)keyPrefix;

// When adding instance methods, remember to add a corresponding class method.

-(BOOL)archiveObject:(id<NSSecureCoding>)object forKey:(NSString *)key;
-(BOOL)archiveObject:(id<NSSecureCoding>)object forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;

-(id)unarchiveObjectForKey:(NSString *)key;

-(BOOL)setString:(NSString *)value forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to -archiveObject:forKey:");
-(BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility DEPRECATED_MSG_ATTRIBUTE("Migrate to -archiveObject:forKey:accesibility");
-(NSString *)stringForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to -unarchiveObject:forKey:");

-(BOOL)setArray:(NSArray *)value forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to -archiveObject:forKey:");
-(BOOL)setArray:(NSArray *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility DEPRECATED_MSG_ATTRIBUTE("Migrate to archiveObject:forKey:accesibility");
-(NSArray *)arrayForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to -unarchiveObject:forKey:");

-(BOOL)setSet:(NSSet *)value forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to -archiveObject:forKey:");
-(BOOL)setSet:(NSSet *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility DEPRECATED_MSG_ATTRIBUTE("Migrate to -archiveObject:forKey:accesibility");
-(NSSet *)setForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to -unarchiveObject:forKey:");

-(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to -archiveObject:forKey:");
-(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility DEPRECATED_MSG_ATTRIBUTE("Migrate to -archiveObject:forKey:accesibility");
-(NSDictionary *)dictionaryForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to -unarchiveObject:forKey:");

-(BOOL)setDate:(NSDate *)value forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to -archiveObject:forKey:");
-(BOOL)setDate:(NSDate *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility DEPRECATED_MSG_ATTRIBUTE("Migrate to -archiveObject:forKey:accesibility");
-(NSDate *)dateForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to -unarchiveObject:forKey:");

// Class methods that maintain the convenience of storing and retrieving data from the keychain
// using class-level methods. An internal instance of Lockbox is instantiated for the class that
// uses the instance methods above, and a key prefix equal to your app's bundle id.

+(BOOL)archiveObject:(id<NSSecureCoding>)object forKey:(NSString *)key;
+(BOOL)archiveObject:(id<NSSecureCoding>)object forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;

+(id)unarchiveObjectForKey:(NSString *)key;

+(BOOL)setString:(NSString *)value forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to +archiveObject:forKey:");
+(BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility DEPRECATED_MSG_ATTRIBUTE("Migrate to +archiveObject:forKey:accesibility");
+(NSString *)stringForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to +unarchiveObject:forKey:");

+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to +archiveObject:forKey:");
+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility DEPRECATED_MSG_ATTRIBUTE("Migrate to +archiveObject:forKey:accesibility");
+(NSArray *)arrayForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to +unarchiveObject:forKey:");

+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to +archiveObject:forKey:");
+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility DEPRECATED_MSG_ATTRIBUTE("Migrate to +archiveObject:forKey:accesibility");
+(NSSet *)setForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to +unarchiveObject:forKey:");

+(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to +archiveObject:forKey:");
+(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility DEPRECATED_MSG_ATTRIBUTE("Migrate to +archiveObject:forKey:accesibility");
+(NSDictionary *)dictionaryForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to +unarchiveObject:forKey:");

+(BOOL)setDate:(NSDate *)value forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to +archiveObject:forKey:");
+(BOOL)setDate:(NSDate *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility DEPRECATED_MSG_ATTRIBUTE("Migrate to +archiveObject:forKey:accesibility");
+(NSDate *)dateForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("Migrate to +unarchiveObject:forKey:");

@end
