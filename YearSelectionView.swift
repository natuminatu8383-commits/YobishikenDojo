import SwiftUI

struct YearSelectionView: View {
    let years = [
        "平成17年", "平成18年", "平成19年", "平成20年",
        "平成21年", "平成22年", "平成23年", "平成24年",
        "平成25年", "平成26年", "平成27年", "平成28年"
    ]

    var body: some View {
        List(years, id: \.self) { year in
            NavigationLink(
                // ✅ mode: .year(year) を追加
                destination: SubjectSelectionView(year: year, random: false, mode: .year(year))
            ) {
                Text(year)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.vertical, 8)
            }
        }
        .navigationTitle("年度選択")
    }
}

struct YearSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        YearSelectionView()
    }
}
