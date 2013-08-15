## Intro
AFOAuthSignInViewController is an easy way to create ViewController for Web Services which need to sign in without switching to Mobile Safari.

#### Usage
1. Install with [CocoaPods](http://cocoapods.org) or clone
2. `#import "AFOAuthSignInViewController.h"`.
3. Create the ViewController by using `[AFOAuthSignInViewController alloc]initWithOAuthClientType:<#(AFOAuthClientType)#> baseURL:<#(NSURL *)#> key:<#(NSString *)#> secret:<#(NSString *)#> verifyParameter:<#(NSString *)#> requestTokenPath:<#(NSString *)#> userAuthorizationPath:<#(NSString *)#> callbackURL:<#(NSURL *)#> accessTokenPath:<#(NSString *)#> accessMethod:<#(NSString *)#> scope:<#(NSString *)#>];`
4. set Delegate to appropriate Class.
5. use `- (void)signInViewController:(AFOAuthSignInViewController *)viewController didGetAccessPermissionWithClient:(id)client attributes:(NSDictionary *)attributes` to retrieves the AFOAuthClient and attributes of the User.


