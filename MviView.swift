import RxSwift

protocol MviView {
    associatedtype VM
    associatedtype INTENT
    associatedtype ACTION
    
    /**
     Attach the view to view model and action streams
     */
    func attach(viewModel: Observable<VM>, actions: Observable<ACTION>)
    
    /**
     Obtain intent stream for attaching to model
     */
    func getIntents() -> Observable<INTENT>
}

/**
 State of the curent view
 */
struct ViewState {
    let isLoading: Bool
    let isEmpty: Bool
    let isError: Bool
    var error: Error?
    
    init(isLoading: Bool = false,
         isEmpty: Bool = true,
         isError: Bool = false,
         error: Error? = nil) {
        self.isLoading = isLoading
        self.isEmpty = isEmpty
        self.isError = isError
        self.error = error
    }
    
    func copy(isLoading: Bool? = nil,
              isEmpty: Bool? = nil,
              isError: Bool? = nil,
              error: Error? = nil) -> ViewState {
        return ViewState(isLoading: isLoading ?? self.isLoading,
                         isEmpty: isEmpty ?? self.isEmpty,
                         isError: isError ?? self.isError,
                         error: error ?? self.error)
    }
}

extension ViewState: Equatable {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        return lhs.isLoading == rhs.isLoading
            && lhs.isEmpty == rhs.isEmpty
            && lhs.isError == rhs.isError
            && lhs.error?.localizedDescription == rhs.error?.localizedDescription
    }
}
