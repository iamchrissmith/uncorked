class User < ApplicationRecord
  has_secure_password

  validates_presence_of :first_name, :last_name, :username, :email, :phone_number, :country_code
  validates_uniqueness_of :username

  enum role: %w(member manager admin)

  has_many :user_venues, as: :manager
  has_many :venues, through: :user_venues

  has_many :user_badges
  has_many :badges, through: :user_badges

  has_many :reviews
  has_many :follows
  has_many :followed_venues, :through => :follows, :source => :target, :source_type => 'Venue'

  def self.from_omniauth(auth)
    user = find_or_create_by(uid: auth[:uid]) do |user|
      user.uid            = auth["uid"]
      user.first_name     = auth["info"]["name"].split(" ").first
      user.last_name      = auth["info"]["name"].split(" ").last
      user.username       = auth["info"]["name"]
      user.email          = auth["info"]["email"]
      user.phone_number   = 0000000
      user.country_code   = 000
      user.password       = "password"
    end
  end

  def verified?
    verified
  end

  def name
    "#{first_name} #{last_name}"
  end

  def manager_has_venues_with_wine?(wine)
    !(venues & wine.venues).empty?
  end

  def followed(target)
    self.follows.where(target: target).first
  end

  def get_follow(target)
    follows.where(target: target)[0]
  end

  def followers
    Follow.where(target: self)
  end

  def news_feed
    enricher = StreamRails::Enrich.new
    feed = StreamRails.feed_manager.get_news_feeds(id)[:flat]
    results = feed.get()['results']
    enricher.enrich_activities(results)
  end
end
