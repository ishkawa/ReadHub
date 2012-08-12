#import "RHGitHubAuthViewController.h"
#import "RHAccount.h"
#import "NSDictionary+URLQuery.h"

@implementation RHGitHubAuthViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Login";
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(dismiss)];
    }
    return self;
}

- (void)viewDidUnload
{
    self.webView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    RHAccount *account = [RHAccount currentAccount];
    if (account) {
        // TODO: confirm sign out
    }
    [self loadAuthorizePage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - action

- (void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)clearCookies
{
    NSHTTPCookieStorage *cookieStrage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (id cookie in [cookieStrage cookies]) {
		[cookieStrage deleteCookie:cookie];
	}
}

- (void)loadAuthorizePage
{
    [self clearCookies];
    
    NSDictionary *parameters = @{
        @"client_id"    : CLIENT_ID,
        @"redirect_uri" : REDIRECT_URI,
        @"scope"        : @"repo"
    };
    NSString *URLString = [NSString stringWithFormat:@"%@?%@", AUTHORIZE_URL, [parameters URLQuery]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [self.webView loadRequest:request];
}

- (void)requestAccessTokenWithCode:(NSString *)code
{
    [SVProgressHUD showWithStatus:@"Authorizing"];
    
    NSDictionary *parameters = @{
        @"client_id"     : CLIENT_ID,
        @"client_secret" : CLIENT_SECRET,
        @"redirect_uri"  : REDIRECT_URI,
        @"code"          : code
    };
    NSURL *URL = [NSURL URLWithString:ACCESS_TOKEN_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [parameters.URLQuery dataUsingEncoding:NSUTF8StringEncoding];
    
    ISNetworkOperation *operation = [ISNetworkOperation operationWithRequest:request];
    [operation enqueueWithHandler:^(NSURLResponse *response, id object, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:nil];
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
        NSDictionary *query = [NSDictionary dictionaryWithURLQuery:string];
        RHAccount *account = [RHAccount accountWithDictionary:query];
        if (!account) {
            [SVProgressHUD showErrorWithStatus:nil];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:nil];
        [self dismiss];
    }];
}

#pragma mark - web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *callbackURL = [NSURL URLWithString:REDIRECT_URI];
    if ([callbackURL.host isEqualToString:request.URL.host]) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithURLQuery:request.URL.query];
        NSString *code = [dictionary objectForKey:@"code"];
        [self requestAccessTokenWithCode:code];
        return NO;
    }
    return YES;
}

@end
