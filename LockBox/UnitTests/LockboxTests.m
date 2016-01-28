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
    XCTAssertTrue([Lockbox setString:testString forKey:key], @"Should be able to store a string");
    XCTAssertEqualObjects([Lockbox stringForKey:key], testString, @"Retrieved string should match original");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testDeleteStringForKey
{
    NSString *key = @"TestStringKey";
    XCTAssertTrue([Lockbox setString:testString forKey:key], @"Should be able to store a string");
    XCTAssertEqualObjects([Lockbox stringForKey:key], testString, @"Retrieved string should match original");
    XCTAssertTrue([Lockbox setString:nil forKey:key], @"Should be able to set string for key to nil");
    XCTAssertNil([Lockbox stringForKey:key], @"Deleted key should return nil");
}

-(void)testSetArrayForKey
{
    NSString *key = @"TestArrayKey";
    XCTAssertTrue([Lockbox setArray:testArray forKey:key], @"Should be able to store an array");
    NSArray *array = [Lockbox arrayForKey:key];
    XCTAssertEqualObjects(array, testArray, @"Retrieved array should match original");

    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetSetForKey
{
    NSString *key = @"TestSetKey";
    XCTAssertTrue([Lockbox setSet:testSet forKey:key], @"Should be able to store a set");
    NSSet *set = [Lockbox setForKey:key];
    XCTAssertEqualObjects(set, testSet, @"Retrieved set should match original");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetDictionaryForKey
{
    NSString *key = @"TestDictionaryKey";
    XCTAssertTrue([Lockbox setDictionary:testDictionary forKey:key], @"Should be able to store a dictionary");
    NSDictionary *dictionary = [Lockbox dictionaryForKey:key];
    XCTAssertEqualObjects(dictionary, testDictionary, @"Retrieved dictionary should match original");
    
    NSString *expectedValueForKey = [testDictionary objectForKey:@"Key 1"];
    NSString *actualValueForKey = [dictionary objectForKey:@"Key 1"];
    
    XCTAssertEqualObjects(expectedValueForKey, actualValueForKey, @"Actual objectForKey value doesn't match expected value");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetSameKeyWithTwoValues
{
    XCTAssertTrue([Lockbox setString:@"1" forKey:@"test"], @"Set '1' for key 'test'");
    XCTAssertTrue([[Lockbox stringForKey:@"test"] isEqualToString:@"1"], @"Retrieve '1' for key 'test'");
    XCTAssertTrue([Lockbox setString:@"2" forKey:@"test"], @"Set '2' for key 'test'");
    XCTAssertTrue([[Lockbox stringForKey:@"test"] isEqualToString:@"2"], @"Retrieve '2' for key 'test'");
}

-(void)testSetDateForKey
{
    NSString *key = @"TestDateKey";
    XCTAssertTrue([Lockbox setDate:testDate forKey:key], @"Should be able to store a date");
    NSDate *date = [Lockbox dateForKey:key];
    XCTAssertEqualObjects(date, testDate, @"Retrieved date should match original");
}

-(void)testSetNoDateForKey
{
    NSString *key = @"TestDateKey";
    XCTAssertTrue([Lockbox setDate:nil forKey:key], @"Should be able to remove a stored date");
}

-(void)testRetrieveDateForNoKey
{
    NSString *key =@"NonexistentDateKey";
    XCTAssertNil([Lockbox dateForKey:key], @"Should return nil (date) for nonexistent key");
}

-(void)testNilDictionary
{
    NSString *key = @"testDict";
    NSDictionary *testDict = @{ @"test1" : @"value1", @"test2" : @"value2" };
    XCTAssertTrue([Lockbox setDictionary:testDict forKey:key], @"Set Dictionary value for key 'testDict'");

    NSDictionary *savedDict = [Lockbox dictionaryForKey:key];
    XCTAssertTrue(savedDict != nil, @"Retrieved Dictionary for key 'testDict'");
    XCTAssertTrue([savedDict allKeys].count == 2, @"Key count matches stored Dictionary");
    XCTAssertTrue([savedDict[@"test1"] isEqualToString:@"value1"], @"Retrieve Dictionary 'value1' for Dictionary key 'test1'");
    
    XCTAssertTrue([Lockbox setDictionary:nil forKey:key], @"Setting Dictionary value to nil for key 'testDict'");
    XCTAssertNil([Lockbox dictionaryForKey:key], @"Confirm Dictionary has been cleared from Lockbox");
}

- (void)testNilArray
{
    NSString *key = @"testArr";
    NSArray *testArr = @[ @"value1", @"value2", @"value3" ];
    XCTAssertTrue([Lockbox setArray:testArr forKey:key], @"Set Array value for key 'testArr'");
    
    NSArray *savedArr = [Lockbox arrayForKey:key];
    XCTAssertTrue(savedArr != nil, @"Retrieved Array for key 'testArr'");
    XCTAssertTrue(savedArr.count == 3, @"Array count matches stored Array");
    XCTAssertTrue([savedArr[1] isEqualToString:@"value2"], @"Retrieve Array value 'value2' at index 1");
    
    XCTAssertTrue([Lockbox setArray:nil forKey:key], @"Setting Array value to nil for key 'testArr'");
    XCTAssertNil([Lockbox arrayForKey:key], @"Confirm Array has been cleared from Lockbox");

}

- (void)testLocalInstance
{
    NSString *customKeyPrefix = @"my.custom.keyPrefix";
    Lockbox *lb = [[Lockbox alloc] initWithKeyPrefix:customKeyPrefix];
    
    XCTAssertEqualObjects(customKeyPrefix, lb.keyPrefix, @"Custom key prefix should equal '%@'", customKeyPrefix);
}

//-(void)testArrayOfDictionary
//{
//    NSArray *array = @[ testDictionary ];
//    [Lockbox setArray:array forKey:@"testArrayOfDictionary"];
//    
//    NSArray *fetchedArray = [Lockbox arrayForKey:@"testArrayOfDictionary"];
//    
////    XCTAssertEqualObjects(array, fetchedArray, @"Fetched array of dictionary should match original");
//    
//    NSDictionary *fetchedDictionary = fetchedArray.firstObject;
//    
//    XCTAssertEqualObjects(fetchedDictionary, testDictionary, @"Fetched dictionary from array should equal testDictionary");
//}

@end
