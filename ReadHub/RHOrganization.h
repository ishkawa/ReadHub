#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RHAccount;

@interface RHOrganization : NSManagedObject

@property (nonatomic, retain) NSNumber  *identifier;
@property (nonatomic, retain) NSURL     *avatarURL;
@property (nonatomic, retain) NSURL     *url;
@property (nonatomic, retain) NSString  *login;
@property (nonatomic, retain) RHAccount *account;

@end
