//
//  GitHubAPI.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 4..
//  Copyright © 2017년 intmain. All rights reserved.
//

import Foundation
import OAuthSwift
import Alamofire
import SwiftyJSON

typealias IssuesResponseHandler = (DataResponse<[Model.Issue]>) -> Void

struct GitHubAPI: API {
    let oauth: OAuth2Swift = OAuth2Swift(
        consumerKey: "c110aef38d954b31593c",
        consumerSecret: "67ef2ca554a99dee97fbbd7da5ab6bd4ec8181e7",
        authorizeUrl: "https://github.com/login/oauth/authorize",
        accessTokenUrl: "https://github.com/login/oauth/access_token",
        responseType: "code")
    
    func getToken(handler: @escaping (() -> Void)) {
        oauth.authorize(
            withCallbackURL: "issuesapp://oauth-callback/github",
            scope: "user,repo",
            state: "state",
            success: { (credential, _, _) in
                let token = credential.oauthToken
                let refreshToken = credential.oauthRefreshToken
                print("token: \(token)")
                GlobalState.instance.token = token
                GlobalState.instance.refreshToken = refreshToken
                handler()
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    func tokenRefresh(handler: @escaping (() -> Void)) {
        guard let refreshToken = GlobalState.instance.refreshToken else { return }
        oauth.renewAccessToken(withRefreshToken: refreshToken, success: { (credential, _, _) in
            let token = credential.oauthToken
            let refreshToken = credential.oauthRefreshToken
            print("token: \(token)")
            GlobalState.instance.token = token
            GlobalState.instance.refreshToken = refreshToken
            handler()
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    
    func repoIssues(owner: String, repo: String, page: Int, handler: @escaping IssuesResponseHandler) {
        let parameters: Parameters = ["page": page, "state": "all"]
        GitHubRouter.manager.request(GitHubRouter.repoIssues(owner: owner, repo: repo, parameter: parameters)).responseSwiftyJSON { (dataResponse: DataResponse<JSON>) in
            let result: DataResponse<[Model.Issue]> = dataResponse.map({ (json: JSON) -> [Model.Issue] in
                return json.arrayValue.map{ json -> Model.Issue in
                    return Model.Issue(json: json)
                }
            })
            handler(result)
        }
    }
}















