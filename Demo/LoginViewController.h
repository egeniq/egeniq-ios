//
//  LoginViewController.h
//  Cobra
//
//  Created by Johan Kool on 21-03-2011.
//  Copyright 2011 Johan Kool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewController:(LoginViewController *)loginController credentialsEnteredForUsername:(NSString *)username password:(NSString *)password rememberMe:(BOOL)rememberMe;
- (void)loginViewControllerRegister:(LoginViewController *)loginController;

@end

@interface LoginViewController : UITableViewController

@property (nonatomic, assign) id <LoginViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) BOOL rememberMe;

@end
