Batch.create(:name => "Far Future 2026", :current => true)

tags = [
  "Android",
  "iOS",
  "Windows",
  "macOS",
  "App",
  "Game",
  "VR",
  "Oculus",
  "HTC Vive",
  "Other"
]

Tag.create(tags.map{ |t| { :text => t } })
