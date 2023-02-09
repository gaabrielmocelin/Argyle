# Argyle Test

#### Running it
- Clone it `$ git clone https://github.com/gaabrielmocelin/Argyle.git`
- Open project on Xcode
- Hit run! 🤩

## Archicteture 👨‍💻
### MVP 
- **Model:** Data Representation - e.g [LinkItem](https://github.com/gaabrielmocelin/Argyle/blob/main/ArgyleSDK/Model/LinkItem.swift)
- **View:** View Consists of both Views and ViewControllers, with all UI setup and events - e.g [SearchViewController](https://github.com/gaabrielmocelin/Argyle/blob/main/ArgyleSDK/Search/SearchViewController.swift)
- **Presenter:** Presenter handles all the logic, including responding to user actions and updating the UI (via delegate) - e.g [SearchPresenter](https://github.com/gaabrielmocelin/Argyle/blob/main/ArgyleSDK/Search/SearchPresenter.swift)

Extra one:
- **Service:** Services are responsible to deliver a Model to the Presenter, they are injected abstractions that can be easily replaced. - e.g [NetworkService](https://github.com/gaabrielmocelin/Argyle/blob/main/ArgyleSDK/Network/NetworkService.swift)

### Modularization 
Could have been created a SPM or a CocoaPod for simulating the SDK, however in order to keep it as simple as possible it was just created a new Target on the same project that exposes a single entry point to set keys and get a view controller.

### Dependencies
No third part libraries were used on this project.

## Features

| Search 🔎 | Dark Mode 🌒 |
| --- | --- |
| <img src="https://github.com/gaabrielmocelin/Argyle/blob/main/search.gif" width="250"> | <img src="https://github.com/gaabrielmocelin/Argyle/blob/main/dark_mode.png" width="250"> |

| iPad 📱 | Mac 💻 |
| --- | --- |
| <img src="https://github.com/gaabrielmocelin/Argyle/blob/main/iPad.png" width="400"> | <img src="https://github.com/gaabrielmocelin/Argyle/blob/main/mac.png" width="600"> |



## Where To Go

- Increase Code Coverage (LinkItemCellViewModel, DataRequestDecodes, NetworkLayer...)
- Perform UI Testing
- Hide Secrets on a Secret File ignored by git
- Add String Localization
- Introduce Coordinator for decoupling view presentation
