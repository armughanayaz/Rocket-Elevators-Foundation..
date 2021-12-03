class Batterie < ApplicationRecord
    belongs_to :building
    belongs_to :employee
    
    has_many :columns
end
