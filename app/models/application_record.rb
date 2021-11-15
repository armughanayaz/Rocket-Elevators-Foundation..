class ApplicationRecord < ActiveRecord::Base
  helper_method :watson
  self.abstract_class = true
  def watson
    "hello"
  end
end
