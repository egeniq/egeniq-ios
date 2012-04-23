//
//  MainViewController.m
//  Egeniq
//
//  Created by Johan Kool on 23/4/2012.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"

@interface MainViewController () < LoginViewControllerDelegate >

- (IBAction)showLoginPromptAction:(id)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)showLoginPromptAction:(id)sender {
    [self showLoginPrompt:YES];
}

- (void)showLoginPrompt:(BOOL)animated {
    LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];

    loginController.delegate = self;
    //    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:kUsernamePreferenceKey];
    //    if (username) {
    //        NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:kServiceName error:NULL];
    //        loginController.username = username;
    //        loginController.password = password;
    //        loginController.rememberMe = (password != nil);
    //    }
    UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:loginController];
    [self presentModalViewController:loginNavController animated:animated];
}

- (void)loginViewController:(LoginViewController *)loginController credentialsEnteredForUsername:(NSString *)username password:(NSString *)password rememberMe:(BOOL)rememberMe {
    loginController.navigationItem.rightBarButtonItem.enabled = NO;
    loginController.view.userInteractionEnabled = NO;
    if ([password isEqualToString:@"Egeniq"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        loginController.navigationItem.rightBarButtonItem.enabled = YES;
        loginController.view.userInteractionEnabled = YES;
    }
}

- (void)loginViewControllerRegister:(LoginViewController *)loginController {
    
}

@end
