import SwiftUI

// MARK: - Component Library

/// Reusable form input component with validation
struct FormTextField: View {
    let label: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var placeholder: String = ""
    var isRequired: Bool = false
    var validator: ((String) -> Bool)? = nil
    var errorMessage: String? = nil
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            HStack(spacing: 4) {
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            TextField(placeholder.isEmpty ? label : placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            errorMessage != nil ? Color.red : Color.clear,
                            lineWidth: 1
                        )
                )
            
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

/// Action button with consistent styling
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                HStack(spacing: 8) {
                    ProgressView()
                        .tint(.white)
                    Text(title)
                }
            } else {
                HStack(spacing: 8) {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .disabled(isLoading)
    }
}

/// Alert message component
struct AlertBanner: View {
    let message: String
    let type: AlertType
    
    enum AlertType {
        case success, error, warning, info
        
        var color: Color {
            switch self {
            case .success: return Color.green
            case .error: return Color.red
            case .warning: return Color.orange
            case .info: return Color.blue
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .warning: return "exclamationmark.circle.fill"
            case .info: return "info.circle.fill"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.icon)
                .foregroundColor(type.color)
            
            Text(message)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(type.color.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(type.color, lineWidth: 1)
        )
    }
}

/// Empty state view
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .multilineTextAlignment(.center)
    }
}

// MARK: - Helpers

/// Debounce helper for text input
class DebounceHelper: ObservableObject {
    @Published var text: String = ""
    private var cancellable: Any?
    var debounceAction: ((String) -> Void)?
    
    func debounce(delay: TimeInterval = 0.5) {
        #if canImport(Combine)
        import Combine
        
        let publisher = Timer.publish(every: delay, on: .main, in: .common)
            .autoconnect()
            .dropFirst()
        
        cancellable = publisher.sink { [weak self] _ in
            self?.debounceAction?(self?.text ?? "")
        }
        #endif
    }
}

#Preview {
    VStack(spacing: 16) {
        FormTextField(label: "نام", text: .constant(""), placeholder: "نام ساختمان", isRequired: true)
        
        AlertBanner(message: "عملیات با موفقیت انجام شد", type: .success)
        
        EmptyStateView(
            icon: "doc.text",
            title: "هیچ داده ای",
            message: "هنوز هیچ پرداختی ثبت نشده است",
            actionTitle: "افزودن",
            action: { }
        )
    }
    .padding()
}
