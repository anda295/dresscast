import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}


extension View {
    @MainActor
    func renderedImage(width: CGFloat,
                       height: CGFloat,
                       background: Color = .white,
                       colorScheme: ColorScheme = .light,
                       scale: CGFloat = 2) -> UIImage {
        let content = self
            .frame(width: width, height: height)
            //.background(background)
            .environment(\.colorScheme, colorScheme)

        let renderer = ImageRenderer(content: content)
        renderer.scale = scale                    // 👈 use 1–2 for stories
        renderer.proposedSize = ProposedViewSize(width: width, height: height)
        return renderer.uiImage ?? UIImage()
    
    }
}
