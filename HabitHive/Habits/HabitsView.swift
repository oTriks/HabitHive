import SwiftUI

struct HabitsView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text("Habits")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomFloatingActionButton(
                action: { print("Floating Action Button Tapped") },
                imageName: "plus"
                
            )
        }
    }
}



// Preview provider
struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
    }
}
