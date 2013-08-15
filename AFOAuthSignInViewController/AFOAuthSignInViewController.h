//
//  AFOAuthSignInViewController.h
//  AFOAuthSignInViewController
//
//  Created by Sean Cheng on 8/12/13.
//  Copyright (c) 2013 Extremely Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	
	AFOAuthClientType1 = 0,
	AFOAuthClientType2 = 1
	
} AFOAuthClientType;

@class AFOAuthSignInViewController;

@protocol AFOAuthSignInViewControllerDelegate <NSObject>

@optional

- (void)signInViewController:(AFOAuthSignInViewController*)viewController didGetAccessPermissionWithClient:(id)client attributes:(NSDictionary*)attributes;

@end

@interface AFOAuthSignInViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic,strong) id																				client;
@property (nonatomic,assign) id<AFOAuthSignInViewControllerDelegate>	delegate;

- (id)initWithOAuthClientType:(AFOAuthClientType)clientType
											baseURL:(NSURL*)baseURL
													key:(NSString*)key
											 secret:(NSString*)secret
							verifyParameter:(NSString*)verifyParameter
						 requestTokenPath:(NSString*)requestTokenPath
				userAuthorizationPath:(NSString*)userAuthorizationPath
									callbackURL:(NSURL*)callbackURL
							accessTokenPath:(NSString*)accessTokenPath
								 accessMethod:(NSString*)accessMethod
												scope:(NSString*)scope;

@end
