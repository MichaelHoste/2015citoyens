class User < ActiveRecord::Base

  # Attached files
  mount_uploader :picture, PictureUploader

  # Validations
  validates :f_id, :uniqueness => true

  # Callbacks

  # Scopes

  def self.published
    User.where(:published => true)
  end

  # Methods

  def self.from_omniauth(auth)
    User.where(:f_id => auth.uid).first_or_initialize.tap do |user|
      user.f_id           = auth.uid
      user.name           = auth.info.name                    if auth.info.name
      user.email          = auth.info.email                   if auth.info.email
      user.gender         = auth.extra.raw_info.gender        if auth.extra.raw_info.gender
      user.locale         = auth.extra.raw_info.locale        if auth.extra.raw_info.locale
      user.picture_link   = auth.info.image                   if auth.info.image
      user.f_token        = auth.credentials.token
      user.f_expires      = auth.credentials.expires
      user.f_expires_at   = Time.at(auth.credentials.expires_at)
      user.f_first_name   = auth.info.first_name              if auth.info.first_name
      user.f_middle_name  = auth.info.middle_name             if auth.info.middle_name
      user.f_last_name    = auth.info.last_name               if auth.info.last_name
      user.f_username     = auth.extra.raw_info.username      if auth.extra.raw_info.username
      user.f_link         = auth.extra.raw_info.link          if auth.extra.raw_info.link
      user.f_location     = auth.extra.raw_info.location.name if auth.extra.raw_info.location
      user.f_location_id  = auth.extra.raw_info.location.id   if auth.extra.raw_info.location
      user.f_timezone     = auth.extra.raw_info.timezone      if auth.extra.raw_info.location
      user.f_updated_time = auth.extra.raw_info.updated_time  if auth.extra.raw_info.updated_time
      user.f_verified     = auth.extra.raw_info.verified      if auth.extra.raw_info.verified

      user.remote_picture_url = user.profile_picture(size = 1000)

      user.save!
    end
  end

  def publish!
    if self.published == true
      return false
    end

    remaining = 2015 - User.published.count

    if remaining > 0
      target_position = rand(0..remaining-1)

      (0..40).to_a.each do |i|   # 400 included because 2000 + 15
        (0..49).to_a.each do |j|
          if User.where(:x => i, :y => j).empty?
            if target_position == 0
              self.x = i
              self.y = j
              self.published = true
              self.save!
              return true
            else
              target_position = target_position - 1
            end
          end
        end
      end
    end

    return false
  end

  def profile_picture(size = "square")
    arg = (size.is_a? Integer) ? "width=#{size}" : "type=#{size}"
    "https://graph.facebook.com/#{self.f_id}/picture?#{arg}"
  end
end
