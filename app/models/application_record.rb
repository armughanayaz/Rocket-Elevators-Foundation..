class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def watson
    "hello"
  end
end
