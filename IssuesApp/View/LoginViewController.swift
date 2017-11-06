//
//  LoginViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 10. 28..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    static var viewController: LoginViewController {
        guard let viewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return LoginViewController() }
        return viewContoller
    }
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
        App.api.getToken { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}













