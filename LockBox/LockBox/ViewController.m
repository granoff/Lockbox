//
//  ViewController.m
//  LockBox
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import "ViewController.h"
#import "Lockbox.h"

#define kMyKeyString    @"MyKeyString"
#define kMyKeyArray     @"MyKeyArray"
#define kMyKeySet       @"MyKeySet"

#define kSaveAsString 0
#define kSaveAsArray  1
#define kSaveAsSet    2

@interface ViewController ()

@end

@implementation ViewController
@synthesize inputTextField;
@synthesize saveButton;
@synthesize fetchButton;
@synthesize fetchedValueLabel;
@synthesize statusLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setInputTextField:nil];
    [self setSaveButton:nil];
    [self setFetchButton:nil];
    [self setFetchedValueLabel:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(IBAction)saveButtonPressed:(id)sender
{
    [inputTextField resignFirstResponder];
    
    UIButton *b = (UIButton *)sender;
    NSString *value = inputTextField.text;
    BOOL result = NO;
    
    switch (b.tag) {
        case kSaveAsString:
            result = [Lockbox setString:value forKey:kMyKeyString];
            break;
            
        case kSaveAsArray:
        {
            value = [value stringByAppendingString:@" - array element"];
            NSArray *array = [NSArray arrayWithObjects:
                              [value stringByAppendingString:@" 1"], 
                              [value stringByAppendingString:@" 2"], 
                              [value stringByAppendingString:@" 3"],
                              nil];
            result = [Lockbox setArray:array forKey:kMyKeyArray];
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
            result = [Lockbox setSet:set forKey:kMyKeySet];
            break;
        }
            
        default:
            break;
    }
    
    statusLabel.text = [NSString stringWithFormat:@"%@",
                        (result ? @"Saved!" : @"Save failed.")];
    
}

-(IBAction)fetchButtonPressed:(id)sender
{
    [inputTextField resignFirstResponder];

    UIButton *b = (UIButton *)sender;

    NSString *value = @"";
    
    switch (b.tag) {
        case kSaveAsString:
            value = [Lockbox stringForKey:kMyKeyString];
            break;
            
        case kSaveAsArray:
        {
            NSArray *array = [Lockbox arrayForKey:kMyKeyArray];
            value = [array componentsJoinedByString:@"\n"];
            break;
        }
            
        case kSaveAsSet:
        {
            NSSet *set = [Lockbox setForKey:kMyKeySet];
            value = [[set allObjects] componentsJoinedByString:@"\n"];
        }
            
            
        default:
            break;
    }
    
    fetchedValueLabel.text = value;
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
