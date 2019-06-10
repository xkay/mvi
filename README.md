# MVI
Model View Intent Design Pattern in RxSwift inspired by [its kotlin counterpart](https://github.com/hpost/kommon-mvi)
 

Proposal for reactive UI design pattern inspired by Model View Intent written in Swift.

A UI component consists of a View and a Model. The View is responsible for rendering state and forwarding user input to the Model. The Model (similar to the presenter) is processing user input and external state to produce a ViewModel stream, which is rendered by the View. The action stream processes the user input and maps it into a corresponding Action that is fed back into the View as any type of navigation.

This pattern embraces the concept of unidirectional data flow and makes heavy use of Reactive Streams. The resulting UI components are fractal and can be nested to form larger components.

It is inspired by concepts like [Cycle.js](https://cycle.js.org/), Redux, and [this article by André Staltz](https://staltz.com/unidirectional-user-interface-architectures.html).

![](https://github.com/hpost/kommon-mvi/blob/master/docs/mvi_diagram.png)

## Usage

### In view: 

```swift
class ExampleVC: UIViewController {
    
    fileprivate let model = ExampleModel()
    fileprivate let disposables = CompositeDisposable()
    fileprivate let intents: PublishSubject<INTENT> = PublishSubject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attach(viewModel: model.getViewModel(), actions: model.getActions())
        model.attach(intents: getIntents())
    }
    
    deinit {
        model.detach()
    }
}

extension ExampleVC: MviView {
    typealias VM = ExampleViewModel
    typealias INTENT = ExampleIntent
    typealias ACTION = ExampleAction
    
    func attach(viewModel: Observable<VM>, actions: Observable<ExampleAction>) {
        _ = disposables.insert(actions.subscribe(onNext: handle))
        _ = disposables.insert(render(viewModel))
    }
    
    func getIntents() -> Observable<INTENT> {
        return intents
    }

}

// MARK: - Intents
extension ExampleViewController {
    fileprivate func setupIntents() {
       // create intent disposables
        
        _ = disposables.insert(
            Observable.merge([])
                .subscribe(intents)
        )
    }
}

// MARKL - Render
extension ExampleViewController {  
    private func render(_ viewModel: Observable<VM>) -> CompositeDisposable {
        return CompositeDisposable.init(disposables: [])
    }
}

// MARK: - Actions
extension ExampleViewController {
    fileprivate func handle(action: ACTION) {
        switch action {
            ...
        }
    }
}

```

### In model:

```swift
class ExampleModel {
    var disposables: CompositeDisposable = CompositeDisposable()
    var viewModel: BehaviorSubject<PhotosViewModel> = BehaviorSubject.init(value: PhotosViewModel())
    var actions: PublishSubject<PhotosAction> = PublishSubject()
    var events: PublishSubject<Event> = PublishSubject()
    
    required init() { // Inject Singletons, etc
        // ...
    }
}

extension ExampleModel: Model {
    typealias VM = PhotosViewModel
    typealias INTENT = PhotosIntent
    typealias ACTION = PhotosAction
    
    func attach(intents: Observable<INTENT>) {
        let initModel = PhotosViewModel()
        makeViewModel(events: eventsFrom(intents: intents),
                      initialViewModel: initModel,
                      reducer: reduce)
        makeActions(actions: actionsFrom(intents: intents))
    }
    
    func eventsFrom(intents: Observable<INTENT>) -> Observable<Event> {
        // Map intents to events...
        return Observable.merge([])
    }
    
    func reduce(model: VM, event: Event) -> VM {
        let newViewModel = model
        
        switch event {
        default:
            break
        }
        
        return newViewModel
    }
    
    func actionsFrom(intents: Observable<INTENT>) -> Observable<ACTION> {
        // Map intents to actions...
        return Observable.merge([])
    }
}
```

### ExampleContract.swift (Recommended but not required):
- The contract file is an overview of all possible state changes and interactions the feature needs to abide to (thus the naming)

```swift
struct ExampleViewModel: Equatable {
    // all state changes
}

enum PhotosIntent: Intent {
    case ClickedButton
}

enum PhotosAction: Action {
    
}
```
