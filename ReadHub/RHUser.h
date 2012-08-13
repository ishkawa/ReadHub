#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RHUser : NSManagedObject

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

@end
