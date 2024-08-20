module Helper
  module SpreadsheetHelpers
    def write_file(sheet,user)
      file_path = "#{Rails.root}/sheet/sheet-#{user.id}.xls"
      sheet.write file_path
      user.report.attach(io: File.open("#{Rails.root}/sheet/sheet-#{user.id}.xls") , filename: "report-#{user.id}.xls")
      if !user.save
        raise "Report Generation Failed"
      end
      File.delete(file_path)
    end

    def report_generation(user)
      worksheet = Spreadsheet::Workbook.new

      post_sheet = worksheet.create_worksheet :name => 'Posts'
      post_sheet.row(0).push "Caption" , "Body" , "Created-at" , "updated-at"
      user.posts.each_with_index do |post , i |
        post_sheet.row(i+1).push post.caption , post.body , post.created_at 
      end

      follower_sheet = worksheet.create_worksheet :name => 'Followers'
      follower_sheet.row(0).push "Follow to" ,"Bio" , "Email", "date" 
      user.followers.each_with_index do |follower , i |
        follower_sheet.row(i+1).push follower.follow_by.username , follower.follow_by.bio , follower.follow_by.email,follower.created_at 
      end
      write_file worksheet,user
    end

  end
end
 
