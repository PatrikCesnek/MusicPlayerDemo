<h2>Hello there! I'm Patrik and this is my Music Player demo app! 🚀</h2>
Version of the app with all basic requirements met

For Projects such as this I prefer MVVM for readability and ease of use. 

I put most of strings into Constants.swift file for safety and if the string needed to be changed it's easier to just change it in one place. :)

For now I'm still working on optional requiremetns, but I wanted to be sure everything is here in case I get stuck on something. :)

<p>
  <img width="310" alt="Screenshot 2025-04-17 at 12 46 55" src="https://github.com/user-attachments/assets/1341392a-6b14-4903-9a4d-f810f25978a9" />
<img width="310" alt="Screenshot 2025-04-16 at 15 19 01" src="https://github.com/user-attachments/assets/93acd770-acb7-4982-9a82-25fc639a2fb9" />
</p>

<h3>Basic Requirements:</h3>

- [x] Architecture - MVVM
- [x] SwiftUI
- [x] Localization
- [x] Simple error handling
- [x] No warnings or errors
- [x] Fetched data from this API
- [x] Implement audio playback using **AVPlayer**
- [x] App launches without issues

<h3>🧪 Bonus Requirements (Optional)</h3>

- [ ] Implement background audio playback.
- [x] Persist last played song and position.
- [ ] Add support for remote control (lock screen controls).
- [ ] Add simple unit tests for ViewModels.
- [ ] Display waveform or animation during playback.
- [x] Add option to download song for offline use.

<h3>Current problems:</h3>

- [x] There's a bug where if user is offline, downloaded songs work as expected, yet undownloaded songs have a bug where they either do not show player slider or if there's downloaded song playing it shows that song, just paused

