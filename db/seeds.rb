# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all
Event.destroy_all
Checkin.destroy_all

puts "Seeds have been disintegrated 💥"

def user_create(user)
  User.create!(user)
end

puts "Generating new seeds 🌱"

# Users section -- START --
users = []

users << {
  first_name: "Meg",
  last_name: "Projman",
  username: "komegi",
  email: "meg@mpulse.com",
  gender: "2",
  password: "123456"
}

users << {
  first_name: "Raecine",
  last_name: "Leaddev",
  username: "rae",
  email: "rae@mpulse.com",
  gender: "2",
  password: "123456"
}

users << {
  first_name: "Syrene",
  last_name: "Prontendo",
  username: "sy",
  email: "sy@mpulse.com",
  gender: "1",
  password: "123456"
}

users << {
  first_name: "Justin",
  last_name: "Bakuendo",
  username: "just",
  email: "justin@mpulse.com",
  gender: "1",
  password: "123456"
}

users.each do |user|
  created_user = User.create!(user)

  if created_user.gender == 1
    puts "User -> #{created_user.username} has been created... 🚹"
  elsif created_user.gender == 2
    puts "User -> #{created_user.username} has been created... 🚺"
  else
    puts "User -> #{created_user.username} has been created... 🦄"
  end
end

# Random users for checkins!
# 50.times do
#   created_user = User.create!(
#     first_name: "RandomFirstName#{number}",
#     last_name: "RandomLastName#{number}",
#     username: "RandomUser#{number}",
#     email: "RandomEmail@mpulse.com",
#     gender: "rand(1..2)",
#     password: "123456"
#   )
# end

puts "Users have been generated succesfully 💃🕺"
# Users section -- END --

# Events section -- START --
# Add your own event + description here ⬇️
events = [
  { name: "Disco Ball 🪩", description: "Party until your head spin 😵‍💫" },
  { name: "Javascript Seminar 💻", description: "Hone your coding skills in this Javascript seminar, be the web developer you know you can be!"},
  { name: "70's Night 📺", description: "Go back in time and bring your vintage look to life"},
  { name: "Single's Meet-up 💘", description: "Find your match made in heaven in this meet-up event. Disclaimer: You are not required to end up with a partner by the end of this event!"}
]

# Add an address to the randomizer
addresses = ["Shinjuku", "Shibuya", "Meguro", "Asakusa", "Ikebukuro", "Paris"]

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

organizers = []
2.times do
  organizers << User.all.sample
end

events.each do |event|
  starting_time = start_times.sample
  # Random datetime instance with set parameters from start_times array
  Event.create!(
    name: event[:name],
    description: event[:description],
    # Name/Description pairing from the events array
    address: addresses.sample,
    # Random address from the addresses array
    start_at: starting_time,
    # Random datetime instance with set parameters from start_time array
    end_at: starting_time + (1.5 / 24),
    # End time currently set to be 1.5 hours after start time
    category: rand(1..4),
    user: organizers.sample
    # Assigned to random organizer
  )
  puts "Event -> #{Event.last.name} has been created"
end

puts "Events have been generated succesfully 🪩🎊🪅"
# Events section -- END --

# Checkins section -- START --
5.times do
  Checkin.create!(
    status: 1,
    event: Event.all.sample,
    user: User.all.sample
  )
end

puts "Checkins have been generated succesfully ☑️"
# Checkins section -- END --
