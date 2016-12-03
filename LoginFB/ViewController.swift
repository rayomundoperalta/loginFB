//
//  ViewController.swift
//  LoginFB
//
//  Created by Raymundo Peralta on 11/4/16.
//  Copyright © 2016 Raymundo Peralta. All rights reserved.
//

import UIKit

class ViewController: UIViewController , FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // let unRect = self.view.bounds
        logoutFB()
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            // esta app ya fue autorizada, no hay que fastidiar al usuario
            print("Ya entre")
            let logout = UIButton(type: .Custom)
            logout.setTitle("Logout", forState:.Normal)
            logout.center = self.view.center
            logout.addTarget(self, action: #selector(ViewController.logoutFB), forControlEvents:.TouchUpInside)
        } else {
            FBSDKLoginManager().loginBehavior = .Web
            let login = FBSDKLoginButton()
            
            login.center = self.view.center
            //let login:FBSDKLoginButton = FBSDKLoginButton(frame:CGRectMake(unRect.width/3, unRect.size.height/3, unRect.size.width / 3, unRect.size.height / 3))
            self.view.addSubview(login)
            login.delegate = self
            login.readPermissions = ["public_profile", "email"]
        }
    }
    
    func logoutFB() {
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            print("no se puede completar login con fb")
        } else  if result.isCancelled {
            print("El usuario no acepta el login con facebook")
        } else
        {
            if result.grantedPermissions.contains("email") {
                let email = result.valueForKey("email") as! String
            
                print("el usuario tiene el correo \(email)")
            }
            print("pase por el resultado")
            
        }
    }
    

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User loged out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }
    
}

