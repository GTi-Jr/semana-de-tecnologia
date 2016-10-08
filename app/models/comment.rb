class Comment < ActiveRecord::Base
  validates_presence_of :title, :description

  def posted_on
    self.created_at.strftime("Postado em %H:%M %d/%m/%Y")
  end
end
