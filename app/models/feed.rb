class Feed

  def initialize(attrs)
    @user_id = attrs[:user_id]
    @target_type = attrs[:target_type]
    @target_id = attrs[:target_id]
    @target_feed = attrs[:target_feed]
    @user_feed ||= StreamRails.client.feed('user', user_id)
  end

  def follow
    user_feed.follow(target_feed, target_id)
    report_activity( default_activity_data.merge( verb: 'follow' ) )
  end

  def unfollow
    user_feed.unfollow(target_feed, target_id)
    report_activity( default_activity_data.merge( verb: 'unfollow' ) )
  end

  def review
    report_activity( default_activity_data.merge( verb: 'review' ) )
  end

  private
    attr_reader :user_feed,
                :user_id,
                :target_type,
                :target_id,
                :target_feed,
                :verb

    def report_activity(data)
      binding.pry
      user_feed.add_activity(data)
    end

    def default_activity_data
      {
        actor: "User:#{user_id}",
        object: "#{target_type}:#{target_id}",
        foreign_id: "#{target_type}:#{target_id}",
        time: DateTime.now,
        to: ["#{target_feed}:#{target_id}"]
      }
    end
end
