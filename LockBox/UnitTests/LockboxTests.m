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
    NSDictionary *testDictionary;
    NSDate *testDate;
}

-(void)setUp
{
    testString = @"TestString";
    testArray = @[ @"A", @"B", @"C" ];
    testSet = [NSSet setWithArray:testArray];
    testDictionary = @{@"Key 1": @"A",
                       @"Key 2": @"B",
                       @"Key 3": @"C"};
    testDate = [NSDate date];
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

-(void)testSetDictionaryForKey
{
    NSString *key = @"TestDictionaryKey";
    STAssertTrue([Lockbox setDictionary:testDictionary forKey:key], @"Should be able to store a dictionary");
    NSDictionary *dictionary = [Lockbox dictionaryForKey:key];
    STAssertEqualObjects(dictionary, testDictionary, @"Retrieved dictionary should match original");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetSameKeyWithTwoValues
{
    STAssertTrue([Lockbox setString:@"1" forKey:@"test"], @"Set '1' for key 'test'");
    STAssertTrue([[Lockbox stringForKey:@"test"] isEqualToString:@"1"], @"Retrieve '1' for key 'test'");
    STAssertTrue([Lockbox setString:@"2" forKey:@"test"], @"Set '2' for key 'test'");
    STAssertTrue([[Lockbox stringForKey:@"test"] isEqualToString:@"2"], @"Retrieve '2' for key 'test'");
}

-(void)testSetDateForKey
{
    NSString *key = @"TestDateKey";
    STAssertTrue([Lockbox setDate:testDate forKey:key], @"Should be able to store a date");
    NSDate *date = [Lockbox dateForKey:key];
    STAssertEqualObjects(date, testDate, @"Retrieved date should match original");
}

-(void)testSetNoDateForKey
{
    NSString *key = @"TestDateKey";
    STAssertTrue([Lockbox setDate:nil forKey:key], @"Should be able to remove a stored date");
}

-(void)testRetrieveDateForNoKey
{
    NSString *key =@"NonexistentDateKey";
    STAssertNil([Lockbox dateForKey:key], @"Should return nil (date) for nonexistent key");
}

-(void)testNilDictionary
{
    NSString *key = @"testDict";
    NSDictionary *testDict = @{ @"test1" : @"value1", @"test2" : @"value2" };
    STAssertTrue([Lockbox setDictionary:testDict forKey:key], @"Set Dictionary value for key 'testDict'");

    NSDictionary *savedDict = [Lockbox dictionaryForKey:key];
    STAssertTrue(savedDict != nil, @"Retrieved Dictionary for key 'testDict'");
    STAssertTrue([savedDict allKeys].count == 2, @"Key count matches stored Dictionary");
    STAssertTrue([savedDict[@"test1"] isEqualToString:@"value1"], @"Retrieve Dictionary 'value1' for Dictionary key 'test1'");
    
    STAssertTrue([Lockbox setDictionary:nil forKey:key], @"Setting Dictionary value to nil for key 'testDict'");
    STAssertNil([Lockbox dictionaryForKey:key], @"Confirm Dictionary has been cleared from Lockbox");
}

- (void)testNilArray
{
    NSString *key = @"testArr";
    NSArray *testArr = @[ @"value1", @"value2", @"value3" ];
    STAssertTrue([Lockbox setArray:testArr forKey:key], @"Set Array value for key 'testArr'");
    
    NSArray *savedArr = [Lockbox arrayForKey:key];
    STAssertTrue(savedArr != nil, @"Retrieved Array for key 'testArr'");
    STAssertTrue(savedArr.count == 3, @"Array count matches stored Array");
    STAssertTrue([savedArr[1] isEqualToString:@"value2"], @"Retrieve Array value 'value2' at index 1");
    
    STAssertTrue([Lockbox setArray:nil forKey:key], @"Setting Array value to nil for key 'testArr'");
    STAssertNil([Lockbox arrayForKey:key], @"Confirm Array has been cleared from Lockbox");

}

@end
