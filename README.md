# Lockbox

Lockbox is an Objective-C utility class for storing data securely in the keychain. Use it to store small, sensitive bits of data securely.

## Overview

There are some bits of data that an app sometimes needs to store that are sensitive:

+ Usernames
+ Passwords
+ In-App Purchase unlocked feature bits
+ and anything else that, if in the wrong hands, would be B-A-D.

The thing to realize is that data stored in `NSUserDefaults` is stored in the clear! For that matter, most everything stored in your app's sandbox is also there in the clear.

Surprisingly, new and experienced app developers alike often do not realize this, until it's too late.

The Lockbox class methods make it easy to store and retrieve `NSString`s, `NSArray`s, and `NSSet`s into and from the key chain. You are spared having to deal with the keychain APIs directly!

One caveat here is that the keychain is really not meant to store large chunks of data, so don't try and store a huge array of data with these APIs simply because you want it secure. In this case, consider alternative encryption techniques.

## Methods

There are three pairs of methods, but method pairs for other container classes would not be hard to implement:

+ `+setString:forKey:`
+ `+stringForKey:`
+ `+setArray:forKey:`
+ `+arrayForKey:`
+ `+setSet:forKey:`
+ `+setForKey:`

All the `setXxx` methods return `BOOL`, indicating if the keychain operation succeeded or failed. The `xxxForKey` methods return a non-`nil` value on success, or `nil` on failure.

The `setXxx` methods will overwrite values for keys that already exist in the keychain, or simply add a keychain entry for the key/value pair if it's not already there.

In all the methods you can use a simple key name, like "MyKey", but know that under the hood Lockbox is prefixing that key with your apps bundle id. So the actual key used to store and retrieve the data looks more like "com.mycompany.myapp.MyKey". This ensures that your app, and only your app, has access to your data.

## Requirements

To use this class you will need to add the `Security` framework to your project.

## License

See the LICENSE file for details.
