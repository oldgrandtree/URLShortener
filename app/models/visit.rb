class Visit < ActiveRecord::Base
  belongs_to(
  :visitor,
  class_name: "User",
  foreign_key: :user_id,
  primary_key: :id
  )
  
  belongs_to(
  :shortened_url,
  class_name: "ShortenedUrl",
  foreign_key: :shortened_url_id,
  primary_key: :id
  )

  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user.id, shortened_url_id: shortened_url.id) 
  end  
end

# a.visits.group(:long_url).order('COUNT(*) desc')