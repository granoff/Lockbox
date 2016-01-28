//
//  ViewController.m
//  LockBox
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import "ViewController.h"
#import "Lockbox.h"

#define kMyKeyString        @"MyKeyString"
#define kMyKeyArray         @"MyKeyArray"
#define kMyKeySet           @"MyKeySet"
#define kMyKeyDictionary    @"MyKeyDictionary"

#define kSaveAsString       0
#define kSaveAsArray        1
#define kSaveAsSet          2
#define kSaveAsDictionary   3

@interface ViewController ()
@property (nonatomic, strong) NSArray *keys;
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.keys = @[kMyKeyString, kMyKeyArray, kMyKeySet, kMyKeyDictionary];
}

-(IBAction)saveButtonPressed:(id)sender
{
    
    [_inputTextField resignFirstResponder];
    
    UIButton *b = (UIButton *)sender;
    NSString *value = _inputTextField.text;
    BOOL result = NO;

    NSString *key = _keys[b.tag];
    id object = nil;
    
    switch (b.tag) {
        case kSaveAsString:
            object = value;
            break;
            
        case kSaveAsArray:
        {
            value = [value stringByAppendingString:@" - array element"];
            NSArray *array = [NSArray arrayWithObjects:
                              [value stringByAppendingString:@" 1"], 
                              [value stringByAppendingString:@" 2"], 
                              [value stringByAppendingString:@" 3"],
                              nil];
            object = array;
            break;
        }
            
        case kSaveAsSet:
        {
            value = [value stringByAppendingString:@" - set element"];
            NSSet *set = [NSSet setWithObjects:
                          [value stringByAppendingString:@" 1"], 
                          [value stringByAppendingString:@" 2"], 
                          [value stringByAppendingString:@" 3"],
                          nil];
            object = set;
            break;
        }
            
        case kSaveAsDictionary:
        {
            value = [value stringByAppendingString:@" - dictionary element"];
            NSDictionary * dictionary = value ? @{@"key 1" : [value stringByAppendingString:@" 1"],
                                                  @"key 2" : [value stringByAppendingString:@" 2"],
                                                  @"key 3" : [value stringByAppendingString:@" 3"]} : nil;
            object = dictionary;
            break;
        }
            
        default:
            break;
    }

    result = [Lockbox archiveObject:object forKey:key];

    _statusLabel.text = [NSString stringWithFormat:@"%@",
                        (result ? @"Saved!" : @"Save failed.")];
    
}

-(IBAction)fetchButtonPressed:(id)sender
{
    [_inputTextField resignFirstResponder];

    UIButton *b = (UIButton *)sender;
    NSString *key = _keys[b.tag];
    id object = [Lockbox unarchiveObjectForKey:key];
    
    _fetchedValueLabel.text = [object description];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
