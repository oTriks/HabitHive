import SwiftUI

struct HabitsView: View {
    @StateObject private var viewModel = HabitsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                Text("Habits")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CustomFloatingActionButton(
                    action: viewModel.addNewHabit,
                    imageName: "plus"
                )
                .sheet(isPresented: $viewModel.isAddingNewHabit) {
                    NewHabitView()
                }
            }
            .navigationBarHidden(true)
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
