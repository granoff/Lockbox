//
//  Lockbox.h
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Lockbox : NSObject

#ifdef DEBUG
// For unit tests
@property (strong, nonatomic, readonly) NSString *keyPrefix;
#endif

// When the default key prefix (your app's bundle id) is not sufficient, instantiate your own
// instance of Lockbox specifying your own key prefix, and use the appropriate instance methods
// to store and retreive keychain data. You can also instantiate your own instance and use the
// default key prefix simply by calling [[Lockbox alloc] init];
-(instancetype)initWithKeyPrefix:(NSString *)keyPrefix;

// When adding instance methods, remember to add a corresponding class method.

-(BOOL)setString:(NSString *)value forKey:(NSString *)key;
-(BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
-(NSString *)stringForKey:(NSString *)key;

-(BOOL)setArray:(NSArray *)value forKey:(NSString *)key;
-(BOOL)setArray:(NSArray *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
-(NSArray *)arrayForKey:(NSString *)key;

-(BOOL)setSet:(NSSet *)value forKey:(NSString *)key;
-(BOOL)setSet:(NSSet *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
-(NSSet *)setForKey:(NSString *)key;

-(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key;
-(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
-(NSDictionary *)dictionaryForKey:(NSString *)key;

-(BOOL)setDate:(NSDate *)value forKey:(NSString *)key;
-(BOOL)setDate:(NSDate *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
-(NSDate *)dateForKey:(NSString *)key;

// Class methods that maintain the convenience of storing and retrieving data from the keychain
// using class-level methods. An internal instance of Lockbox is instantiated for the class that
// uses the instance methods above, and a key prefix equal to your app's bundle id.

+(BOOL)setString:(NSString *)value forKey:(NSString *)key;
+(BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
+(NSString *)stringForKey:(NSString *)key;

+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key;
+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
+(NSArray *)arrayForKey:(NSString *)key;

+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key;
+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
+(NSSet *)setForKey:(NSString *)key;

+(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key;
+(BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
+(NSDictionary *)dictionaryForKey:(NSString *)key;

+(BOOL)setDate:(NSDate *)value forKey:(NSString *)key;
+(BOOL)setDate:(NSDate *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
+(NSDate *)dateForKey:(NSString *)key;

@end
