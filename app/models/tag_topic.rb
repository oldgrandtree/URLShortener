class TagTopic < ActiveRecord::Base
  has_many(
  :taggings,
  class_name: "Tagging",
  foreign_key: :tag_topic_id,
  primary_key: :id)

  has_many :shortened_urls, through: :taggings, source: :shortened_url
  
  has_many :visits, through: :shortened_urls, source: :visits
  
  def most_popular(n)
    ShortenedUrl.select('*')
      .joins(:tag, :visits)
      .where("tag_topics.id=#{self.id}")
      .group(:long_url)
      .order('COUNT(*) DESC')
      .limit(n)
      .map { |x| x.long_url }
  end
end
