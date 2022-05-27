//
//  ResultRequestViewController.swift
//  CepAqui
//
//  Created by Virtual Machine on 11/05/22.
//

import UIKit

class ResultRequestViewController: UIViewController {
    
    @IBOutlet weak var refindButton: UIButton!
    @IBOutlet weak var cepLbl: UILabel!
    @IBOutlet weak var logradouroLbl: UILabel!
    @IBOutlet weak var complementoLbl: UILabel!
    @IBOutlet weak var bairroLbl: UILabel!
    @IBOutlet weak var cepTextField: UITextField!
    @IBOutlet weak var localidadeLbl: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var service = Services()
    var respons: CepModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refindButton.layer.cornerRadius = 25
        
        getData(respons: respons) 
        self.dismissKeyboardOnTap()
        cepTextField.delegate = self
        service.delegateCep = self
    }

    @IBAction func refindButtonPressed(_ sender: UIButton) {
        guard let cep = cepTextField.text else { return }
        Validation(cep: cep)
    }
    
}

// MARK: - dismissKey
extension ResultRequestViewController: UITextFieldDelegate {
    
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

// MARK: - // MARK: - Validation and Formatting
extension ResultRequestViewController: Utils {
    
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
    
// MARK: - Response Service
extension ResultRequestViewController: CepManegerDelegate {
    
    func didUpdateCep(cep: CepModel) {
        getData(respons: cep)
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
    

// MARK: - Population Data
extension ResultRequestViewController {
    
    func getData(respons: CepModel?) {
        if let safeResponse = respons {
            DispatchQueue.main.async {
                self.cepLbl.text = safeResponse.cep
                self.logradouroLbl.text = safeResponse.logradouro
                self.complementoLbl.text = safeResponse.complemento
                self.bairroLbl.text = safeResponse.bairro
                self.localidadeLbl.text = safeResponse.localidade
            }
        } else {
            print("Sá poha NAO FOI KRL")
        }
    }
    
}
