//
//  LockboxTests.m
//  LockBox
//
//  Created by Mark Granoff on 1/26/13.
//  Copyright (c) 2013 Hawk iMedia. All rights reserved.
//

#import "LockboxTests.h"
#import "Lockbox.h"

@implementation LockboxTests
{
    NSString *testString;
    NSArray *testArray;
    NSSet *testSet;
}

-(void)setUp
{
    testString = @"TestString";
    testArray = @[ @"A", @"B", @"C" ];
    testSet = [NSSet setWithArray:testArray];
}

-(void)tearDown
{
    
}

-(void)testSetStringForKey
{
    NSString *key = @"TestStringKey";
    STAssertTrue([Lockbox setString:testString forKey:key], @"Should be able to store a string");
    STAssertEqualObjects([Lockbox stringForKey:key], testString, @"Retrieved string should match original");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testDeleteStringForKey
{
    NSString *key = @"TestStringKey";
    STAssertTrue([Lockbox setString:testString forKey:key], @"Should be able to store a string");
    STAssertEqualObjects([Lockbox stringForKey:key], testString, @"Retrieved string should match original");
    STAssertTrue([Lockbox setString:nil forKey:key], @"Should be able to set string for key to nil");
    STAssertNil([Lockbox stringForKey:key], @"Deleted key should return nil");
}

-(void)testSetArrayForKey
{
    NSString *key = @"TestArrayKey";
    STAssertTrue([Lockbox setArray:testArray forKey:key], @"Should be able to store an array");
    NSArray *array = [Lockbox arrayForKey:key];
    STAssertEqualObjects(array, testArray, @"Retrieved array should match original");

    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetSetForKey
{
    NSString *key = @"TestSetKey";
    STAssertTrue([Lockbox setSet:testSet forKey:key], @"Should be able to store a set");
    NSSet *set = [Lockbox setForKey:key];
    STAssertEqualObjects(set, testSet, @"Retrieved set should match original");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetSameKeyWithTwoValues
{
    STAssertTrue([Lockbox setString:@"1" forKey:@"test"], @"Set '1' for key 'test'");
    STAssertTrue([[Lockbox stringForKey:@"test"] isEqualToString:@"1"], @"Retrieve '1' for key 'test'");
    STAssertTrue([Lockbox setString:@"2" forKey:@"test"], @"Set '2' for key 'test'");
    STAssertTrue([[Lockbox stringForKey:@"test"] isEqualToString:@"2"], @"Retrieve '2' for key 'test'");
}
@end
