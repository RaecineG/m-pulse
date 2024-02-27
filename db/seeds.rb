User.destroy_all
Event.destroy_all
Checkin.destroy_all
Comment.destroy_all
puts "Seeds have been disintegrated 💥"
puts "Generating new seeds 🌱"

# Users section -- START --
users = []

users << {
  first_name: "Meg", last_name: "Projman",
  username: "komegi", email: "meg@mpulse.com",
  gender: "2", password: "123456"
}

users << {
  first_name: "Raecine", last_name: "Leaddev",
  username: "rae", email: "rae@mpulse.com",
  gender: "2", password: "123456"
}

users << {
  first_name: "Syrene", last_name: "Prontendo",
  username: "sy", email: "sy@mpulse.com",
  gender: "1", password: "123456"
}

users << {
  first_name: "Justin", last_name: "Bakuendo",
  username: "just", email: "justin@mpulse.com",
  gender: "1", password: "123456"
}

admin_users = []

users.each do |user|
  created_user = User.create!(user)
  admin_users << created_user

  if created_user.gender == 1
    puts "User -> #{created_user.username} has been created... 🚹"
  elsif created_user.gender == 2
    puts "User -> #{created_user.username} has been created... 🚺"
  else
    puts "User -> #{created_user.username} has been created... 🦄"
  end
end

# Random users for checkins!
random_users = []
number = 1 # For incrementing
rando_usernames = ["PartyAnimal", "MochaScript", "qt.pi", "1337coder", "unicorn", "LakersFan"]

50.times do
  created_user = User.create!(
    first_name: "RandomFirstName#{number}",
    last_name: "RandomLastName#{number}",
    username: "#{rando_usernames.sample}#{number}",
    email: "RandomEmail#{number}@mpulse.com",
    gender: rand(1..2),
    password: "123456"
  )
  random_users << created_user
  number += 1
end

puts "Created #{random_users.count} random users 🤖"

puts "All users have been generated succesfully 💃🕺"
# Users section -- END --

# Events section -- START --
# Add your own event here ⬇️
events = [
  { name: "Disco Ball 🪩",
    description: "Party until your head spin 😵‍💫",
    address: "Shinjuku", category: 0 },
  { name: "Javascript Seminar 💻",
    description: "Hone your coding skills in this Javascript seminar, be the web developer you know you can be!",
    address: "Meguro", category: 3 },
  { name: "70's Night 📺",
    description: "Go back in time and bring your vintage look to life",
    address: "Shibuya", category: 0 },
  { name: "Single's Meet-up 💘",
    description: "Find your match made in heaven in this meet-up event. Disclaimer: You are not required to end up with a partner by the end of this event!",
    address: "Ikebukuro", category: 2 },
  { name: "Pre-sakura Half-Marathon 🏃",
    description: "Warm-up before the Sakura season start, join us in this fun run along the scenic Meguro river",
    address: "Nakameguro", category: 1 }
] # Current event categories: 0-Club, 1-Sports, 2-Meet-up, 3-Tech

# DateTime format guide: DateTime.new(2001,2,3,4,5,6)
# Result => <DateTime: 2001-02-03T04:05:06+00:00 ...>
start_times = []

# Time randomizer
5.times do
  month = rand(2..3) # Random month between feb to mar
  day = rand(3..25) # Random day between 3rd to 25th
  hour = rand(10..19) # Random time between 10am and 7pm

  start_times << DateTime.new(2024, month, day, hour, 30, 0)
end

events.each do |event|
  starting_time = start_times.sample
  # Random datetime instance with set parameters from start_times array
  # e = Event.create!( # uncomment for seeding images feature
  Event.create!(
    name: event[:name],
    description: event[:description],
    address: event[:address],
    category: event[:category],
    # Name/Description/Address/Category from the events array
    start_at: starting_time,
    # Random datetime instance with set parameters from start_time array
    end_at: starting_time + (1.5 / 24),
    # End time currently set to be 1.5 hours after start time
    user: admin_users.sample
    # Assigned to random organizer/admin user
  )
  # e.image.attach
  puts "Event -> #{Event.last.name} has been created"
end

puts "Events have been generated succesfully 🪩🎊🪅"
# Events section -- END --

# Checkins/Comments section -- START --
random_users.each do |user|
  Event.all.each do |event|
    go = rand(1..8)
    if go != 1
      Checkin.create!(
        status: 1,
        event: event,
        user: user
      )
    end
  end
end

puts "Checkins have been generated succesfully ☑️"
# Checkins section -- END --

# Comments section -- START --
commenters = []
number = rand(3..25)

5.times do
  commenters << random_users[number]
  number += rand(2..5)
end

Event.all.each do |event|
  Comment.create!(
    event: event, user: commenters[0],
    content: "Best event ever!"
  )
  Comment.create!(
    event: event, user: commenters[1],
    content: "Why isn't this event everyday?"
  )
  Comment.create!(
    event: event, user: commenters[2],
    content: "Happiest day of my life 🥳"
  )
  Comment.create!(
    event: event, user: commenters[3],
    content: "Pretty cool event 😎"
  )
  Comment.create!(
    event: event, user: commenters[4],
    content: "Nice!"
  )
end

puts "Random user comments have been posted 📢"
# Comments section -- END --
