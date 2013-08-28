require 'stringex'

task :new_post do |t, args|
	print "Is a project? [y/n]: "
	prj = STDIN.gets.strip
	is_project = true
	if prj == 'n' 
		is_project = false
	end
	
	print "Title: "
	title = STDIN.gets.strip
	
	filename = ""
	if is_project
		filename = "./content/projects/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.haml"
	else
		filename = "./content/posts/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.haml"
	end
	
	if File.exist?(filename)
		abort('rake aborted!') if ask("#{filename} already exists. Want to overwrite?", ['y','n']) == 'n'
	end
	
	categories = []
	cat = ""

	puts "Enter categories: "
	begin
		cat = STDIN.gets.strip
		if cat == ""
			break
		end
		
		categories << cat
	end while true
	
	categories[0] = "- " + categories[0]
	puts "Creating new post ..."
	open(filename, 'w') do |post|
		post.puts '---'
		post.puts "title: \"#{title}\""
		post.puts "created_at: #{Time.now}"
		post.puts 'kind: article'
		post.puts 'page: post'
		post.puts 'categories:'
		post.puts categories.join("\n- ")
		post.puts "---\n\n"
		post.puts "Chỉnh sửa tập tin này để có nội dung..."
	end
	puts "Done"
end
