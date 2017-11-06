//
//  RepoViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 4..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

    @IBOutlet var ownerTextField: UITextField!
    @IBOutlet var repoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ownerTextField.text = GlobalState.instance.owner
        repoTextField.text = GlobalState.instance.repo
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "EnterRepoSegue" {
            guard let owner = ownerTextField.text, let repo = repoTextField.text else { return false }
            return !(owner.isEmpty || repo.isEmpty)
        }
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EnterRepoSegue" {
            guard let owner = ownerTextField.text, let repo = repoTextField.text else { return }
            GlobalState.instance.owner = owner
            GlobalState.instance.repo = repo
            GlobalState.instance.addRepo(owner: owner, repo: repo)
        }
    }
 

}

extension RepoViewController {
    @IBAction func logoutButtonTapped(_ sender: Any) {
        GlobalState.instance.token = ""
        let loginViewController = LoginViewController.viewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0 ) { [weak self] in
            self?.present(loginViewController, animated: true, completion: nil)
        }
    }
    @IBAction func unwindFromRepos(_ segue: UIStoryboardSegue) {
        guard let reposViewController = segue.source as? ReposViewController else { return }
        guard let (owner, repo) = reposViewController.selectedRepo else { return }
        ownerTextField.text = owner
        repoTextField.text = repo
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: "EnterRepoSegue", sender: nil)
        }
    }
}








