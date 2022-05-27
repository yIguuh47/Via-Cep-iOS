//
//  ViewController.swift
//  CepAqui
//
//  Created by Virtual Machine on 09/05/22.
//

import UIKit

class FindCepViewController: UIViewController, CepManegerDelegate{

    let service = Services()
    var cepResponse: CepModel?
    
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cepTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        findButton.layer.cornerRadius = 25
        
        self.dismissKeyboardOnTap()
        cepTextField.delegate = self
        service.delegateCep = self
        
    }
    
}

// MARK: - dismissKey
extension FindCepViewController: UITextFieldDelegate {
    
    func dismissKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
}

// MARK: - Validation and Formatting
extension FindCepViewController: Utils {
    
    func Validation(cep: String){
        if cep.count == 8 {
            Formatting(cepUrl: cep)
        } else {
            statusLabel.text = "Error verifique o CEP"
            statusLabel.textColor = UIColor.red
        }
    }
    
    func Formatting(cepUrl: String){
        let cep = cepUrl.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(service.cepURL)\(cep)/json/"
        service.requestCep(cepURL: urlString)
    }
    
}

// MARK: - Response service
extension FindCepViewController  {

    func didUpdateCep(cep: CepModel) {
        DispatchQueue.main.async {
            self.cepResponse = cep
            self.performSegue(withIdentifier: "goCepDetails", sender: self)
        }
    }
    
    func didError(erro: String, visivel: Bool) {
        if visivel == true {
            DispatchQueue.main.async {
                self.statusLabel.text = erro
                self.statusLabel.textColor = UIColor.red
            }
        } else {
        print(erro)
        }
    }
    
}

// MARK: - Navigation
extension FindCepViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goCepDetails" {
            let result = segue.destination as! ResultRequestViewController
            result.respons = cepResponse
        }
    }
    
    @IBAction func FindButtonPressed(_ sender: UIButton) {
        guard let cep = cepTextField.text else {return}
        Validation(cep: cep )
    }
     
}
