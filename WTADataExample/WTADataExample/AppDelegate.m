//
//  AppDelegate.m
//  WTADataExample
//
//  Copyright (c) 2014 WillowTree, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "AppDelegate.h"

#import "WTAData.h"
#import "NSManagedObject+WTAData.h"

#import "Entity.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.data = [[WTAData alloc] initWithModelNamed:@"WTADataExample"];
    
    NSError *error = nil;
    NSArray *existingEntities = [Entity fetchInContext:self.data.mainContext error:&error];
    
    // Populate with test data if we do not have any yet.
    if ([existingEntities count] == 0 || error)
    {
        [self.data saveInBackground:^(NSManagedObjectContext *context) {
            for (int i = 0; i < 9; i++)
            {
                Entity *entity = [NSEntityDescription insertNewObjectForEntityForName:[[Entity class] description]
                                                               inManagedObjectContext:context];
                entity.stringAttribute = [NSString stringWithFormat:@"Entity %d", i + 1];
            }
        } completion:^(BOOL savedChanges, NSError *error) {
            NSLog(@"Changes saved %d with error %@", savedChanges, error);
        }];
    }
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self.data cleanUp];
}

@end
