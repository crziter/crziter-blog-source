# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc::Memoization
include Nanoc::Helpers::Rendering 

module VariousHelpper
	def current_time
		Time.now.strftime("%d/%m/%Y - %H:%M +0700 UTC")
	end

	def get_beauti_time(post)
		attribute_to_time(post[:created_at]).strftime("%Y-%m-%d")
	end

	def all_categories(posts=articles)
		cats = []
		posts.each do |article|
			next if article[:categories].nil?
			cats << article[:categories]
		end
		cats.flatten.compact.uniq
	end
	memoize :all_categories

	def has_category?(category, article)
		if article[:categories].nil?
			false
		else
			article[:categories].include?(category)
		end
	end

	def articles_with_category(category, posts=articles)
		posts.select { |article| has_category?(category, article) }
	end
	memoize :articles_with_category

	def articles_by_category(posts=articles)
		cats = []
		all_categories.each do |cat|
			cats << [cat, articles_with_category(cat)]
		end
		cats
	end
	memoize :articles_by_category

	def link_categories(cats)
		links = []
		cats.each do |cat|
			if not (cat == 'blog' or cat == 'project' or cat == 'done')
				links << ['<a href="/chuyen-muc/', cat, '">', cat, '</a>'].join
			end
		end
		links

		#cats.map do |cat|
		#	if not (cat == 'blog' or cat == 'project' or cat == 'done')
		#		['<a href="/chuyen-muc/', cat, '">', cat, '</a>'].join
		#	end
		#end
	end

	def create_category_pages
	  articles_by_category.each do |category, posts|
	  	if category == 'blog' or category == 'project'
	  	else
		    @items << Nanoc::Item.new(
"
%div#blog-wrapper
	%div#blog-caption
		Các bài trong chuyên mục: #{category}
	%div#blog-content
		- @item[:posts].each do |post|
			%p.blog-link
				=get_beauti_time(post)
				\-
				=link_to post[:title], post.path
",
		      {
		        :title => "Bài viết trong #{category}",
		        :page => "cat-page",
		        :posts => posts,
		        :page => "blog"
		      },
		      "/chuyen-muc/#{category}",
		      :binary => false
		    )
		end
	  end
	end
end

include VariousHelpper
include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::LinkTo
# include Nanoc::Helpers::Tagging