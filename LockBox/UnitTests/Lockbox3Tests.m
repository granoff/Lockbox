//
//  Lockbox3Tests.m
//  LockBox
//
//  Created by Mark Granoff on 1/27/16.
//  Copyright © 2016 Hawk iMedia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Lockbox.h"

@interface Lockbox3Tests : XCTestCase
@property (nonatomic, strong) NSString *testString;
@property (nonatomic, strong) NSArray *testArray;
@property (nonatomic, strong) NSSet *testSet;
@property (nonatomic, strong) NSDictionary *testDictionary;
@property (nonatomic, strong) NSDate *testDate;
@end

@implementation Lockbox3Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.testString = @"TestString";
    self.testArray = @[ @"A", @"B", @"C" ];
    self.testSet = [NSSet setWithArray:self.testArray];
    self.testDictionary = @{@"Key 1": @"A",
                       @"Key 2": @"B",
                       @"Key 3": @"C"};
    self.testDate = [NSDate date];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testArchiveStringForKey
{
    NSString *key = @"TestStringKey";
    XCTAssertTrue([Lockbox archiveObject:_testString forKey:key], @"Should be able to archive a string");
    XCTAssertEqualObjects([Lockbox unarchiveObjectForKey:key], _testString, @"Retrieved string should match original");
}

-(void)testDeleteStringForKey
{
    NSString *key = @"TestStringKey";
    XCTAssertTrue([Lockbox archiveObject:_testString forKey:key], @"Should be able to store a string");
    XCTAssertEqualObjects([Lockbox unarchiveObjectForKey:key], _testString, @"Retrieved string should match original");
    XCTAssertTrue([Lockbox archiveObject:nil forKey:key], @"Should be able to set string for key to nil");
    XCTAssertNil([Lockbox unarchiveObjectForKey:key], @"Deleted key should return nil");
}

-(void)testSetArrayForKey
{
    NSString *key = @"TestArrayKey";
    XCTAssertTrue([Lockbox archiveObject:_testArray forKey:key], @"Should be able to store an array");
    NSArray *array = [Lockbox unarchiveObjectForKey:key];
    XCTAssertEqualObjects(array, _testArray, @"Retrieved array should match original");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetSetForKey
{
    NSString *key = @"TestSetKey";
    XCTAssertTrue([Lockbox archiveObject:_testSet forKey:key], @"Should be able to store a set");
    NSSet *set = [Lockbox unarchiveObjectForKey:key];
    XCTAssertEqualObjects(set, _testSet, @"Retrieved set should match original");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetDictionaryForKey
{
    NSString *key = @"TestDictionaryKey";
    XCTAssertTrue([Lockbox archiveObject:_testDictionary forKey:key], @"Should be able to store a dictionary");
    NSDictionary *dictionary = [Lockbox unarchiveObjectForKey:key];
    XCTAssertEqualObjects(dictionary, _testDictionary, @"Retrieved dictionary should match original");
    
    NSString *expectedValueForKey = [_testDictionary objectForKey:@"Key 1"];
    NSString *actualValueForKey = [dictionary objectForKey:@"Key 1"];
    
    XCTAssertEqualObjects(expectedValueForKey, actualValueForKey, @"Actual objectForKey value doesn't match expected value");
    
    [NSThread sleepForTimeInterval:1.0];
}

-(void)testSetSameKeyWithTwoValues
{
    XCTAssertTrue([Lockbox archiveObject:@"1" forKey:@"test"], @"Set '1' for key 'test'");
    XCTAssertTrue([[Lockbox unarchiveObjectForKey:@"test"] isEqualToString:@"1"], @"Retrieve '1' for key 'test'");
    XCTAssertTrue([Lockbox archiveObject:@"2" forKey:@"test"], @"Set '2' for key 'test'");
    XCTAssertTrue([[Lockbox unarchiveObjectForKey:@"test"] isEqualToString:@"2"], @"Retrieve '2' for key 'test'");
}

-(void)testSetDateForKey
{
    NSString *key = @"TestDateKey";
    XCTAssertTrue([Lockbox archiveObject:_testDate forKey:key], @"Should be able to store a date");
    NSDate *date = [Lockbox unarchiveObjectForKey:key];
    XCTAssertEqualObjects(date, _testDate, @"Retrieved date should match original");
}

-(void)testSetNoDateForKey
{
    NSString *key = @"TestDateKey";
    XCTAssertTrue([Lockbox archiveObject:nil forKey:key], @"Should be able to remove a stored date");
}

-(void)testRetrieveDateForNoKey
{
    NSString *key =@"NonexistentDateKey";
    XCTAssertNil([Lockbox unarchiveObjectForKey:key], @"Should return nil (date) for nonexistent key");
}

-(void)testNilDictionary
{
    NSString *key = @"testDict";
    NSDictionary *testDict = @{ @"test1" : @"value1", @"test2" : @"value2" };
    XCTAssertTrue([Lockbox archiveObject:testDict forKey:key], @"Set Dictionary value for key 'testDict'");
    
    NSDictionary *savedDict = [Lockbox unarchiveObjectForKey:key];
    XCTAssertTrue(savedDict != nil, @"Retrieved Dictionary for key 'testDict'");
    XCTAssertTrue([savedDict allKeys].count == 2, @"Key count matches stored Dictionary");
    XCTAssertTrue([savedDict[@"test1"] isEqualToString:@"value1"], @"Retrieve Dictionary 'value1' for Dictionary key 'test1'");
    
    XCTAssertTrue([Lockbox archiveObject:nil forKey:key], @"Setting Dictionary value to nil for key 'testDict'");
    XCTAssertNil([Lockbox unarchiveObjectForKey:key], @"Confirm Dictionary has been cleared from Lockbox");
}

- (void)testNilArray
{
    NSString *key = @"testArr";
    NSArray *testArr = @[ @"value1", @"value2", @"value3" ];
    XCTAssertTrue([Lockbox archiveObject:testArr forKey:key], @"Set Array value for key 'testArr'");
    
    NSArray *savedArr = [Lockbox unarchiveObjectForKey:key];
    XCTAssertTrue(savedArr != nil, @"Retrieved Array for key 'testArr'");
    XCTAssertTrue(savedArr.count == 3, @"Array count matches stored Array");
    XCTAssertTrue([savedArr[1] isEqualToString:@"value2"], @"Retrieve Array value 'value2' at index 1");
    
    XCTAssertTrue([Lockbox archiveObject:nil forKey:key], @"Setting Array value to nil for key 'testArr'");
    XCTAssertNil([Lockbox unarchiveObjectForKey:key], @"Confirm Array has been cleared from Lockbox");
    
}

- (void)testLocalInstance
{
    NSString *customKeyPrefix = @"my.custom.keyPrefix";
    Lockbox *lb = [[Lockbox alloc] initWithKeyPrefix:customKeyPrefix];
    
    XCTAssertEqualObjects(customKeyPrefix, lb.keyPrefix, @"Custom key prefix should equal '%@'", customKeyPrefix);
}

-(void)testArrayOfDictionary
{
    NSArray *array = @[ _testDictionary ];
    [Lockbox archiveObject:array forKey:@"testArrayOfDictionary"];
    
    NSArray *fetchedArray = [Lockbox unarchiveObjectForKey:@"testArrayOfDictionary"];
    
    XCTAssertEqualObjects(array, fetchedArray, @"Fetched array of dictionary should match original");
    
    NSDictionary *fetchedDictionary = fetchedArray.firstObject;
    
    XCTAssertEqualObjects(fetchedDictionary, _testDictionary, @"Fetched dictionary from array should equal _testDictionary");
}

-(void)testInvalidArchiveData
{
    [Lockbox setString:@"testing" forKey:@"testInvalidArchive"];
    
    id data = [Lockbox unarchiveObjectForKey:@"testInvalidArchive"];
    
    XCTAssertNil(data, @"Expected nil for an invalid archive");
}

@end
