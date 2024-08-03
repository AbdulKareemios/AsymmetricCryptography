//
//  ViewController.swift
//  AsymetricCryptographicEncryption
//
//  Created by AK on 8/4/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let sharedCrypto = AsymmetricCryptoManager.shared
        let data = "this is my secret code".data(using: .utf8)!
        
        sharedCrypto.encrypt(data: data) { result in
            
            switch result {
            case .success(let encrypted):
                print("my encrypted message:\(encrypted)");
                
                sharedCrypto.decrypt(data: encrypted) { resultDecrypt in
                    
                    switch resultDecrypt {
                    case .success(let dataMessage):
                        print("my decrypted message:\(String(describing: String(data: dataMessage, encoding: .utf8)))");
                    case .failure(let decryptError):
                        print(decryptError.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}

