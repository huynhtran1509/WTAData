#import "PrimaryKeyEntity.h"

@interface PrimaryKeyEntity ()

// Private interface goes here.

@end

@implementation PrimaryKeyEntity

// Custom logic goes here.
- (void)importCustomImportString:(NSString*)importString
{
    self.customImportString = [NSString stringWithFormat:@"CUSTOM IMPORTED: %@", importString];
}

@end
