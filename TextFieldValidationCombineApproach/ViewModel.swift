//
//  ViewModel.swift
//  TextFieldValidationCombineApproach
//
//  Created by Wilson on 7/18/20.
//  Copyright © 2020 NinjaLabs. All rights reserved.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
  // input
  @Published var username = ""
  @Published var password = ""
  @Published var passwordAgain = ""
  
  // output
  @Published var usernameMessage = ""
  @Published var passwordMessage = ""
  @Published var isValid = false

  private var cancellableSet: Set<AnyCancellable> = []
  
  private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
    $username
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { input in
        return input.count >= 3
      }
      .eraseToAnyPublisher()
  }
  
  private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
    $password
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .map { input in
        return input.count >= 8
      }
      .eraseToAnyPublisher()
  }
  
  private var isFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
      .map { userNameIsValid, passwordIsValid in
        return userNameIsValid && passwordIsValid
      }
    .eraseToAnyPublisher()
  }
  
  init() {
    isUsernameValidPublisher
      .receive(on: RunLoop.main)
      .map { valid in
        valid ? "" : "User name must at least have 3 characters"
      }
      .assign(to: \.usernameMessage, on: self)
      .store(in: &cancellableSet)
    
    isPasswordValidPublisher
      .receive(on: RunLoop.main)
      .map { passwordCheck in
        passwordCheck ? "" : "User password must at least have 8 characters"
      }
      .assign(to: \.passwordMessage, on: self)
      .store(in: &cancellableSet)

    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isValid, on: self)
      .store(in: &cancellableSet)
  }

}
