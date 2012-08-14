#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RHAccountContext.h"

@interface RHUser : NSManagedObject <RHAccountContext>

@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSURL    *avatarURL;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSURL    *blogURL;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSNumber *publicRepositoriesCount;
@property (nonatomic, retain) NSNumber *followersCount;
@property (nonatomic, retain) NSNumber *followingCount;

+ (RHUser *)user;
+ (RHUser *)userWithDictionary:(NSDictionary *)dictionary;

@end
