# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
users = User.create([
  { first_name: 'John', last_name: 'Doe', password: 'password123', password_confirmation: 'password123', bio: 'Bio for John Doe', email: 'john.doe@example.com' },
  { first_name: 'Jane', last_name: 'Smith', password: 'password123', password_confirmation: 'password123', bio: 'Bio for Jane Smith', email: 'jane.smith@example.com' },
  { first_name: 'Emily', last_name: 'Johnson', password: 'password123', password_confirmation: 'password123', bio: 'Bio for Emily Johnson', email: 'emily.johnson@example.com' },
  { first_name: 'Michael', last_name: 'Brown', password: 'password123', password_confirmation: 'password123', bio: 'Bio for Michael Brown', email: 'michael.brown@example.com' },
  { first_name: 'Sarah', last_name: 'Williams', password: 'password123', password_confirmation: 'password123', bio: 'Bio for Sarah Williams', email: 'sarah.williams@example.com' },
  { first_name: 'David', last_name: 'Jones', password: 'password123', password_confirmation: 'password123', bio: 'Bio for David Jones', email: 'david.jones@example.com' },
  { first_name: 'Laura', last_name: 'Garcia', password: 'password123', password_confirmation: 'password123', bio: 'Bio for Laura Garcia', email: 'laura.garcia@example.com' },
  { first_name: 'Daniel', last_name: 'Martinez', password: 'password123', password_confirmation: 'password123', bio: 'Bio for Daniel Martinez', email: 'daniel.martinez@example.com' },
  { first_name: 'Olivia', last_name: 'Rodriguez', password: 'password123', password_confirmation: 'password123', bio: 'Bio for Olivia Rodriguez', email: 'olivia.rodriguez@example.com' },
  { first_name: 'James', last_name: 'Wilson', password: 'password123', password_confirmation: 'password123', bio: 'Bio for James Wilson', email: 'james.wilson@example.com' }
])

ROOT_PATH = "/home/nav/Pictures/images"
file1 = File.open("#{ROOT_PATH}/photo-1475776408506-9a5371e7a068.avif")
file2 = File.open("#{ROOT_PATH}/photo-1506057213367-028a17ec52e5.avif")
file3 = File.open("#{ROOT_PATH}/photo-1522140607231-7c05952eb779.avif")
file4 = File.open("#{ROOT_PATH}/Big_Buck_Bunny_1080_10s_10MB.mp4")
files = [file1 , file2 , file3 , file4 ]
file_names  = ["pic1.avif" ,"pic2.avif" ,"pic3.avif" ,"bunny.mp4" ]
content_types = ["image/avif" , "image/avif" ,"image/avif", "video/mp4"]  


users.each do |user|
  factor = 1
  rand(15..25).times do |i|
    post = user.posts.new(
        caption: "Post #{i + 1} for #{user.first_name}",
        body: "This is the body text for post #{i + 1}. It is associated with #{user.first_name} #{user.last_name}.",
        user: user
      )
    if( (i % factor) == 0 )
      r = rand(0..3)
      post.media.attach(io: files[r] , filename: file_names[r] , content_type: content_types[r]) 
    end
    post.save
    factor += 1
    
  end
end

