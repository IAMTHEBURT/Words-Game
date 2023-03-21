import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    // MARK: - PROPERTIES
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var bgColor: Color = .white
    var borderColor: Color = Color(hex: "E0DFE0")
    var fontColor: Color = Color(hex: "2B47DE")
    
    // MARK: - BODY
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(fontColor)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(bgColor)
            )
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(borderColor, lineWidth: 2)
            )
        
    }
    
}
