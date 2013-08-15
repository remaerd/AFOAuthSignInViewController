//
//  AFOAuthSignInViewController.m
//  AFOAuthSignInViewController
//
//  Created by Sean Cheng on 8/12/13.
//  Copyright (c) 2013 Extremely Limited. All rights reserved.
//

#import <AFOAuth1Client/AFOAuth1Client.h>
#import <AFOAuth2Client/AFOAuth2Client.h>

#import "AFOAuthSignInViewController.h"

@interface AFOAuthSignInViewController()
@property (nonatomic,strong) id client;
@property (nonatomic,strong) NSString*	verifyParameter;
@property (nonatomic,strong) NSString*	accessTokenPath;
@property (nonatomic,strong) NSString*	accessMethod;
@property (nonatomic,strong) NSString*	callbackURL;
@end

@implementation AFOAuthSignInViewController

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
												scope:(NSString*)scope
{
	self = [super init];
	if (self) {
		id client;
		if (clientType == AFOAuthClientType1) {
			
			client = [[AFOAuth1Client alloc]initWithBaseURL:baseURL key:key secret:secret];
			[client acquireOAuthRequestTokenWithPath:requestTokenPath callbackURL:callbackURL accessMethod:accessMethod scope:scope success:^(AFOAuth1Token *requestToken, id responseObject) {
				if (self.view != nil) {
					NSString* responseString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
					NSString* url = [NSString stringWithFormat:@"%@%@?oauth_token=%@",baseURL,userAuthorizationPath,requestToken.key];
					[(UIWebView*)self.view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
					[self.client setAccessToken:requestToken];
					
				} else NSLog(@"Cannot get Access Request from the server");
				
			} failure:^(NSError *error) {
				NSLog(@"%@",error);
			}];
		} else if (clientType == AFOAuthClientType2) {
			
			client = [[AFOAuth2Client alloc]initWithBaseURL:baseURL clientID:key secret:secret];
			if (self.view != nil) {
				NSString* url = [NSString stringWithFormat:@"%@%@?client_id=%@&response_type=code&scope=%@&redirect_uri=%@&state=security_token=%@=%@",
												 baseURL,userAuthorizationPath,key,scope,callbackURL.URLByStandardizingPath,secret,callbackURL.URLByStandardizingPath];
				[(UIWebView*)self.view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
				
			} else NSLog(@"Cannot get Access Request from the server");
		}
		
		self.client = client;
		self.accessTokenPath = accessTokenPath;
		self.accessMethod = accessMethod;
		self.verifyParameter = verifyParameter;
		self.callbackURL = callbackURL.absoluteString;
	}
	return self;
}

- (void)loadView
{
	[super loadView];
	
	UIWebView* webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
	[webView setDelegate:self];
	[webView setScalesPageToFit:YES];
	
	self.view = webView;
}

/**
 *
 *	判断连接是不是包含了返回参数的 Callback URL，并从中获取带有验证码 Key 的值
 *
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//	检查连接是不是 Callback URL
	NSString* urlString = request.URL.absoluteString;
	if ([urlString rangeOfString:self.callbackURL].location != NSNotFound) {
		if ([urlString rangeOfString:self.callbackURL].location == 0 && [urlString rangeOfString:self.callbackURL].length == self.callbackURL.length) {
			
//		通过 Regex 寻找连接内是否包含 AccessToken 验证码
			
			NSMutableArray* results = [[NSMutableArray alloc]init];
			NSString* regexString = [NSString stringWithFormat:@"(?=(%@=)).+(?!&)",self.verifyParameter];
			
			NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
			[regex enumerateMatchesInString:urlString options:0 range:NSMakeRange(0, urlString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
				[results addObject:[urlString substringWithRange:result.range]];
			}];
			
			if ([results count] != 0) {
				NSString* verifyValue = [((NSString*)results[0]) substringFromIndex:self.verifyParameter.length + 1];
				[self getAccessTokenWithVerifyValue:verifyValue];
				[self dismissViewControllerAnimated:YES completion:nil];
				return NO;
			} else NSLog(@"No Matching Verify Value Founded.");
		}
	} else return YES;
}

/**
 *	获取访问权 Access Token
 *
 *	@param	verifyValue	服务器返回的验证码
 */
- (void)getAccessTokenWithVerifyValue:(NSString*)verifyValue
{
	if ([[self.client class] isSubclassOfClass:[AFOAuth1Client class]]) {
		AFOAuth1Client* client = self.client;
		client.accessToken.verifier = verifyValue;
		[client acquireOAuthAccessTokenWithPath:self.accessTokenPath requestToken:client.accessToken accessMethod:self.accessMethod success:^(AFOAuth1Token *accessToken, id responseObject) {
			client.accessToken = accessToken;
			[self.delegate signInViewController:self didGetAccessPermissionWithClient:self.client attributes:responseObject];
		} failure:^(NSError *error) {
			NSLog(@"%@",error);
		}];
	} else if ([[self.client class] isSubclassOfClass:[AFOAuth2Client class]]) {
		AFOAuth2Client* client = self.client;
		[client authenticateUsingOAuthWithPath:self.accessTokenPath code:verifyValue redirectURI:self.callbackURL success:^(AFOAuthCredential *credential) {
			NSLog(@"%@",credential);
		} failure:^(NSError *error) {
			NSLog(@"%@",error);
		}];
	}
	
}

@end
