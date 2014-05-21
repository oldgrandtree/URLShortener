class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  
  has_many(
  :shortened_urls,
  class_name: "ShortenedUrl",
  foreign_key: :submitter_id,
  primary_key: :id
  ) 
  
  has_many(
  :visits,
  class_name: "Visit",
  foreign_key: :user_id,
  primary_key: :id
  )
  
  has_many :visited_shortened_urls,  -> { distinct }, through: :visits, 
    source: :shortened_url
  
end
