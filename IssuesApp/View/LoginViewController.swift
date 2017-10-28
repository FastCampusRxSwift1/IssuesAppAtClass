//
//  LoginViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 10. 28..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController {
    let oauth: OAuth2Swift = OAuth2Swift(
        consumerKey: "c110aef38d954b31593c",
        consumerSecret: "67ef2ca554a99dee97fbbd7da5ab6bd4ec8181e7",
        authorizeUrl: "https://github.com/login/oauth/authorize",
        accessTokenUrl: "https://github.com/login/oauth/access_token",
        responseType: "code")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginToGitHubButtonTapped() {
        oauth.authorize(
            withCallbackURL: "issuesapp://oauth-callback/github",
                    scope: "user,repo",
                    state: "state",
                    success: { (credential, _, _) in
                        let token = credential.oauthToken
                        print("token: \(token)")
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
}













