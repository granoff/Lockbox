//
//  LockboxTests.m
//  LockBox
//
//  Created by Mark Granoff on 1/26/13.
//  Copyright (c) 2013 Hawk iMedia. All rights reserved.
//


#import "Lockbox.h"
#import <XCTest/XCTest.h>

@interface LockboxTests : XCTestCase
@end

@implementation LockboxTests
{
    Lockbox *lockbox;
    NSString *testString;
    NSArray *testArray;
    NSSet *testSet;
    NSDictionary *testDictionary;
    NSDate *testDate;
}

-(void)setUp
{
    lockbox = [[Lockbox alloc] init];
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
    XCTAssertTrue([lockbox setString:testString forKey:key], @"Should be able to store a string");
    XCTAssertEqualObjects([lockbox stringForKey:key], testString, @"Retrieved string should match original");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testDeleteStringForKey
{
    NSString *key = @"TestStringKey";
    XCTAssertTrue([lockbox setString:testString forKey:key], @"Should be able to store a string");
    XCTAssertEqualObjects([lockbox stringForKey:key], testString, @"Retrieved string should match original");
    XCTAssertTrue([lockbox setString:nil forKey:key], @"Should be able to set string for key to nil");
    XCTAssertNil([lockbox stringForKey:key], @"Deleted key should return nil");
}

-(void)testSetArrayForKey
{
    NSString *key = @"TestArrayKey";
    XCTAssertTrue([lockbox setArray:testArray forKey:key], @"Should be able to store an array");
    NSArray *array = [lockbox arrayForKey:key];
    XCTAssertEqualObjects(array, testArray, @"Retrieved array should match original");

    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetSetForKey
{
    NSString *key = @"TestSetKey";
    XCTAssertTrue([lockbox setSet:testSet forKey:key], @"Should be able to store a set");
    NSSet *set = [lockbox setForKey:key];
    XCTAssertEqualObjects(set, testSet, @"Retrieved set should match original");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetDictionaryForKey
{
    NSString *key = @"TestDictionaryKey";
    XCTAssertTrue([lockbox setDictionary:testDictionary forKey:key], @"Should be able to store a dictionary");
    NSDictionary *dictionary = [lockbox dictionaryForKey:key];
    XCTAssertEqualObjects(dictionary, testDictionary, @"Retrieved dictionary should match original");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetSameKeyWithTwoValues
{
    XCTAssertTrue([lockbox setString:@"1" forKey:@"test"], @"Set '1' for key 'test'");
    XCTAssertTrue([[lockbox stringForKey:@"test"] isEqualToString:@"1"], @"Retrieve '1' for key 'test'");
    XCTAssertTrue([lockbox setString:@"2" forKey:@"test"], @"Set '2' for key 'test'");
    XCTAssertTrue([[lockbox stringForKey:@"test"] isEqualToString:@"2"], @"Retrieve '2' for key 'test'");
}

-(void)testSetDateForKey
{
    NSString *key = @"TestDateKey";
    XCTAssertTrue([lockbox setDate:testDate forKey:key], @"Should be able to store a date");
    NSDate *date = [lockbox dateForKey:key];
    XCTAssertEqualObjects(date, testDate, @"Retrieved date should match original");
}

-(void)testSetNoDateForKey
{
    NSString *key = @"TestDateKey";
    XCTAssertTrue([lockbox setDate:nil forKey:key], @"Should be able to remove a stored date");
}

-(void)testRetrieveDateForNoKey
{
    NSString *key =@"NonexistentDateKey";
    XCTAssertNil([lockbox dateForKey:key], @"Should return nil (date) for nonexistent key");
}

-(void)testNilDictionary
{
    NSString *key = @"testDict";
    NSDictionary *testDict = @{ @"test1" : @"value1", @"test2" : @"value2" };
    XCTAssertTrue([lockbox setDictionary:testDict forKey:key], @"Set Dictionary value for key 'testDict'");

    NSDictionary *savedDict = [lockbox dictionaryForKey:key];
    XCTAssertTrue(savedDict != nil, @"Retrieved Dictionary for key 'testDict'");
    XCTAssertTrue([savedDict allKeys].count == 2, @"Key count matches stored Dictionary");
    XCTAssertTrue([savedDict[@"test1"] isEqualToString:@"value1"], @"Retrieve Dictionary 'value1' for Dictionary key 'test1'");
    
    XCTAssertTrue([lockbox setDictionary:nil forKey:key], @"Setting Dictionary value to nil for key 'testDict'");
    XCTAssertNil([lockbox dictionaryForKey:key], @"Confirm Dictionary has been cleared from Lockbox");
}

- (void)testNilArray
{
    NSString *key = @"testArr";
    NSArray *testArr = @[ @"value1", @"value2", @"value3" ];
    XCTAssertTrue([lockbox setArray:testArr forKey:key], @"Set Array value for key 'testArr'");
    
    NSArray *savedArr = [lockbox arrayForKey:key];
    XCTAssertTrue(savedArr != nil, @"Retrieved Array for key 'testArr'");
    XCTAssertTrue(savedArr.count == 3, @"Array count matches stored Array");
    XCTAssertTrue([savedArr[1] isEqualToString:@"value2"], @"Retrieve Array value 'value2' at index 1");
    
    XCTAssertTrue([lockbox setArray:nil forKey:key], @"Setting Array value to nil for key 'testArr'");
    XCTAssertNil([lockbox arrayForKey:key], @"Confirm Array has been cleared from Lockbox");

}

- (void)testInitWithKeyPrefix
{
    lockbox = [[Lockbox alloc] initWithKeyPrefix:@"custom.key.prefix"];
    
    NSString *key = @"TestStringKey";
    XCTAssertTrue([lockbox setString:testString forKey:key], @"Should be able to store a string");
    XCTAssertEqualObjects([lockbox stringForKey:key], testString, @"Retrieved string should match original");
}

- (void)testInitWithNilKeyPrefix
{
    lockbox = [[Lockbox alloc] initWithKeyPrefix:nil];
    
    NSString *key = @"TestStringKey";
    XCTAssertTrue([lockbox setString:testString forKey:key], @"Should be able to store a string");
    XCTAssertEqualObjects([lockbox stringForKey:key], testString, @"Retrieved string should match original");
}

@end
