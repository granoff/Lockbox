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

@property (nonatomic, strong) Lockbox *lockbox;

@end

@implementation ViewController
@synthesize inputTextField;
@synthesize saveButton;
@synthesize fetchButton;
@synthesize fetchedValueLabel;
@synthesize statusLabel;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.lockbox = [[Lockbox alloc] init];
    }
    return self;
}

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
            result = [self.lockbox setString:value forKey:kMyKeyString];
            break;
            
        case kSaveAsArray:
        {
            value = [value stringByAppendingString:@" - array element"];
            NSArray *array = [NSArray arrayWithObjects:
                              [value stringByAppendingString:@" 1"], 
                              [value stringByAppendingString:@" 2"], 
                              [value stringByAppendingString:@" 3"],
                              nil];
            result = [self.lockbox setArray:array forKey:kMyKeyArray];
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
            result = [self.lockbox setSet:set forKey:kMyKeySet];
            break;
        }
            
        case kSaveAsDictionary:
        {
            value = [value stringByAppendingString:@" - dictionary element"];
            NSDictionary * dictionary = value ? @{@"key 1" : [value stringByAppendingString:@" 1"],
                                                  @"key 2" : [value stringByAppendingString:@" 2"],
                                                  @"key 3" : [value stringByAppendingString:@" 3"]} : nil;
            result = [self.lockbox setDictionary:dictionary forKey:kMyKeyDictionary];
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
            value = [self.lockbox stringForKey:kMyKeyString];
            break;
            
        case kSaveAsArray:
        {
            NSArray *array = [self.lockbox arrayForKey:kMyKeyArray];
            value = [array componentsJoinedByString:@"\n"];
            break;
        }
            
        case kSaveAsSet:
        {
            NSSet *set = [self.lockbox setForKey:kMyKeySet];
            value = [[set allObjects] componentsJoinedByString:@"\n"];
            break;
        }
            
        case kSaveAsDictionary:
        {
            NSDictionary * dictionary = [self.lockbox dictionaryForKey:kMyKeyDictionary];
            value = dictionary.description;
            break;
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
