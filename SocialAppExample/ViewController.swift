//
//  ViewController.swift
//  SocialAppExample
//
//  Created by Developer on 9/11/18.
//  Copyright © 2018 Aaron. All rights reserved.
//

import UIKit
import Social
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    //1.- importar Social
    //2.- poner la UI para tener 2 botones, linkearlos
    //3.- implementar los share con la nativa
    //4.- instalar los pods del podfile (pod init, pod install)
    //5.- agregar FBDSLoginKit y agregar el botón a la vista en el viewDidLoad
    //6.- iniciar una app en developers.facebook.com
    //7.- Dentro ir al bundle idy agregarlo en el apartado de inicio de sesión con facebook
    //8.- siguiendo los pasos de Facebook ve el código de objective C convertido en AppDelegate
    //9.- usar delegate e implementar métodos
    //10 crear el fetchUserProfile() para sacar los datos del usuario logueado
    
    @IBOutlet weak var lblStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let btnFaceLogin = FBSDKLoginButton()
        btnFaceLogin.center = self.view.center
        
        btnFaceLogin.readPermissions = ["email","public_profile","user_friends"]
        self.view.addSubview(btnFaceLogin)
        // Do any additional setup after loading the view, typically from a nib.
        if FBSDKAccessToken.current() != nil {
            //print(FBSDKAccessToken.current().value(forKey: "email"))
            fetchUserProfile(token: FBSDKAccessToken.current().tokenString)
            self.lblStatus.text = "Logged in"
        } else {
           self.lblStatus.text = "Logged in"
        }
    }
    
    func fetchUserProfile(token: String)
    {
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token, version: nil, httpMethod: "GET")
        req?.start(completionHandler: { (connection, result, error) in
            if(error == nil)
            {
                print("result \(result)")
            }
            else
            {
                print("error \(error)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            self.lblStatus.text = error.localizedDescription
        } else if result.isCancelled {
            self.lblStatus.text = "User canceló"
        } else {
            self.lblStatus.text = "user login"
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        lblStatus.text = "user cerró sesión"
    }

    @IBAction func facePressed(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Share on Facebook")
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func twitterPressed(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Share on Twitter")
            self.present(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

