//
//  Alert.swift
//  OnTheMap
//
//  Created by João Ponte on 30/06/2023.
//

import UIKit

class Alert {
    
    class func basicAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true)
    }

    class func dismissAlert(title: String, message: String, vc: UIViewController) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { _ in
            vc.dismiss(animated: true)
        }))

        vc.present(alert, animated: true)
    }
    
    class func actionAlert(title: String,
                           message: String,
                           vc: UIViewController,
                           handler: @escaping (UIAlertAction) -> Void) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: handler))
        vc.present(alert, animated: true)
    }

}
