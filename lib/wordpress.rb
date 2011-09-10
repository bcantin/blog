require 'rubygems'
require 'fileutils'
require 'nokogiri'

class Wordpress
  attr_accessor :scroll
  
  def initialize(scroll)
    @scroll = scroll
  end
  
  def renounce
    doc = Nokogiri::XML(File.open(@scroll))
    
    post_count = 0
    comment_count = 0
    draft_count = 0

    #Import Wordpress Posts to Blogcast
    puts ""
    puts "------>>Posts, the wind blows strong in your favor apprentice."
    doc.xpath("//item[wp:post_type[text() = 'post'] and wp:status[text() = 'publish']]").each do |item|
      post = Post.new
      
      post.title        = item.xpath("title").text
      post.content      = item.xpath("content:encoded").text
      post.markdown     = item.xpath("content:encoded").text
      post.author       = item.xpath("dc:creator").text
      post.commentable  = item.xpath("wp:comment_status").text == 'open' ? true : false
      post.posted_at    = item.xpath("wp:post_date").text
      post.created_at   = item.xpath("wp:post_date").text
      post.updated_at   = item.xpath("wp:post_date").text
      
      post.save

      item.xpath("wp:comment[wp:comment_approved[text() = '1'] and not(wp:comment_type[text() = 'pingback'])]").each do |node|
        comment = post.comments.build
        
        comment.name          = node.xpath("wp:comment_author").text
        comment.email         = node.xpath("wp:comment_author_email").text
        comment.website       = node.xpath("wp:comment_author_url").text
        comment.user_ip       = node.xpath("wp:comment_author_IP").text
        comment.content       = node.xpath("wp:comment_content").text
        comment.created_at    = node.xpath("wp:comment_date").text
        comment.updated_at    = node.xpath("wp:comment_date").text
        comment.comment_type  = "comment"
        comment.admin         = node.xpath("wp:comment_author").text == post.author ? true : false
        
        comment.save
        
        comment_count += 1
      end
      
      post_count += 1
    end
    
    puts "------>>I have paid the Ferryman on your behalf."
    puts "------>>Posts saved: #{post_count}"
    puts "------>>Comments saved: #{comment_count}"
    
    #Import Wordpress Drafts to Blogcast
    puts ""
    puts "------>>Drafts, find your redemption through prayer and reflection."
    doc.xpath("//item[wp:post_type[text() = 'post'] and wp:status[text() = 'draft']]").each do |item|
      draft = Draft.new
      
      draft.title        = item.xpath("title").text == '' ? 'Please give this Draft a title.' : item.xpath("title").text
      draft.content      = item.xpath("content:encoded").text == '' ? 'Please give this Draft some content.' : item.xpath("content:encoded").text
      draft.markdown     = item.xpath("content:encoded").text == '' ? 'Please give this Draft some content.' : item.xpath("content:encoded").text
      draft.author       = item.xpath("dc:creator").text
      draft.created_at   = item.xpath("wp:post_date").text
      draft.updated_at   = item.xpath("wp:post_date").text
      
      draft.save
      
      draft_count += 1
    end
    
    puts "------>>Go now. On the other side you have only yourself to face."
    puts "------>>Drafts saved: #{draft_count}"
    puts ""
  end
end