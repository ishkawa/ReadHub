@class RHRepository;

@protocol RHAccountContext <NSObject>

@required
@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSURL    *avatarURL;
@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSSet    *repositories;

@optional
- (void)addRepositoriesObject:(RHRepository *)value;
- (void)removeRepositoriesObject:(RHRepository *)value;
- (void)addRepositories:(NSSet *)values;
- (void)removeRepositories:(NSSet *)values;

@end