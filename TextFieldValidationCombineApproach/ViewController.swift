//
//  ViewController.swift
//  TextFieldValidationCombineApproach
//
//  Created by Wilson on 7/18/20.
//  Copyright © 2020 NinjaLabs. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @Published var email = ""
    @Published var password = ""
    
    private var stream: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stream = validatedCredentials
            .receive(on: RunLoop.main).assign(to: \.isEnabled, on: submitButton)
    }

    @IBAction private func emailChanged(_ sender: UITextField) {
        email = sender.text ?? ""
    }
    
    @IBAction private func passwordChanged(_ sender: UITextField) {
        password = sender.text ?? ""
    }
    
    @IBAction private func submitAction(_ sender: UIButton) {
        print("Submit... \(email)")
        print(view.value(forKey: "_autolayoutTrace")!)
    }
    
    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
      return $password
        .receive(on: RunLoop.main)
        .map { password in
            let band = password.isStrongPassword
            return band
      }
      .eraseToAnyPublisher()
    }
    
    var isEmailValidPublisher: AnyPublisher<Bool, Never> {
      return $email
        .receive(on: RunLoop.main)
        .map { email in
            let band = email.isFormatValidEmail
            return band
        }
      .eraseToAnyPublisher()
    }
    
    var validatedCredentials: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(isEmailValidPublisher, isPasswordValidPublisher)
            .map { validatedEmail, validatePassword in
                return (validatedEmail &&  validatePassword)
        }
        .eraseToAnyPublisher()
    }

}

