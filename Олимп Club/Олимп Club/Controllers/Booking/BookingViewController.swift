//
//  BookingViewController.swift
//  Олимп Club
//
//  Created by Robert Zinyatullin on 20.03.2023.
//

import UIKit

final class BookingViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bookingButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookingButtonAction(_ sender: Any) {
        if isFieldsAreEmpty() {
            Alert().presentAlert(vc: self, title: "Ошибка", message: "Заполните пустые поля")
        } else if !isValidEmail(email: emailTextField.text ?? "") {
            Alert().presentAlert(vc: self, title: "Ошибка", message: "Проверьте корректность ввода почты")
        } else {
            Alert().presentEscapingAlert(vc: self, title: "Успешно", message: "Ваша заявка будет рассмотрена, мы с вами свяжемся")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        phoneTextField.delegate = self
        
        nameTextField.corneredRadius(radius: 10)
        phoneTextField.corneredRadius(radius: 10)
        emailTextField.corneredRadius(radius: 10)
        
        bookingButton.corneredRadius(radius: 14)
    }
    
    private func isFieldsAreEmpty() -> Bool {
        return nameTextField.text?.isEmpty ?? true
        || phoneTextField.text?.isEmpty ?? true
        || emailTextField.text?.isEmpty ?? true
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension BookingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
