module MozaicService
  def self.create
    (0..40).to_a.each do |i|   # 400 included because 2000 + 15
      (0..49).to_a.each do |j|
        user = User.where(:x => i, :y => j)
        if user.empty?
          FileUtils.cp(Rails.root.join("app", "assets", 'images', 'empty.jpg'), Rails.root.join("tmp", sprintf('%04d.jpg', i*50+j)))
        else
          FileUtils.cp(user.first.picture.mozaic.current_path, Rails.root.join("tmp", sprintf('%04d.jpg', i*50+j)))
        end
      end
    end

    `cd tmp && montage *.jpg -tile 50x41 -geometry 15x15+0+0 mozaic.jpg`
    `composite -blend 20 app/assets/images/mons2015.jpg tmp/mozaic.jpg tmp/mozaic2.jpg`
    `cp tmp/mozaic2.jpg public/pictures/mozaic-#{User.published.count}.jpg`
    `cp tmp/mozaic2.jpg public/pictures/mozaic.jpg`
    `rm tmp/*.jpg`
  end
end

