//
//  SignInView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 02/10/2020.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

struct SignInView: View {
    @Binding var presented: Bool
    @State private var currentNonce: String?
    
    var body: some View {
        SignInWithAppleButton(
            .signUp,
            onRequest: { request in
                let nonce = randomNonceString()
                currentNonce = nonce
                request.nonce = sha256(nonce)
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                    case .success (let authenticated):
                        if let appleIdCredential = authenticated.credential as? ASAuthorizationAppleIDCredential {
                            guard let nonce = currentNonce else {
                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                            }
                            guard let appleIDToken = appleIdCredential.identityToken else {
                                print("Unable to fetch identity token")
                                return
                            }
                            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                return
                            }
                            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                      idToken: idTokenString,
                                                                      rawNonce: nonce)
                            // Sign in with Firebase.
                            Auth.auth().signIn(with: credential) { (authResult, error) in
                                if let error = error {
                                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                                    // you're sending the SHA256-hashed nonce as a hex string with
                                    // your request to Apple.
                                    print(error.localizedDescription)
                                    return
                                }
                                presented = false
                            }
                            
                        }
                        print("Authorization successful.")
                    case .failure (let error):
                        // 3
                        print("Authorization failed: " + error.localizedDescription)
                }
                
            }
        )
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}
