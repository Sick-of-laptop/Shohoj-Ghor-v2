import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var errorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.isAuthenticated = userSession != nil
        
        if let userSession = userSession {
            fetchUser(withUid: userSession.uid)
        }
    }
    
    // Validation functions
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegEx = "^[0-9]{11}$" // For Bangladesh numbers
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
    
    func login(withEmail email: String, password: String) {
        // Validate inputs
        guard !email.isEmpty else {
            self.errorMessage = "Email cannot be empty"
            self.showError = true
            return
        }
        
        guard isValidEmail(email) else {
            self.errorMessage = "Please enter a valid email"
            self.showError = true
            return
        }
        
        guard !password.isEmpty else {
            self.errorMessage = "Password cannot be empty"
            self.showError = true
            return
        }
        
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    return
                }
                
                guard let user = result?.user else { return }
                self.userSession = user
                self.successMessage = "Login successful!"
                self.showSuccess = true
                
                // Delay the navigation slightly to show the success message
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isAuthenticated = true
                    self.fetchUser(withUid: user.uid)
                }
            }
        }
    }
    
    func register(withEmail email: String, password: String, fullName: String, phone: String) {
        // Validate inputs
        guard !fullName.isEmpty else {
            self.errorMessage = "Name cannot be empty"
            self.showError = true
            return
        }
        
        guard !email.isEmpty else {
            self.errorMessage = "Email cannot be empty"
            self.showError = true
            return
        }
        
        guard isValidEmail(email) else {
            self.errorMessage = "Please enter a valid email"
            self.showError = true
            return
        }
        
        guard !phone.isEmpty else {
            self.errorMessage = "Phone number cannot be empty"
            self.showError = true
            return
        }
        
        guard isValidPhone(phone) else {
            self.errorMessage = "Please enter a valid phone number"
            self.showError = true
            return
        }
        
        guard isValidPassword(password) else {
            self.errorMessage = "Password must be at least 8 characters"
            self.showError = true
            return
        }
        
        isLoading = true
        // Check if email already exists
        Auth.auth().fetchSignInMethods(forEmail: email) { [weak self] methods, error in
            guard let self = self else { return }
            
            if let _ = methods {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Email already exists"
                    self.showError = true
                }
                return
            }
            
            // Create user
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.showError = true
                        return
                    }
                    
                    guard let user = result?.user else { return }
                    
                    let data = [
                        "email": email,
                        "fullName": fullName,
                        "phone": phone,
                        "uid": user.uid,
                        "createdAt": Timestamp()
                    ]
                    
                    Firestore.firestore().collection("users")
                        .document(user.uid)
                        .setData(data) { [weak self] error in
                            guard let self = self else { return }
                            
                            DispatchQueue.main.async {
                                if let error = error {
                                    self.errorMessage = error.localizedDescription
                                    self.showError = true
                                    return
                                }
                                
                                self.userSession = user
                                self.successMessage = "Registration successful!"
                                self.showSuccess = true
                                
                                // Delay the navigation slightly to show the success message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    self.isAuthenticated = true
                                    self.fetchUser(withUid: user.uid)
                                }
                            }
                        }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            self.isAuthenticated = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
    
    private func fetchUser(withUid uid: String) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.showError = true
                        return
                    }
                    
                    guard let data = snapshot?.data() else { return }
                    self.currentUser = User(data: data)
                }
            }
    }
} 