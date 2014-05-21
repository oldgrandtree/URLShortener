class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :short_url, :submitter_id, presence: true
  validates :short_url, uniqueness: true  
  
  belongs_to(
  :submitter,
  class_name: "User",
  foreign_key: :submitter_id,
  primary_key: :id
  )
  
  has_many(
  :visits,
  class_name: "Visit",
  foreign_key: :shortened_url_id,
  primary_key: :id
  )
  
  has_one(
  :tagging,
  class_name: "Tagging",
  foreign_key: :shortened_url_id,
  primary_key: :id
  )
  
  has_one :tag, through: :tagging, source: :tag_topic
  
  has_many :visitors,  -> { distinct }, through: :visits, source: :visitor
  
  def self.random_code
    code = SecureRandom::urlsafe_base64
    until ShortenedUrl.find_by(short_url: code).nil?
      code = SecureRandom::urlsafe_base64 
    end
    
    code
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create!(long_url: long_url, short_url: short_url, 
    submitter_id: user.id)
  end
  
  def num_clicks
    self.visits.count
  end
  
  def num_uniques
    self.visitors.count
    #Visit.where(shortened_url_id: self.id).distinct.count(:user_id)
  end
  
  def num_recent_uniques
    Visit.where(shortened_url_id: self.id, 
      created_at: (10.minutes.ago..Time.now)).distinct.count(:user_id)
  end
end
