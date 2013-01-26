//
//  Lockbox.h
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

@interface Lockbox : NSObject

+(BOOL)setString:(NSString *)value forKey:(NSString *)key;
+(BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
+(NSString *)stringForKey:(NSString *)key;

+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key;
+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
+(NSArray *)arrayForKey:(NSString *)key;

+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key;
+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
+(NSSet *)setForKey:(NSString *)key;

+(BOOL)setDate:(NSDate *)value forKey:(NSString *)key;
+(BOOL)setDate:(NSDate *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility;
+(NSDate *)dateForKey:(NSString *)key;

@end
