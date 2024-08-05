# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


(90001..100000).each do |i|
  pp "User-#{i}"
  User.create( first_name: "user-#{i}" , last_name: "user-#{i}", username: "user-#{i}",
                password:"1234567", bio:"bio-#{i}" , email: "user#{i}@abc.com" )
end

# ROOT_PATH = "/home/nav/Pictures/images"
# file1 = File.open("#{ROOT_PATH}/photo-1475776408506-9a5371e7a068.avif")
# file2 = File.open("#{ROOT_PATH}/photo-1506057213367-028a17ec52e5.avif")
# file3 = File.open("#{ROOT_PATH}/photo-1522140607231-7c05952eb779.avif")
# file4 = File.open("#{ROOT_PATH}/Big_Buck_Bunny_1080_10s_10MB.mp4")
# files = [file1 , file2 , file3 , file4 ]
# file_names  = ["pic1.avif" ,"pic2.avif" ,"pic3.avif" ,"bunny.mp4" ]
# content_types = ["image/avif" , "image/avif" ,"image/avif", "video/mp4"]  

# users.each do |user|
#   factor = 1
#   rand(15..25).times do |i|
#     post = user.posts.new(
#         caption: "Post #{i + 1} for #{user.first_name}",
#         body: "This is the body text for post #{i + 1}. It is associated with #{user.first_name} #{user.last_name}.",
#         user: user
#       )
#     if( (i % factor) == 0 )
#       r = rand(0..3)
#       post.media.attach(io: files[r] , filename: file_names[r] , content_type: content_types[r]) 
#     end
#     post.save
#     factor += 1
    
#   end
# end

