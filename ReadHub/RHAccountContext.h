@protocol RHAccountContext <NSObject>

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSURL    *avatarURL;
@property (nonatomic, retain) NSString *login;

@end