class Employee < ApplicationRecord
    belongs_to :user
    has_many :batteries

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
