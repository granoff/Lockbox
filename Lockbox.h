//
//  Lockbox.h
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

@interface Lockbox

+(BOOL)setString:(NSString *)value forKey:(NSString *)key;
+(NSString *)stringForKey:(NSString *)key;

+(BOOL)setArray:(NSArray *)value forKey:(NSString *)key;
+(NSArray *)arrayForKey:(NSString *)key;

+(BOOL)setSet:(NSSet *)value forKey:(NSString *)key;
+(NSSet *)setForKey:(NSString *)key;

@end
